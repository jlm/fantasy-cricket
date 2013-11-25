class PlayerScore < ActiveRecord::Base
	belongs_to :innings
	belongs_to :players
  	validates :name, presence: true
end
