require_relative '../contexts/authorization_headers'

RSpec.shared_examples 'update position' do |child_class, parent_type|
  include_context 'authorization headers'
  
  let(:parent) { FactoryBot.create parent_type }
  
  before(:example) do
    parent_name = parent.class.to_s.downcase

    5.times do |idx|
      model = FactoryBot.build child_class.to_s.downcase
      data = { name: "prev #{idx}" }
      data[parent_name + '_id'] = parent.id
      model.update(data)
    end
  end

  def children(child_class, parent)
    parent.send(child_class.to_s.downcase + 's')
  end

  def resource_url(model)
    send(model.class.to_s.downcase + '_url', model.id)
  end

  it 'cannot move below position 0' do
    children = children(child_class, parent)
    model = children[2]
    params = {}
    params[model.class.to_s.downcase] = { position: -1 }
    put resource_url(model), params: params, headers: authorization_headers
    expect(response).to have_http_status(422)
  end

  it 'cannot move to position greater than list length' do
    children = children(child_class, parent)
    model = children[2]
    params = {}
    params[model.class.to_s.downcase] = { position: 5 }
    put resource_url(model), params: params, headers: authorization_headers
    expect(response).to have_http_status(422)
  end

  it 'moves from 2 to 0 and its sibling positions are updated' do
    children = children(child_class, parent)
    model = children[2]
    params = {}
    params[model.class.to_s.downcase] = { position: 0 }
    put resource_url(model), params: params, headers: authorization_headers
    children.reload
    expect(response).to have_http_status(200)
    expect(children[0].name).to eq('prev 2')
    expect(children[1].name).to eq('prev 0')
    expect(children[2].name).to eq('prev 1')
    expect(children[3].name).to eq('prev 3')
    expect(children[4].name).to eq('prev 4')
    expect(JSON.parse(response.body)['position']).to eq(0)
  end

  it 'moves from 4 to 0 and its sibling positions are updated' do
    children = children(child_class, parent)
    model = children[4]
    params = {}
    params[model.class.to_s.downcase] = { position: 0 }
    put resource_url(model), params: params, headers: authorization_headers
    children.reload
    expect(response).to have_http_status(200)
    expect(children[0].name).to eq('prev 4')
    expect(children[1].name).to eq('prev 0')
    expect(children[2].name).to eq('prev 1')
    expect(children[3].name).to eq('prev 2')
    expect(children[4].name).to eq('prev 3')
    expect(JSON.parse(response.body)['position']).to eq(0)
  end

  it 'moves from 0 to 4 and its sibling positions are updated' do
    children = children(child_class, parent)
    model = children[0]
    params = {}
    params[model.class.to_s.downcase] = { position: 4 }
    put resource_url(model), params: params, headers: authorization_headers
    children.reload
    expect(response).to have_http_status(200)
    expect(children[0].name).to eq('prev 1')
    expect(children[1].name).to eq('prev 2')
    expect(children[2].name).to eq('prev 3')
    expect(children[3].name).to eq('prev 4')
    expect(children[4].name).to eq('prev 0')
    expect(JSON.parse(response.body)['position']).to eq(4)
  end
end
