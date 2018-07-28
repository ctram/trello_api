class Comment < ApplicationRecord
  validates_presence_of :content, :task_id
end
