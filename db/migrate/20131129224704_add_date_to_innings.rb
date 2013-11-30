class AddDateToInnings < ActiveRecord::Migration
  def change
    add_column :innings, :date, :date
  end
end
