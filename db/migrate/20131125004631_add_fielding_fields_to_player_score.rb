class AddFieldingFieldsToPlayerScore < ActiveRecord::Migration
  def change
    add_column :player_scores, :field_drops, :integer
  end
end
