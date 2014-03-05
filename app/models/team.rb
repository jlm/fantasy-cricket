class Team < ActiveRecord::Base
	has_and_belongs_to_many :players, after_add: :update_teamscore, after_remove: :update_teamscore
	has_and_belongs_to_many :player_scores
	belongs_to :user

	after_save :update_parent_user_total
	validates :name, presence: true, length: {maximum: 50}, uniqueness: true

  def meets_rules?
  	valid = true
  	#binding.pry
    if self.players.where(player_category: "bowler").count < 3
      self.errors.add(:players, "must include at least 3 bowlers")
      valid = false
    end
    if self.players.where(player_category: "batsman").count < 3
      self.errors.add(:players, "must include at least 3 batsmen")
      valid = false
    end
    if self.players.where(player_category: "all-rounder").count < 3
      self.errors.add(:players, "must include at least 3 all-rounders")
      valid = false
    end
    if self.players.count != PLAYERS_PER_TEAM
      self.errors.add(:players, "must include exactly #{PLAYERS_PER_TEAM} players")
      valid = false
    end
    if self.players.where("age_category != 'Adult'").count < 2
      self.errors.add(:players, "must include at least 2 junior players")
      valid = false
    end
    if self.captain_id.nil?
      self.errors.add(:teams, "must have a captain")
      valid = false
    end
    if self.keeper_id.nil?
      self.errors.add(:teams, "must have a keeper")
      valid = false
    end
    begin
      cap = self.players.find(self.captain_id)
    rescue ActiveRecord::RecordNotFound
      self.errors.add(:players, "must include the team captain")
      valid = false
    end
    begin
      keep = self.players.find(self.keeper_id)
    rescue ActiveRecord::RecordNotFound
      self.errors.add(:players, "must include the keeper")
      valid = false
    end
    return valid
  end


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
