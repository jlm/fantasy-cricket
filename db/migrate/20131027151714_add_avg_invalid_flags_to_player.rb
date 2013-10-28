class AddAvgInvalidFlagsToPlayer < ActiveRecord::Migration
  def change
    add_column :players, :bat_avg_invalid, :boolean
    add_column :players, :bowl_avg_invalid, :boolean
  end
end
