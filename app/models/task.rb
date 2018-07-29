class Task < ApplicationRecord
  include Positionable

  validates :position, numericality: { only_integers: true }
  validate :valid_position
  validates_presence_of :title, :name, :column_id, :position

  has_many :comments, dependent: :destroy
  belongs_to :column

  before_validation do
    ensure_position_exists
  end

  def siblings
    column.tasks.where.not(id: id)
  end
end