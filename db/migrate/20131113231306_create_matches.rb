class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.string :matchname
      t.string :date

      t.timestamps
    end
  end
end
