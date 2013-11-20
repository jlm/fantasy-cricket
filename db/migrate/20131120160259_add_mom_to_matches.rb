class AddMomToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :mom, :integer
  end
end
