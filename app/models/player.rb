class Player < ActiveRecord::Base
  has_and_belongs_to_many :teams
  has_many :player_scores
  belongs_to :innings

  before_save :update_player_scores
  after_save :update_parent_team_scores
  validates :name, presence: true, uniqueness: true
  validates :team, presence: true, inclusion: { :in => 1..TEAMS_IN_LEAGUE,
  	message: "%{value} must be in range 1 to #{TEAMS_IN_LEAGUE}." }
  validates :age_category, inclusion: { in: AGE_CATEGORIES,
    message: "%{value} must be one of Junior or Adult." }
  validates :player_category, presence: true, inclusion: { in: PLAYER_CATEGORIES,
    message: "%{value} must be batsman, bowler or all-rounder." }

  # This code overloads the Plus and Minus operators so that I can add a PlayerScore to a Player.
  # Normally, this kind of operation involves dup, but dup creates a new ActiveRecord,
  # so this code uses clone instead.
  def +(ps)
    raise ArgumentError unless ps.is_a? PlayerScore
    result = clone
    apply_ps_to_p(result, ps, false)
    return result
  end

  def -(ps)
    raise ArgumentError unless ps.is_a? PlayerScore
    result = clone
    apply_ps_to_p(result, ps, true)
    return result
  end

  private
  	def update_player_scores
      #binding.pry
      old_total = self.total.to_i
  	  self.bat_score = bat_runs_scored.to_i + bat_fifties.to_i*25 + bat_hundreds.to_i*50 + bat_not_outs.to_i*5 - bat_ducks.to_i*10
      old_bowl_score = self.bowl_score.to_i
  	  self.bowl_score = bowl_wickets.to_i*15 + bowl_4_wickets.to_i*25 + bowl_6_wickets.to_i*50 + bowl_maidens.to_i*2
      self.ts_keeper_decrement = old_bowl_score - self.bowl_score
  	  self.field_score = (field_catches.to_i + field_runouts.to_i + field_stumpings.to_i)*15 - field_drops.to_i*10
  	  self.bonus = field_mom.to_i*20
  	  #self.total = INITIAL_PLAYER_PRICES[self.team.to_i] + self.bat_score + self.bowl_score + self.field_score + self.bonus
      self.total = self.bat_score + self.bowl_score + self.field_score + self.bonus
      self.ts_increment = self.total.to_i - old_total
      self.price = (self.ls_price + self.total * PRICE_PER_POINT).round
  	  self.bat_avg_invalid = (bat_innings.to_i - bat_not_outs.to_i == 0)
  	  self.bat_avg = (bat_runs_scored.to_i + 0.0) / (bat_innings.to_i - bat_not_outs.to_i) unless self.bat_avg_invalid
  	  self.bowl_avg_invalid = (bowl_wickets.to_i == 0)
      self.bowl_avg = (bowl_runs.to_i + 0.0) / bowl_wickets.to_i unless self.bowl_avg_invalid
      #binding.pry
  	end

  	def update_parent_team_scores
      self.teams.each do |team|
        if team.validated
      		$stderr.puts "+++Team #{team.name} totalscore updated because player #{self.name} updated"
          increment = self.ts_increment
          increment -= self.ts_keeper_decrement if team.keeper_id == self.id
          #binding.pry
    	  	team.totalscore = team.totalscore + increment * (team.captain_id == self.id ? 2 : 1)
    	  	team.save
        else
          $stderr.puts "+++Team #{team.name} totalscore NOT updated because team not validated"
        end
  	  end
  	end

    # Apply a player_score to a player
    def apply_ps_to_p(p, ps, neg = false)
      pm = neg ? -1 : 1
      runs = ps.bat_runs_scored.to_i
      centuries = runs / 100
      fifties = (runs - centuries * 100) / 50
      p.bat_hundreds = p.bat_hundreds.to_i + pm*centuries
      p.bat_fifties = p.bat_fifties.to_i + pm*fifties
      p.bat_ducks = p.bat_ducks.to_i + pm*1 if !ps.bat_runs_scored.nil? and ps.bat_runs_scored.to_i == 0
      p.bat_runs_scored = p.bat_runs_scored.to_i + pm*ps.bat_runs_scored.to_i
      p.bat_not_outs = p.bat_not_outs.to_i + pm*ps.bat_not_outs.to_i
      p.bat_fours = p.bat_fours.to_i + pm*ps.bat_fours.to_i
      p.bat_sixes = p.bat_sixes.to_i + pm*ps.bat_sixes.to_i
      p.bat_innings = p.bat_innings.to_i + pm*1 if 
        ps.bat_runs_scored.to_i + ps.bat_balls.to_i + ps.bat_not_outs.to_i > 0 or !ps.bat_how.nil?

      wickets = ps.bowl_wickets.to_i
      six_wickets = wickets / 6
      four_wickets = (wickets - six_wickets * 6) / 4
      p.bowl_overs = p.bowl_overs.to_i + pm*ps.bowl_overs.to_i
      p.bowl_maidens = p.bowl_maidens.to_i + pm*ps.bowl_maidens.to_i
      p.bowl_runs = p.bowl_runs.to_i + pm*ps.bowl_runs.to_i
      p.bowl_wickets = p.bowl_wickets.to_i + pm*wickets
      p.bowl_4_wickets = p.bowl_4_wickets.to_i + pm*four_wickets
      p.bowl_6_wickets = p.bowl_6_wickets.to_i + pm*six_wickets

      p.field_catches = p.field_catches.to_i + pm*ps.field_catches.to_i
      p.field_runouts = p.field_runouts.to_i + pm*ps.field_runouts.to_i
      p.field_stumpings = p.field_stumpings.to_i + pm*ps.field_stumpings.to_i
      p.field_drops = p.field_drops.to_i + pm*ps.field_drops.to_i

      p.field_mom = p.field_mom.to_i + pm*1 if ps.innings.match.mom == p.id
    end
end
