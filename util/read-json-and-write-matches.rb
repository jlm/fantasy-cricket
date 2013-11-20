require "open-uri"
require "rest-client"
require "date"
require "date/format"
require "json"
require 'pry'

###
### This program reads the JSON and does PUTS into the database using JSON too.`
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
  [ '--ppp', '-z', GetoptLong::NO_ARGUMENT ],
  [ '--post', '-p', GetoptLong::REQUIRED_ARGUMENT ],
  [ '--debug',    '-d', GetoptLong::NO_ARGUMENT ]
)

infilename = nil
outfilename = nil
per_player_posts = nil
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
    when '--ppp'
      per_player_posts = true
  end
end

puts "Debug level is " + $debug.to_s if $debug > 0

if ARGV.length != 1
  puts "Missing htmlfile argument\n"
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
# Open and parse as XML the input HTML file
#

indoc = JSON.parse(open(infilename).read)

indoc.each do |match|
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
    innings["bat"].each do |playerupdate|
      playerupdate[:match_id] = match_id
      playerupdate[:innings_id] = innings_id
      post_item(playerupdate, post_url_base, "matches/#{match_id}/player_scores")
    end
    innings["bowl"].each do |playerupdate|
      playerupdate[:match_id] = match_id
      playerupdate[:innings_id] = innings_id
      post_item(playerupdate, post_url_base, "matches/#{match_id}/player_scores")
    end
    innings["field"].each do |playerupdate|
      playerupdate[:match_id] = match_id
      playerupdate[:innings_id] = innings_id
      post_item(playerupdate, post_url_base, "matches/#{match_id}/player_scores")
    end
  end
end

exit
require 'pry'
binding.pry
