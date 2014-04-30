require "open-uri"
require "rest-client"
require "date"
require "date/format"
require "json"
require 'pry'
require 'csv'

###
### This program reads the JSON and does PUTS into the database using JSON too.`
### It is not run from inside the fantasty cricket application.
###

###
### Main program
###

require 'digest/sha1'

def make_id(str)
  sum = 0;
  Digest::SHA1.hexdigest(str).unpack('Q*').map do |a|
    sum = sum + a
  end
  sum
end

#
# Process command line options
#
require "getoptlong"
# require "rdoc/usage"
opts = GetoptLong.new(
  [ '--outfile', '-o', GetoptLong::REQUIRED_ARGUMENT ],
  [ '--force', '-f', GetoptLong::NO_ARGUMENT ],
  [ '--post', '-p', GetoptLong::REQUIRED_ARGUMENT ],
  [ '--debug',    '-d', GetoptLong::NO_ARGUMENT ]
)

infilename = nil
outfilename = nil
$force = nil
post_url_base = nil
$debug = 0
opts.each do |opt, arg|
  case opt
    when '--debug'
      $debug = ($debug ? $debug + 1 : 1)
    when '--outfile'
      outfilename = arg.to_s
    when '--post'
      post_url_base = arg.to_s
    when '--force'
      $force = true
  end
end

puts "Debug level is " + $debug.to_s if $debug > 0

if ARGV.length != 1
  puts "Missing input filename\n"
  exit 1
end
infilename = ARGV.shift

def post_item(item, postbase, posttrailer)
  post_url = postbase + "/" + posttrailer
  if postbase
    resp = RestClient.post(post_url, item.to_json, :content_type => :json, :accept => :json) { |response, request, result| result }
    #binding.pry
    unless [ "200", "201" ].include? resp.code
      print "BAD RESPONSE: #{resp.inspect}\n#{posttrailer}: #{resp.body.to_str}\n"
      #binding.pry
      exit unless $force
    end
    print "#{resp.inspect} #{resp.body.to_str}\n" if $debug > 0
  else
    print "#{item.to_json}\n"
  end
  JSON.parse(resp.body)
end

#
# Open and parse as CSV the input HTML file
#

CSV.foreach(infilename) do |playerrecord|
  next if playerrecord[0] == "Name"
  player = {}
  player[:name]            = playerrecord[0]
  player[:age_category]    = playerrecord[1]
  player[:player_category] = playerrecord[2]
  player[:price]           = playerrecord[4].to_f
  player[:team]            = playerrecord[5].to_i
  player[:bat_innings]     = playerrecord[6].to_i
  player[:bat_runs_scored] = playerrecord[7].to_i
  player[:bat_fifties]     = playerrecord[8].to_i
  player[:bat_hundreds]    = playerrecord[9].to_i
  player[:bat_ducks]       = playerrecord[10].to_i
  player[:bat_not_outs]    = playerrecord[11].to_i
  player[:bowl_overs]      = playerrecord[12].to_i
  player[:bowl_maidens]    = playerrecord[13].to_i
  player[:bowl_runs]       = playerrecord[14].to_i
  player[:bowl_wickets]    = playerrecord[15].to_i
  player[:bowl_4_wickets]  = playerrecord[16].to_i
  player[:bowl_6_wickets]  = playerrecord[17].to_i
  player[:field_catches]   = playerrecord[18].to_i
  player[:field_runouts]   = playerrecord[19].to_i
  player[:field_stumpings] = playerrecord[20].to_i
  player[:field_drops]     = playerrecord[21].to_i
  player[:field_mom]       = playerrecord[22].to_i

  # Post the player
  rsp = post_item(player, post_url_base, "players")
  player_id = rsp["player_id"]
  print "Player created with id #{player_id}\n"
  #exit
end

exit
require 'pry'
binding.pry
