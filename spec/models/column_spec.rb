require_relative '../helpers/test_helper'
require_relative '../../app/models/column'
require_relative '../shared/examples/basic_model_actions'

RSpec.describe 'Column' do
  include_examples 'basic model actions', Column
end