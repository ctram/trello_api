require 'rails_helper'
require_relative '../../app/models/column'
require_relative '../shared/examples/CRUD_actions'
require_relative '../shared/examples/update_position'

RSpec.describe 'Columns', type: :request do
  describe 'CRUD actions' do
    include_examples 'CRUD actions', Column, :board
  end
  describe 'update position' do
    include_examples 'update position', Column, :board
  end
end
