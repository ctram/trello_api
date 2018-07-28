require 'rails_helper'
require_relative '../shared/contexts/authorization_headers'
require_relative '../shared/examples/check_authorization'

RSpec.shared_examples 'CRUD actions' do |model, action_data|
  let(:model_name) { model.to_s.downcase }
  let(:model_name_plural) { model_name + 's' }

  before do
    %w[one two three].each do |num|
      model.create(name: num, title: num)
    end
  end

  after do
    model.destroy_all
  end

  include_examples 'check authorization', :get, "/#{model_name_plural}"
  include_examples 'check authorization', :post, "/#{model_name_plural}"
  include_examples 'check authorization', :get, "/#{model_name_plural}/1"
  include_examples 'check authorization', :put, "/#{model_name_plural}/1"
  include_examples 'check authorization', :delete, "/#{model_name_plural}/1"

  include_context 'authorization headers'

  it 'GET index' do
    get "/#{model_name_plural}", params: {}, headers: authorization_headers
    expect(response).to have_http_status(200)
    expect(JSON.parse(response.body).count).to be 3
    expect(response.body).to eq(model.all.to_json)
  end

  it 'GET show' do
    get "/#{model_name_plural}/#{model.all.first.id}", params: {}, headers: authorization_headers
    expect(response.body).to eq(model.first.to_json)
  end

  it 'POST create' do
    post "/#{model_name_plural}", params: { board: { title: 'Batman', name: 'Bruce Wayne' } }, headers: authorization_headers
    expect(response.body).to eq(model.last.to_json)
    expect(response).to have_http_status(201)
    expect(model.count).to be 4
  end

  it 'PUT update' do
    params = {}
    params[model_name] = { title: 'Updated title', name: 'Updated name' }
    put "/#{model_name_plural}/#{model.all.first.id}", params: params, headers: authorization_headers
    expect(response.body).to eq(model.first.to_json)
    expect(response).to have_http_status(200)
    expect(model.count).to be 3
    expect(model.first.name).to eq('Updated name')
    expect(model.first.title).to eq('Updated title')
  end

  it 'DELETE destroy' do
    delete "/#{model_name_plural}/#{model.all.first.id}", params: {}, headers: authorization_headers
    expect(response).to have_http_status(204)
    expect(response.body).to be_empty
    expect(model.count).to be 2
    expect(model.where(title: 'One').count).to be 0
  end
end
