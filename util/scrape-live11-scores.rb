require 'nokogiri'
require "open-uri"
require "date"
require "date/format"
require "json"

###
### This program scrapes a page from the Dream11 Fantasy Cricket site to get the match statistics and outputs them in JSON.
###

###
### Main program
###

#
# Process command line options
#
require "getoptlong"
# require "rdoc/usage"
opts = GetoptLong.new(
  [ '--outfile', '-o', GetoptLong::REQUIRED_ARGUMENT ],
  [ '--debug',    '-d', GetoptLong::NO_ARGUMENT ]
)

infilename = nil
outfilename = nil
$debug = 0
opts.each do |opt, arg|
  case opt
    when '--debug'
      $debug = ($debug ? $debug + 1 : 1)
    when '--outfile'
      outfilename = arg.to_s
  end
end

puts "Debug level is " + $debug.to_s if $debug > 0

if ARGV.length != 1
  puts "Missing htmlfile argument\n"
  #exit 1
  infilename = "https://fantasycricket.dream11.com/LiveScores/FullScorecard/Results/11587"
else
  infilename = ARGV.shift
end

def name_munge(name)
  name.gsub(/(\w)\w*\s+(.*)/,'\1 \2')
end

#require 'pry'
#binding.pry

#
# Open and parse as XML the input HTML file
#

indoc = Nokogiri::HTML(open(infilename))

matchdate = indoc.css("div.matchDetailTop div.right")[0].text.strip.gsub(/\s+/,' ')
matchname = indoc.css("div.matchDetailTop span")[0].text.strip.gsub(/\s+/,' ')

fst = indoc.css("div#fullScoreTab").first


inningsnames = []

fst.xpath("div").css(".tableHead p").each do |p|
  inningsnames << p.text
end

print inningsnames.inspect if $debug > 0


tabledata = fst.xpath("div").css(".liveScoreData").map do |innings|
  innings.css("div.scoreTable").map do |tbl|
    tbl.xpath("div").map do |row|
      row.xpath("div").map do |cell|
        cell.text
      end
    end
  end
end

innings = []
inningsnumber = 0

tabledata.each do |inn|
  next if inn.empty?
  bowl=[]
  bat=[]
  field=[]
  inn.each do |hin|
    print "********************Half innings: #{hin[0][0]}\n" if $debug > 0
    if hin[0][0] =~ /Bat/
      bat = []
      hin[1..-1].each do |row|
        next if row[0] =~ /^Extra/ or row[0] =~ /^Total/
        bat << { :name => name_munge(row[0].gsub(/[^A-Za-z. ].*/, "").gsub(/\s*$/, "")), :bat_how => row[1], :bat_runs_scored => row[2], :bat_balls => row[3], :bat_fours => row[4], :bat_sixes => row[5], :bat_sr => row[6] }
      end
      #print "#{JSON.generate(bat)}\n"
      field = []
      catches = {}
      stumps = {}
      notouts = {}
      bat.each do |b|
        # Parse the :how string to derive some fielding stats
        m = b[:bat_how].split(/lbw|batt|[^A-Za-z](c|b|st) |^(c|b|st) /)
        i = 0
        print "************** m is #{m.inspect}\n" if $debug > 0
        while i < m.length do
          case m[i]
          when ""
          when "c"
            if m[i+1] then
              catches[m[i+1]] = catches[m[i+1]] ? catches[m[i+1]] + 1 : 1
              i += 1
            end
          when "st"
            if m[i+1] then
              stumps[m[i+1]] = stumps[m[i+1]] ? stumps[m[i+1]] + 1 : 1
              i += 1
            end
          when "b"
            if m[i+1] then
              i += 1
            end
          # The string "batting" is detected by splitting on "batt" above, and detecting "ing" here.  That's mucky, isn't it?
          when "ing"
            b[:bat_not_outs] = b[:bat_not_outs].nil? ? 1 : b[:bat_not_outs] + 1
            print "********************Not Out: #{b[:bat_not_outs]} for #{b[:batsman]}\n" if $debug > 0
          end
          i += 1
        end
      end
      catches.each do |f, c|
        field << { :name => name_munge(f), :field_catches => c }
      end
      stumps.each do |f, s|
        field << { :name => name_munge(f), :field_stumpings => s }
      end
      #print "*************************** Bat: #{bat.length}\n"
      #print "#{JSON.generate(field)}\n"
    else
      bowl = []
      hin[1..-1].each do |row|
        bowl << { :name => name_munge(row[0]), :bowl_overs => row[1], :bowl_maidens => row[2], :bowl_runs => row[3], :bowl_wickets => row[4], :bowl_wides => row[5], :bowl_noballs => row[6], :bowl_er => row[7] }
      end
      #print "*************************** Bowl: #{bowl.length}\n"
      #print "#{JSON.generate(bowl)}\n"
    end
    print "************************* Bat: #{bat.length}\n"  if $debug > 0
    print "************************* Bowl: #{bowl.length}\n"  if $debug > 0
  end
  innings << { matchname: matchname, date: matchdate, inningsname: inningsnames[inningsnumber], bat: bat, bowl: bowl, field: field }
  inningsnumber += 1
end

matches = []
matches << { matchname: matchname, date: matchdate, innings: innings }

print matches.to_json
print "\n"
exit

require 'pry'
binding.pry
