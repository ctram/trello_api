class Column < ApplicationRecord
  include Positionable

  validates :position, numericality: { only_integers: true }
  validate :valid_position
  validates_presence_of :name, :title, :board_id, :position

  has_many :tasks, -> { order 'position ASC' }, dependent: :destroy
  belongs_to :board

  before_validation do
    ensure_position_exists
  end

  def siblings
    board.columns.where.not(id: id)
  end
end
