class AddMatchIdToInnings < ActiveRecord::Migration
  def change
    add_column :innings, :match_id, :decimal
  end
end
