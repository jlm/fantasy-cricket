class AddKeeperIdToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :keeper_id, :integer
  end
end
