require 'rails_helper'
require_relative '../../app/models/task'
require_relative '../shared/examples/CRUD_actions'

RSpec.describe 'Tasks', type: :request do
  include_examples 'CRUD actions', Task, :column
end
