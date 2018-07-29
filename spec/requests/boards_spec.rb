require 'rails_helper'
require_relative '../../app/models/board'
require_relative '../shared/examples/CRUD_actions'

RSpec.describe 'Boards', type: :request do
  include_examples 'CRUD actions', Board
end
