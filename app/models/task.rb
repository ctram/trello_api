class Task < ApplicationRecord
  validates_presence_of :title, :name, :column_id
  has_many :comments, dependent: :destroy
  belongs_to :column
end
