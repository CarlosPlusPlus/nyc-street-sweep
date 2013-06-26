require 'sqlite3'
require 'timeliness'
require 'pp'

class Parser

  DB = SQLite3::Database.open("./source/streetsweep.db")
  # ALTSIDE = DB.execute("SELECT * FROM altside") #IS THIS NECESSARY?

  def self.parse(ord_num)
    trunc = []
    
    regulation = DB.execute("SELECT SignDescription FROM altside WHERE StatusOrderNumber = ?", ord_num).flatten 

    regulation.each do |x|
      string = x.gsub("F RI", "FRI")
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

    trunc.uniq.first

    # if trunc.uniq.size == 1
    #   trunc.uniq.first
    # elsif trunc.uniq.size > 1
    #   puts "ERROR: THERE ARE MORE THAN ONE NON-UNIQUE REGUALATIONS FOR THIS ORD NUM"
    # else
    #   puts "ERROR: PLEASE ENTER A CORRECT ADDRESS/ORD NUMBER"
    # end
  end

  def self.days_of_week(reg_string) #Need to feed this a selected string from parse method
    week = ["MO", "TU", "WE", "TH", "FR", "SA", "SU"]
    reg_days_of_week = ["", "", "", "", "", "", ""]
    counter = 0

    week.each do |x|
      reg_days_of_week[counter] = x if reg_string.include?(x)
      counter += 1
    end
    
    reg_days_of_week
  end

  def self.start_end_times(reg_string) #PROBLEM IF NO AM/PM EXISTS IN START TIME AND END TIME HAS DIFFERENT AM/PM
    time_array = reg_string.split(" ").first.split("-")
    
    time_array[0] += time_array[1][-2,2] if !time_array[0].include?("AM" || "PM")

    start_time = Timeliness.parse(time_array[0], :time) 
    end_time   = Timeliness.parse(time_array[1], :time)

    [start_time, end_time]
  end

  def self.run_parsing(main_street, from_street, to_street, side_of_street)
    
    ord_num = DB.execute("SELECT StatusOrderNumber FROM streetsegment WHERE MainStreet = ? AND FromStreet = ? AND ToStreet = ? AND SideOfStreet = ?", [main_street, from_street, to_street, side_of_street]).flatten.first

    regulation = self.parse(ord_num)

    [self.start_end_times(regulation),self.days_of_week(regulation)]    
  end
end