class Team < ActiveRecord::Base
	has_and_belongs_to_many :players
	belongs_to :user

	validates :name, presence: true, length: {maximum: 50}, uniqueness: true

end
