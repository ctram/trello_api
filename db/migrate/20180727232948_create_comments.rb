class CreateComments < ActiveRecord::Migration[5.0]
  def change
    create_table :comments do |t|
      t.string :title, null: false
      t.string :name, null: false
      t.integer :task_id, null: false
      t.timestamps
    end
  end
end
