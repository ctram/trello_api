class Comment < ApplicationRecord
  validates_presence_of :content, :task_id
  belongs_to :task
end
