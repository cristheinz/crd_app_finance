class CreateTracks < ActiveRecord::Migration
  def change
    create_table :tracks do |t|
      t.integer :expense_id
      t.datetime :date
      t.decimal :value
      t.string :status

      t.timestamps
    end
    add_index :tracks, [:expense_id, :date]
  end
end
