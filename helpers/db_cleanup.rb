require 'sqlite3'
require 'pp'

DB_Read   = SQLite3::Database.open("./orig_streetsweep.db")
DB_Write  = SQLite3::Database.open("./streetsweep.db")

database = DB_Read.execute("SELECT * FROM streetsegment")

# test_db = [
#   ["M", "S-999919", "CHURCH   STREET", "DEY STREET", "FULTON STREET", "W"],
#   ["M", "S-999942", "WEST  106 STREET", "WEST END AVENUE", "BROADWAY", "S"]
#           ]

# Remove unnecessary spaces and insert into new database.
database.each do |entry|
  db_row = entry.collect {|data| data.gsub(/ +/," ")}
  DB_Write.execute("INSERT into streetsegment VALUES (?,?,?,?,?,?)", db_row)
end