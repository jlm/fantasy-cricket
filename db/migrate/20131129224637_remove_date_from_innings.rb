class RemoveDateFromInnings < ActiveRecord::Migration
  def change
    remove_column :innings, :date, :string
  end
end
