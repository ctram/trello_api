class ApplicationController < ActionController::API
  before_action :check_authorization
  
  AUTHORIZED_API_TOKENS = %w[ehzLoAaX7hVUxJ2D3vLkxQ].freeze # ehzLoAaX7hVUxJ2D3vLkxQ

  def check_authorization
    render status: 401 unless authorized?
  end

  def authorized?
    AUTHORIZED_API_TOKENS.include? bearer_token
  end

  def bearer_token
    request.headers['Authorization'] && request.headers['Authorization'].split(' ').last
  end
end
