class CreateExpenses < ActiveRecord::Migration
  def change
    create_table :expenses do |t|
      t.integer :user_id
      t.integer :label_id

      t.timestamps
    end
    add_index :expenses, :user_id
    add_index :expenses, :label_id
    add_index :expenses, [:user_id, :label_id], unique: true
  end
end
