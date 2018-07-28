require_relative '../test_helper'
require_relative '../../app/models/board'

RSpec.describe 'Board' do
  it 'requires name and title' do
    board = Board.new
    expect(board.valid?).to be false
  end
end