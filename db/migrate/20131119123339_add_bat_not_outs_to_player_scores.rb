class AddBatNotOutsToPlayerScores < ActiveRecord::Migration
  def change
    add_column :player_scores, :bat_not_outs, :integer
  end
end
