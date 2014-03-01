class AddTicketnoToTokens < ActiveRecord::Migration
  def change
    add_column :tokens, :ticketno, :integer
  end
end
