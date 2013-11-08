class Team < ActiveRecord::Base
	has_and_belongs_to_many :players, after_add: :update_teamscore, after_remove: :update_teamscore
	belongs_to :user

	validates :name, presence: true, length: {maximum: 50}, uniqueness: true

	private
		def update_teamscore(p)
			$stderr.puts "+++Player #{p.name} added/removed to/from team #{self.name}"
			self.totalscore = self.players.sum(:total)
			self.save
		end
end
