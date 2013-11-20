class RenameMatchIdColumnInMatches < ActiveRecord::Migration
  def change
    rename_column :matches, :match_id, :hashkey
  end
end
