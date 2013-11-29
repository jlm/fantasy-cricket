class PlayerScore < ActiveRecord::Base
	belongs_to :innings
	belongs_to :players
	has_and_belongs_to_many :teams
  	validates :name, presence: true
end
