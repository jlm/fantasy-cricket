# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.create!(name: "The Admin Guy",
 email: "cricketadmin@cuthberts.org.uk",
 password: "foobar",
 password_confirmation: "foobar",
 admin: true,
 totalscore: 0,
 teamcash: 6000,
 drop_available: true)
User.create!(name: "Lemon Grass",
 email: "lemongrass@lemongrass.org.uk",
 password: "foobar",
 password_confirmation: "foobar",
 admin: false,
 totalscore: 0,
 teamcash: 6000,
 drop_available: true)
User.create!(name: "Tom Messenger",
 email: "tom@cuthberts.org.uk",
 password: "ThomasM1",
 password_confirmation: "ThomasM1",
 admin: true,
 totalscore: 0,
 teamcash: 6000,
 drop_available: true)
Setting.create!(var: "enable_changes", value: true)
Setting.create!(var: "enable_uploads", value: false)
   