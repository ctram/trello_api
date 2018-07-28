class Board < ApplicationRecord
  validates_presence_of :name, :title
  has_many :columns, dependent: :destroy
end
