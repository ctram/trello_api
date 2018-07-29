require 'rails_helper'
require_relative '../contexts/authorization_headers'
require_relative '../contexts/test_objects'
require_relative './check_authorization'

RSpec.shared_examples 'CRUD actions' do |model, parent_name = nil|
  let(:model_name) { model.to_s.downcase }
  let(:model_name_plural) { model_name + 's' }
  let(:parent) do
    {
      board: board,
      column: column,
      task: task
    }[parent_name]
  end

  before(:example) do
    %w[one two three].map do |num|
      FactoryBot.create(model.to_s.downcase.to_sym, title: num, name: num)
    end
  end

  after(:example) do
    model.destroy_all
  end

  def path1(model, parent = nil)
    return boards_url if model == Board
    send("#{parent.class.to_s.downcase}_#{model.to_s.downcase}s_url", parent.id)
  end

  def path2(object)
    send("#{object.class.to_s.downcase}_url", object.id)
  end

  include_examples 'check authorization', :index, model
  include_examples 'check authorization', :create, model
  include_examples 'check authorization', :show, model
  include_examples 'check authorization', :update, model
  include_examples 'check authorization', :destroy, model

  include_context 'authorization headers'
  include_context 'test objects'

  it 'GET index' do
    get path1(model, parent), params: {}, headers: authorization_headers
    expect(response).to have_http_status(200)
    expect(JSON.parse(response.body).count).to be 4
    expect(response.body).to eq(model.all.to_json)
  end

  it 'GET show' do
    get path2(model.first), params: {}, headers: authorization_headers
    expect(response.body).to eq(model.first.to_json)
  end

  it 'POST create' do
    params = {}
    params[model.to_s.downcase] = { title: 'Batman', name: 'Bruce Wayne' }
    post path1(model, parent), params: params, headers: authorization_headers
    expect(response.body).to eq(model.last.to_json)
    expect(response).to have_http_status(201)
    expect(model.count).to be 5
  end

  it 'PUT update' do
    params = {}
    params[model_name] = { title: 'Updated title', name: 'Updated name' }
    put path2(model.first), params: params, headers: authorization_headers
    expect(response.body).to eq(model.first.to_json)
    expect(response).to have_http_status(200)
    expect(model.count).to be 3
    expect(model.first.name).to eq('Updated name')
    expect(model.first.title).to eq('Updated title')
  end

  it 'DELETE destroy' do
    delete path2(model.first), params: {}, headers: authorization_headers
    expect(response).to have_http_status(204)
    expect(response.body).to be_empty
    expect(model.count).to be 2
    expect(model.where(title: 'One').count).to be 0
  end
end
