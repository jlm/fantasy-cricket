class RenameInningsIdColumnInInnings < ActiveRecord::Migration
  def change
    rename_column :innings, :innings_id, :hashkey
  end
end
