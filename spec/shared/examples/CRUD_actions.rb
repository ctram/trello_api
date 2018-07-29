require 'rails_helper'
require_relative '../contexts/authorization_headers'
require_relative './check_authorization'

RSpec.shared_examples 'CRUD actions' do |child_class, parent_type = nil|
  include_context 'authorization headers'

  let(:model_name)        { child_class.to_s.downcase }
  let(:model_name_plural) { model_name + 's' }
  let(:parent)            { FactoryBot.create parent_type }

  before(:example) do
    puts 'called in example'
    puts "before num columns: #{parent.columns.length}"
    %w[one two three].map do |num|
      parent.send(child_class.to_s.downcase + 's').create(title: num, name: num)
    end
    puts "after num columns: #{parent.columns.length}"
    puts "parent id : #{parent.id}"
  end

  def path1(child_class, parent = nil)
    return boards_url if child_class == Board
    send("#{parent.class.to_s.downcase}_#{child_class.to_s.downcase}s_url", parent.id)
  end

  def path2(object)
    send("#{object.class.to_s.downcase}_url", object.id)
  end

  describe 'check authorization' do
    include_examples 'check authorization', :index, child_class
    include_examples 'check authorization', :create, child_class
    include_examples 'check authorization', :show, child_class
    include_examples 'check authorization', :update, child_class
    include_examples 'check authorization', :destroy, child_class
  end

  it 'GET index' do
    puts "parent id : #{parent.id}"
    get path1(child_class, parent), params: {}, headers: authorization_headers
    expect(response).to have_http_status(200)
    expect(JSON.parse(response.body).length).to be 3
    expect(response.body).to eq(child_class.all.to_json)
  end

  it 'GET show' do
    get path2(child_class.first), params: {}, headers: authorization_headers
    expect(response.body).to eq(child_class.first.to_json)
  end

  it 'POST create' do
    params = {}
    params[child_class.to_s.downcase] = { title: 'Batman', name: 'Bruce Wayne' }
    post path1(child_class, parent), params: params, headers: authorization_headers
    expect(response.body).to eq(child_class.last.to_json)
    expect(response).to have_http_status(201)
    expect(child_class.all.length).to be 4
  end

  it 'PUT update' do
    params = {}
    params[model_name] = { title: 'Updated title', name: 'Updated name' }
    put path2(child_class.first), params: params, headers: authorization_headers
    expect(response).to have_http_status(200)
    expect(child_class.all.length).to be 3
    expect(JSON.parse(response.body)['title']).to eq('Updated title')
    expect(JSON.parse(response.body)['name']).to eq('Updated name')
    expect(child_class.first.name).to eq('Updated name')
    expect(child_class.first.title).to eq('Updated title')
  end

  it 'DELETE destroy' do
    delete path2(child_class.first), params: {}, headers: authorization_headers
    expect(response).to have_http_status(204)
    expect(response.body).to be_empty
    expect(child_class.all.length).to be 2
    expect(child_class.where(title: 'One').length).to be 0
  end
end
