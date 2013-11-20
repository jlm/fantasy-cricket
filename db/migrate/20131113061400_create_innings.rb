class CreateInnings < ActiveRecord::Migration
  def change
    create_table :innings do |t|
      t.string :matchname
      t.string :date
      t.string :inningsname
      t.integer :innings_id

      t.timestamps
    end
    add_index :innings, :innings_id, unique: true
  end
end
