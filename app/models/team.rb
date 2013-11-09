class Team < ActiveRecord::Base
	has_and_belongs_to_many :players, after_add: :update_teamscore, after_remove: :update_teamscore
	belongs_to :user

	after_save :update_parent_user_total
	validates :name, presence: true, length: {maximum: 50}, uniqueness: true

	private
		def update_teamscore(p)
			$stderr.puts "+++Player #{p.name} added/removed to/from team #{self.name}"
			self.totalscore = self.players.sum(:total)
			self.save
		end

	  	def update_parent_user_total
			$stderr.puts "+++User #{self.user.name} totalscore updated because team #{self.name} updated"
  		  	self.user.totalscore = self.user.teams.sum(:totalscore)
  	  		self.user.save!
  		end
end
