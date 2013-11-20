class ChangeMatchIdColumnTypeForInnings < ActiveRecord::Migration
  def up
    change_column :innings, :match_id, :integer
  end

  def down
    change_column :innings, :match_id, :decimal
  end
end
