class Player < ActiveRecord::Base
  has_and_belongs_to_many :teams

  before_save :update_player_scores
  after_save :update_parent_team_scores
  validates :name, presence: true, uniqueness: true
  validates :team, presence: true, inclusion: { :in => 1..TEAMS_IN_LEAGUE,
  	message: "%{value} must be in range 1 to #{TEAMS_IN_LEAGUE}." }
  validates :age_category, inclusion: { in: %w(U11 U13 U15 U17 Adult),
    message: "%{value} must be one of U11, U13, U15, U17 or Adult." }

  private
  	def update_player_scores
  	  self.bat_score = bat_runs_scored + bat_fifties*25 + bat_hundreds*50 + bat_not_outs*5 - bat_ducks*8
  	  self.bowl_score = bowl_wickets*15 + bowl_4_wickets*25 + bowl_6_wickets*50 + bowl_maidens*4
  	  self.field_score = (field_catches + field_runouts + field_stumpings)*15 - field_drops*5
  	  self.bonus = field_mom*20
  	  self.total = INITIAL_PLAYER_PRICES[self.team] + self.bat_score + self.bowl_score + self.field_score + self.bonus
  	  self.bat_avg_invalid = (bat_innings - bat_not_outs == 0)
	  self.bat_avg = (bat_runs_scored + 0.0) / (bat_innings - bat_not_outs) unless self.bat_avg_invalid
  	  self.bowl_avg_invalid = (bowl_wickets == 0)
      self.bowl_avg = (bowl_runs + 0.0) / bowl_wickets unless self.bowl_avg_invalid
  	end

  	def update_parent_team_scores
  	  self.teams.each do |team|
		$stderr.puts "+++Team #{team.name} totalscore updated because player #{self.name} updated"
  	  	team.totalscore = team.players.sum(:total)
  	  	team.save
  	  end
  	end
end
