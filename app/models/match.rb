class Match < ActiveRecord::Base
	has_many :innings, dependent: :destroy
	has_many :player_scores, dependent: :destroy
  	validates :matchname, presence: true
  	validates :date, presence: true
  	validates :hashkey, presence: true, uniqueness: true
  	validates_each :mom do |record, attr, value|
  		record.errors.add(attr, 'must be an existing Player ID') if Player.where(:id => value).count == 0
  	end
end
