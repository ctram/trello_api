class Task < ApplicationRecord
  validates_presence_of :title, :name, :column_id
end
