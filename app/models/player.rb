class Player < ActiveRecord::Base
  has_and_belongs_to_many :teams
  has_many :player_scores
  belongs_to :innings

  before_save :update_player_scores
  after_save :update_parent_team_scores
  validates :name, presence: true, uniqueness: true
  validates :team, presence: true, inclusion: { :in => 1..TEAMS_IN_LEAGUE,
  	message: "%{value} must be in range 1 to #{TEAMS_IN_LEAGUE}." }
  validates :age_category, inclusion: { in: %w(U11 U13 U15 U17 Adult),
    message: "%{value} must be one of U11, U13, U15, U17 or Adult." }

  private
  	def update_player_scores
      old_total = self.total
  	  self.bat_score = bat_runs_scored.to_i + bat_fifties.to_i*25 + bat_hundreds.to_i*50 + bat_not_outs.to_i*5 - bat_ducks.to_i*10
  	  self.bowl_score = bowl_wickets.to_i*15 + bowl_4_wickets.to_i*25 + bowl_6_wickets.to_i*50 + bowl_maidens.to_i*4
  	  self.field_score = (field_catches.to_i + field_runouts.to_i + field_stumpings.to_i)*15 - field_drops.to_i*10
  	  self.bonus = field_mom.to_i*20
  	  self.total = INITIAL_PLAYER_PRICES[self.team.to_i] + self.bat_score + self.bowl_score + self.field_score + self.bonus
      self.ts_increment = self.total - old_total
  	  self.bat_avg_invalid = (bat_innings.to_i - bat_not_outs.to_i == 0)
  	  self.bat_avg = (bat_runs_scored.to_i + 0.0) / (bat_innings.to_i - bat_not_outs.to_i) unless self.bat_avg_invalid
  	  self.bowl_avg_invalid = (bowl_wickets.to_i == 0)
      self.bowl_avg = (bowl_runs.to_i + 0.0) / bowl_wickets.to_i unless self.bowl_avg_invalid
  	end

  	def update_parent_team_scores
        self.teams.each do |team|
    		$stderr.puts "+++Team #{team.name} totalscore updated because player #{self.name} updated"
  	  	team.totalscore = team.totalscore + self.ts_increment
  	  	team.save
  	  end
  	end
end
