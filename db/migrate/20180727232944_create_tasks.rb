class CreateTasks < ActiveRecord::Migration[5.0]
  def change
    create_table :tasks do |t|
      t.string :title, null: false
      t.string :name, null: false
      t.integer :column_id, null: false
      t.timestamps
    end
  end
end
