class AddBatFieldsToPlayer < ActiveRecord::Migration
  def change
    add_column :players, :bat_fours, :integer
    add_column :players, :bat_sixes, :integer
  end
end
