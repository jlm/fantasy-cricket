require "open-uri"
require "rest-client"
require "date"
require "date/format"
require "json"
require 'pry'
require 'active_support/core_ext/hash/conversions'

###
### This program reads some player score records derived from an Excel Spreadsheet saved as XML,
### and does PUTS into the database using JSON.
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
  [ '--matchname', '-m', GetoptLong::REQUIRED_ARGUMENT ],
  [ '--date', '-z', GetoptLong::REQUIRED_ARGUMENT ],
  [ '--inningsname', '-n', GetoptLong::REQUIRED_ARGUMENT ],
  [ '--mom',  '-y', GetoptLong::REQUIRED_ARGUMENT ],
  [ '--post', '-p', GetoptLong::REQUIRED_ARGUMENT ],
  [ '--debug',    '-d', GetoptLong::NO_ARGUMENT ]
)

infilename = nil
outfilename = nil
matchname = nil
date = nil
inningsname = nil
mom = nil
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
    when '--matchname'
      matchname = arg.to_s
    when '--inningsname'
      inningsname = arg.to_s
    when '--mom'
      mom = arg.to_s
    when '--date'
      date = Date.strptime(arg.to_s, "%d/%m/%Y")
  end
end

puts "Debug level is " + $debug.to_s if $debug > 0

if ARGV.length != 1
  puts "Missing XMLfile argument\n"
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
      exit
    end
    print "#{resp.inspect}\n" if $debug > 0
  else
    print "#{item.to_json}\n"
  end
  JSON.parse(resp.body)
end

#
# Open and parse as XML the input file
#

inhash = Hash.from_xml(open(infilename).read)
playerscores = inhash["match"]["playerscore"]
doc = []
match = { :matchname => matchname, :date => date, :mom => mom }
match["innings"] = [{ :inningsname => inningsname, :matchname => matchname, :date => date, "bat" => []}]
playerscores.each do |ps|
  match["innings"].first["bat"] << ps
end

doc << match

binding.pry

doc.each do |match|
  # Create a match id to prevent the same match from being added twice
  match[:hashkey] = make_id(match.to_json.to_s)
  # Create an innings id to prevent the same innings from being added twice
  match["innings"].each do |innings|
    innings[:hashkey] = make_id(innings.to_json.to_s)
  end

  # Post the match
  rsp = post_item(match, post_url_base, "matches")
  match_id = rsp["id"]

  # Post all the inningses
  match["innings"].each do |innings|
    innings[:match_id] = match_id
    print "******** POST innings: #{innings.inspect}\n"
    rsp = post_item(innings, post_url_base, "matches/#{match_id}/innings")
    innings_id = rsp["id"]
    binding.pry
    if innings["bat"]
      innings["bat"].each do |playerupdate|
        playerupdate[:match_id] = match_id
        playerupdate[:innings_id] = innings_id
        post_item(playerupdate, post_url_base, "matches/#{match_id}/innings/#{innings_id}/player_scores")
      end
    end
    if innings["bowl"]
      innings["bowl"].each do |playerupdate|
        playerupdate[:match_id] = match_id
        playerupdate[:innings_id] = innings_id
        post_item(playerupdate, post_url_base, "matches/#{match_id}/innings/#{innings_id}/player_scores")
      end
    end
    if innings["field"]
      innings["field"].each do |playerupdate|
        playerupdate[:match_id] = match_id
        playerupdate[:innings_id] = innings_id
        post_item(playerupdate, post_url_base, "matches/#{match_id}/innings/#{innings_id}/player_scores")
      end
    end
  end
end

exit
require 'pry'
binding.pry
