class AddPlayerCategoryToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :player_category, :string
  end
end
