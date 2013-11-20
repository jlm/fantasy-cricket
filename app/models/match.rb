class Match < ActiveRecord::Base
	has_many :innings, dependent: :destroy
	has_many :player_scores, dependent: :destroy
  	validates :matchname, presence: true
  	validates :date, presence: true
  	validates :hashkey, presence: true, uniqueness: true
end
