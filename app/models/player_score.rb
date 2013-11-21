class PlayerScore < ActiveRecord::Base
	belongs_to :innings
  	validates :name, presence: true
end
