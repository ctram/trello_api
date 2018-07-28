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

  it 'GET /boards' do
    get '/boards', params: {}, headers: authorization_headers
    expect(response).to have_http_status(200)
    expect(JSON.parse(response.body).count).to be 3
  end
end
