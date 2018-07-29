require 'rails_helper'
require_relative '../../app/models/task'
require_relative '../shared/examples/CRUD_actions'
require_relative '../shared/examples/update_position'

RSpec.describe 'Tasks', type: :request do
  describe 'CRUD actions' do
    include_examples 'CRUD actions', Task, :column
  end
  describe 'update position' do
    include_examples 'update position', Task, :column
  end
end
