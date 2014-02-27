class AddFieldsToToken < ActiveRecord::Migration
  def change
    add_column :tokens, :email, :string
    add_column :tokens, :realname, :string
  end
end
