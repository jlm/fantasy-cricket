class AddColsToInnings < ActiveRecord::Migration
  def change
    add_column :innings, :numbats, :integer
    add_column :innings, :numbowls, :integer
    add_column :innings, :numfields, :integer
  end
end
