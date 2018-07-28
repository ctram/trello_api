require_relative '../helpers/test_helper'
require_relative '../../app/models/board'
require_relative '../shared/basic_model_actions'

RSpec.describe Board do
  include_examples 'basic model actions', Board
end