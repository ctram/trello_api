class Board < ApplicationRecord
  validates_presence_of :name, :title
  has_many :columns, -> { order 'position ASC' }, dependent: :destroy
end
