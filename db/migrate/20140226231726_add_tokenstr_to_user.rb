class AddTokenstrToUser < ActiveRecord::Migration
  def change
    add_column :users, :tokenstr, :string
  end
end
