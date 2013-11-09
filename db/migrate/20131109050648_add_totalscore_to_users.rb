class AddTotalscoreToUsers < ActiveRecord::Migration
  def change
    add_column :users, :totalscore, :integer
  end
end
