namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    ###
    ### Users
    ###
    User.create!(name: "The Admin Guy",
     email: "cricketadmin@cuthberts.org.uk",
     password: "foobar",
     password_confirmation: "foobar",
     admin: true,
     totalscore: 0)
    User.create!(name: "Lemon Grass",
     email: "lemongrass@lemongrass.org.uk",
     password: "foobar",
     password_confirmation: "foobar",
     admin: false,
     totalscore: 0)
    User.create!(name: "Tom Messenger",
     email: "tom@cuthberts.org.uk",
     password: "ThomasM1",
     password_confirmation: "ThomasM1",
     admin: true,
     totalscore: 0)
    99.times do |n|
      name  = Faker::Name.name
      email = "example-#{n+1}@helperbycricket.org.uk"
      password  = "password"
      User.create!(name: name,
       email: email,
       password: password,
       password_confirmation: password,
       admin: false,
     totalscore: 0)
    end
    ###
    ### Players
    ###
    Player.create!(name: "Example Player",
     team: 1 + rand(3),
     age_category: ["Adult", "U11", "U13", "U15", "U17"][rand(5)],
     player_category: PLAYER_CATEGORIES[rand(PLAYER_CATEGORIES.length)],
     bat_innings: rand(30),
     bat_runs_scored: rand(400),
     bat_fifties: rand(3),
     bat_hundreds: rand(2),
     bat_ducks: rand(30),
     bat_not_outs: rand(30),
     bowl_overs: rand(50),
     bowl_runs: rand(400),
     bowl_wickets: rand(35),
     bowl_4_wickets: rand(6),
     bowl_6_wickets: rand(2),
     bowl_maidens: rand(5),
     field_catches: rand(30),
     field_runouts: rand(12),
     field_stumpings: rand(12),
     field_drops: rand(30),
     field_mom: rand(4))
    99.times do |n|
      name  = Faker::Name.name
      email = "explayer-#{n+1}@helperbycricket.org.uk"
      Player.create!(name: name,
     team: 1 + rand(4),
     age_category: ["Adult", "U11", "U13", "U15", "U17"][rand(5)],
     player_category: PLAYER_CATEGORIES[rand(PLAYER_CATEGORIES.length)],
     bat_innings: rand(30),
     bat_runs_scored: rand(400),
     bat_fifties: rand(3),
     bat_hundreds: rand(2),
     bat_ducks: rand(30),
     bat_not_outs: rand(30),
     bowl_overs: rand(50),
     bowl_runs: rand(400),
     bowl_wickets: rand(35),
     bowl_4_wickets: rand(6),
     bowl_6_wickets: rand(2),
     bowl_maidens: rand(5),
     field_catches: rand(30),
     field_runouts: rand(12),
     field_stumpings: rand(12),
     field_drops: rand(30),
     field_mom: rand(4))
    end
  end
end
