class Column < ApplicationRecord
  validates_presence_of :name, :title, :board_id
  has_many :tasks, dependent: :destroy
  belongs_to :board
end
