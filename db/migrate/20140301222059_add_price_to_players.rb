class AddPriceToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :price, :integer
  end
end
