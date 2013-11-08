class AddTotalscoreToTeam < ActiveRecord::Migration
  def change
    add_column :teams, :totalscore, :integer
  end
end
