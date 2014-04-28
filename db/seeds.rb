# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
User.create!(name: "The Admin Guy",
 email: "cricketadmin@cuthberts.org.uk",
 password: ENV["INITIAL_PASSWORD"],
 password_confirmation: ENV["INITIAL_PASSWORD"],
 admin: true,
 totalscore: 0,
 teamcash: INITIAL_TEAMCASH,
 drop_available: true)
User.create!(name: "Tom Messenger",
 email: "tom@cuthberts.org.uk",
 password: ENV["INITIAL_PASSWORD"],
 password_confirmation: ENV["INITIAL_PASSWORD"],
 admin: true,
 totalscore: 0,
 teamcash: INITIAL_TEAMCASH,
 drop_available: true)
User.create!(name: "A Punter",
 email: "punter@cuthberts.org.uk",
 password: ENV["INITIAL_PASSWORD"],
 password_confirmation: ENV["INITIAL_PASSWORD"],
 admin: false,
 totalscore: 0,
 teamcash: INITIAL_TEAMCASH,
 drop_available: true)
Setting.create!(var: "enable_changes", value: true)
Setting.create!(var: "enable_uploads", value: false)
   