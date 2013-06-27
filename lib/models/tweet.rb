require 'twitter'
require 'sqlite3'

class Tweet

  # Setup Twitter account information.
  Twitter.configure do |config|
    config.consumer_key       = 'bL2CF9o4W5dfjdzzUcB4KQ'
    config.consumer_secret    = 'qtlsmja47vi5rRRHYpA6P5l9I1kS0ArUr258u36h8'
    config.oauth_token        = '1535446039-eQfB9oShGrespJKRJ8Pa0q9ohbfHKtALEsZxSJe'
    config.oauth_token_secret = 'RHPC1EB4BSupSSH9Q6qw3RyOcEuEZUQnDEv2Gn8Bw'
  end

  # Send tweet message to provided number with a given message.
  def self.send(handle, message)
    handle = handle.strip
    handle = handle.gsub('@', '')

    Twitter.update(".@#{handle} #{message}")
  end

  # Schedule tweet for later processing.
  def self.schedule_tweet(handle, date, time, message)
    db = SQLite3::Database.open("sweep.db")
    db.execute("INSERT INTO tweet VALUES(?, ?, ?, ?)",[handle, date, time, message])
  end

  # Process tweet from database when time is right.
  def self.send_scheduled(date, time)
    db = SQLite3::Database.open("sweep.db")

    handles_to_tweet = db.execute("SELECT handle, message
                          FROM tweet
                          WHERE date = '#{date}' AND time = '#{time}'")
    handles_to_tweet.each {|handle_msg| send(handle_msg.first, handle_msg.last)}
  end

end