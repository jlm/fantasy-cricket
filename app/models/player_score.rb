class PlayerScore < ActiveRecord::Base
	belongs_to :match
  	validates :name, presence: true
end
