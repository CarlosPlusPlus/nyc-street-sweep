require 'sqlite3'
require 'pp'

class Parser

DB = SQLite3::Database.open("../source/streetsweep.db")

ALTSIDE = DB.execute("SELECT * FROM altside")

def self.parse
  trunc = []
  string = ""
  ALTSIDE.each do |x|
    string = x[2].gsub("F RI", "FRI")
    string = string.gsub("8AM 11AM", "8AM-11AM")
    string = string.gsub(/ TO( |-)/, "-")
    string = string.gsub(/ & | &|& |&/, " ")
    string = string.gsub("MON THRU FRI", "MON TUES WED THURS FRI")
    string = string.gsub(/EXCEPT (SUNDAY|SUN)/, "MON TUES WED THURS FRI SAT")
    string = string.gsub("MIDNIGHT", "12AM")
    string = string.gsub("NOON", "12PM")
    string = string.split("REGULATION").last.strip
    string = string.split(/BROOM SYMBOL\)|BROOM \(SYMBOL\)|BROOM SYMBOL/).last.strip
    string = string.split("PARKING").last.strip
    string = string.split("W/").first.strip
    string = string.split("(SUPER").first.strip
    string = string.split("SUPER").first.strip
    string = string.split("(SINGLE").first.strip
    string = string.split("SEE").first.strip
    string = string.split(" (").first.strip
    trunc << string
  end
  trunc.uniq
end 

end

puts Parser.parse

# string = "MON TUES WED THURS FRI SAT"
# puts string.include? "MON"
