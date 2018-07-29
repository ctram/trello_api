class Task < ApplicationRecord
  include Positionable

  validates_presence_of :title, :name, :column_id, :position
  has_many :comments, dependent: :destroy
  belongs_to :column

  def siblings
    column.tasks
  end
end