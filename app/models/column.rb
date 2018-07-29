class Column < ApplicationRecord
  include Positionable

  validates_presence_of :name, :title, :board_id, :position
  has_many :tasks, -> { order 'position ASC' }, dependent: :destroy
  belongs_to :board

  def siblings
    board.columns
  end
end
