class RemoveTitleNameFromCommentsAddContent < ActiveRecord::Migration[5.0]
  def change
    remove_column :comments, :title
    remove_column :comments, :name
    add_column :comments, :content, :text, null: false
  end
end
