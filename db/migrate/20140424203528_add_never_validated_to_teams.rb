class AddNeverValidatedToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :never_validated, :boolean
  end
end
