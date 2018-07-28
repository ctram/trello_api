require 'rails_helper'
require_relative '../shared/contexts/authorization_headers'
require_relative '../shared/examples/check_authorization'

RSpec.describe 'Boards', type: :request do
  before do
    %w[one two three].each do |num|
      Board.create(name: num, title: num)
    end
  end

  after do
    Board.destroy_all
  end

  include_examples 'check authorization', :get, '/boards'
  include_examples 'check authorization', :post, '/boards'
  include_examples 'check authorization', :get, '/boards/1'
  include_examples 'check authorization', :put, '/boards/1'
  include_examples 'check authorization', :delete, '/boards/1'

  include_context 'authorization headers'

  it 'GET index' do
    get '/boards', params: {}, headers: authorization_headers
    expect(response).to have_http_status(200)
    expect(JSON.parse(response.body).count).to be 3
    expect( response.body).to eq(Board.all.to_json)
  end

  it 'GET show' do
    get "/boards/#{Board.all.first.id}", params: {}, headers: authorization_headers
    expect(response.body).to eq(Board.first.to_json)
  end

  it 'POST create' do
    post '/boards', params: { board: { title: 'Batman', name: 'Bruce Wayne' } }, headers: authorization_headers
    expect(response.body).to eq(Board.last.to_json)
    expect(response).to have_http_status(201)
    expect(Board.count).to be 4
  end

  it 'PUT update' do
    put "/boards/#{Board.all.first.id}", params: { board: { title: 'Updated title', name: 'Updated name' } }, headers: authorization_headers
    expect(response.body).to eq(Board.first.to_json)
    expect(response).to have_http_status(200)
    expect(Board.count).to be 3
    expect(Board.first.name).to eq('Updated name')
    expect(Board.first.title).to eq('Updated title')
  end

  it 'DELETE destroy' do
    delete "/boards/#{Board.all.first.id}", params: {}, headers: authorization_headers
    expect(response).to have_http_status(204)
    expect(response.body).to be_empty
    expect(Board.count).to be 2
    expect(Board.where(title: 'One').count).to be 0
  end
end
