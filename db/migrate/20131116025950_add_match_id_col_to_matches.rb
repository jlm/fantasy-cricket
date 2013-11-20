class AddMatchIdColToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :match_id, :decimal
    add_index :matches, :match_id, unique: true
  end
end
