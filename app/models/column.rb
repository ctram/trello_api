class Column < ApplicationRecord
  validates_presence_of :name, :title, :board_id
end
