class Innings < ActiveRecord::Base
	has_many :player_scores, dependent: :destroy
	belongs_to :match
  	validates :matchname, presence: true
  	validates :inningsname, presence: true
  	validates :date, presence: true
  	validates :hashkey, presence: true, uniqueness: true
end
