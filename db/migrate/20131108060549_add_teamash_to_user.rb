class AddTeamashToUser < ActiveRecord::Migration
  def change
    add_column :users, :teamcash, :integer
  end
end
