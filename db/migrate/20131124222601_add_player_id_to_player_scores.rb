class AddPlayerIdToPlayerScores < ActiveRecord::Migration
  def change
    add_column :player_scores, :player_id, :integer
  end
end
