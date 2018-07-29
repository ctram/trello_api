require 'rails_helper'
require_relative '../../app/models/column'
require_relative '../shared/examples/CRUD_actions'
require_relative '../shared/examples/update_position'
require_relative '../shared/contexts/test_objects'

RSpec.describe 'Columns', type: :request do
  include_examples 'CRUD actions', Column, :board
  include_examples 'update position', Column, :board
end
