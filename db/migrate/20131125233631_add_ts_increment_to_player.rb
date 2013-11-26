class AddTsIncrementToPlayer < ActiveRecord::Migration
  def change
    add_column :players, :ts_increment, :integer
  end
end
