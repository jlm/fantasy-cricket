class AddDateToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :date, :date
  end
end
