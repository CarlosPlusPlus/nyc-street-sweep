require 'sqlite3'
require 'pp'

class Parser

  DB = SQLite3::Database.open("../source/streetsweep.db")

  ALTSIDE = DB.execute("SELECT * FROM altside")

  def self.parse #Need to pass this an index to parse, so we don't have to parse all regulations
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
    trunc
  end

  def self.days_of_week(string) #Need to feed this a selected string from parse method
    week = ["MO", "TU", "WE", "TH", "FR", "SA", "SU"]
    reg_days_of_week = ["", "", "", "", "", "", ""]
    counter = 0
    
    week.each do |x|
      reg_days_of_week[counter] = x if string.include?(x)
      counter += 1
    end
    
    reg_days_of_week
  end
end

string = Parser.parse
# pp string
pp Parser.days_of_week(string)
