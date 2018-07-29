require 'rails_helper'
require_relative '../../app/models/column'
require_relative '../shared/examples/CRUD_actions'

RSpec.describe 'Columns', type: :request do
  include_examples 'CRUD actions', Column, :board
end
