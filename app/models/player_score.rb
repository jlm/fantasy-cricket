class PlayerScore < ActiveRecord::Base
	belongs_to :innings
	belongs_to :players
	belongs_to :teams
  	validates :name, presence: true
end
