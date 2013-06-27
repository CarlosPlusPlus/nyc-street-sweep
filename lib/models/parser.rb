require 'sqlite3'
require 'timeliness'

class Parser

  # Initialize connection to streetsweep database.
  DB = SQLite3::Database.open("./source/streetsweep.db")

  # Parse ordinance string returned from database.
  def self.parse_ordinance(ord_num)
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
  end

  # Determine which days of the week are included in regulation.
  def self.days_of_week(reg_string)
    week = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    reg_days_of_week = []

    week.each do |x|
      reg_days_of_week << x if reg_string.include?(x[0,2].upcase)
    end
    
    reg_days_of_week
  end

  # Use timeliness gem to compute regulation start / end times.
  def self.start_end_times(reg_string)
    time_array = reg_string.split(" ").first.split("-")
    
    time_array[0] += time_array[1][-2,2] if !time_array[0].include?("AM" || "PM")

    start_time = Timeliness.parse(time_array[0], :time)
    end_time   = Timeliness.parse(time_array[1], :time)

    [start_time, end_time]
  end

  # Take in address info and return regulation info (days and times).
  def self.parse_info(main_street, from_street, to_street, side_of_street)
    
    ord_num    = DB.execute("SELECT StatusOrderNumber FROM streetsegment WHERE MainStreet = ? AND FromStreet = ? AND ToStreet = ? AND SideOfStreet = ?", [main_street, from_street, to_street, side_of_street]).flatten.first
    regulation = self.parse_ordinance(ord_num)

    [self.start_end_times(regulation),self.days_of_week(regulation)]    
  end
  
end