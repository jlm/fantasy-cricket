class AddValidatedToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :validated, :boolean
  end
end
