class AddDropAvailableToUsers < ActiveRecord::Migration
  def change
    add_column :users, :drop_available, :boolean
  end
end
