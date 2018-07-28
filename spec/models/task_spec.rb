require_relative '../helpers/test_helper'
require_relative '../../app/models/task'
require_relative '../shared/examples/basic_model_actions'

RSpec.describe 'Task' do
  include_examples 'basic model actions', Task
end