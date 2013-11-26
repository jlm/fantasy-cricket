class Team < ActiveRecord::Base
	has_and_belongs_to_many :players, after_add: :update_teamscore, after_remove: :update_teamscore
	belongs_to :user

	after_save :update_parent_user_total
	validates :name, presence: true, length: {maximum: 50}, uniqueness: true

	private
		def update_teamscore(p)
			$stderr.puts "+++Player #{p.name} added/removed to/from team #{self.name}"
			# Team scores are unaffected by adding or removing players.
			# Only the changes in a team's players' scores change the team score.
			#self.totalscore = self.players.sum(:total)
			#self.save
		end

	  	def update_parent_user_total
			$stderr.puts "+++User #{self.user.name} totalscore updated because team #{self.name} updated"
			# This is fine, but most of the code assumes that a user can only have one team.
  		  	self.user.totalscore = self.user.teams.sum(:totalscore)
  	  		self.user.save!
  		end
end
