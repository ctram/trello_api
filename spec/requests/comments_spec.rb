require 'rails_helper'
require_relative '../../app/models/comment'
require_relative '../../app/models/task'
require_relative '../shared/contexts/authorization_headers'
require_relative '../shared/contexts/test_objects'
require_relative '../shared/examples/check_authorization'

RSpec.describe 'Comments', type: :request do

  before do
    %w[one two three].each do |content|
      task.comments.create(content: content)
    end
  end
  
  after do
    Comment.destroy_all
  end
  
  include_examples 'check authorization', :index, Comment
  include_examples 'check authorization', :create, Comment
  include_examples 'check authorization', :show, Comment
  include_examples 'check authorization', :update, Comment
  include_examples 'check authorization', :destroy, Comment

  include_context 'test objects'
  include_context 'authorization headers'


  it 'GET index' do
    get "/tasks/#{task.id}/comments", params: {}, headers: authorization_headers
    expect(response).to have_http_status(200)
    expect(JSON.parse(response.body).count).to be 4
    expect(response.body).to eq(Comment.all.to_json)
  end

  it 'GET show' do
    get "/comments/#{Comment.all.first.id}", params: {}, headers: authorization_headers
    expect(response.body).to eq(Comment.first.to_json)
  end

  it 'POST create' do
    post "/tasks/#{task.id}/comments", params: { comment: { content: 'Mr. Wayne' } }, headers: authorization_headers
    expect(response.body).to eq(Comment.last.to_json)
    expect(response).to have_http_status(201)
    expect(Comment.count).to be 5
  end

  it 'PUT update' do
    put "/comments/#{Comment.all.first.id}", params: { comment: { content: 'Mr. Wayne' } }, headers: authorization_headers
    expect(JSON.parse(response.body)['content']).to eq('Mr. Wayne')
    expect(Comment.first.content).to eq('Mr. Wayne')
    expect(response).to have_http_status(200)
    expect(Comment.count).to be 4
  end

  it 'DELETE destroy' do
    delete "/comments/#{Comment.all.first.id}", params: {}, headers: authorization_headers
    expect(response).to have_http_status(204)
    expect(response.body).to be_empty
    expect(Comment.count).to be 3
    expect(Comment.where(content: 'One').count).to be 0
  end
end
