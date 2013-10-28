class AddPlayerScoresToPlayer < ActiveRecord::Migration
  def change
    add_column :players, :bat_score, :integer
    add_column :players, :bowl_score, :integer
    add_column :players, :field_score, :integer
    add_column :players, :bonus, :integer
    add_column :players, :bat_avg, :float
    add_column :players, :bowl_avg, :float
  end
end
