class AddTotalToPlayer < ActiveRecord::Migration
  def change
    add_column :players, :total, :integer
  end
end
