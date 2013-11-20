class ChangeIdcolToDecimalInInnings < ActiveRecord::Migration
  def up
    change_column :innings, :innings_id, :decimal
  end

  def down
    change_column :innings, :innings_id, :integer
  end
end
