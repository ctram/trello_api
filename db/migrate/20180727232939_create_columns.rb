class CreateColumns < ActiveRecord::Migration[5.0]
  def change
    create_table :columns do |t|
      t.string :title, null: false
      t.string :name, null: false
      t.integer :board_id, null: false
      t.timestamps
    end
  end
end
