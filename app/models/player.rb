class Player < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  validates :age_category, inclusion: { in: %w(U11 U13 U15 U17 Adult),
    message: "%{value} must be one of U11, U13, U15, U17 or Adult." }
end
