class Column < ApplicationRecord
  include Positionable

  validates_presence_of :name, :title, :board_id, :position
  has_many :tasks, -> { order 'position ASC' }, dependent: :destroy
  belongs_to :board

  before_validation do
    ensure_position_exists
  end

  def siblings
    board.columns
  end
end
