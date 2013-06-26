require 'twitter'
require 'sqlite3'

class Tweet

  Twitter.configure do |config|
    config.consumer_key = 'bL2CF9o4W5dfjdzzUcB4KQ'
    config.consumer_secret = 'qtlsmja47vi5rRRHYpA6P5l9I1kS0ArUr258u36h8'
    config.oauth_token = '1535446039-eQfB9oShGrespJKRJ8Pa0q9ohbfHKtALEsZxSJe'
    config.oauth_token_secret = 'RHPC1EB4BSupSSH9Q6qw3RyOcEuEZUQnDEv2Gn8Bw'
  end

  def self.send(handle, message)
    Twitter.update("@#{handle} #{message}")
  end

  def self.schedule_tweet(handle, date, time)
    db = SQLite3::Database.open("sweep.db")
    db.execute("INSERT INTO tweet VALUES(?, ?, ?)",[handle, date, time])
  end

  def self.send_scheduled(date, time, message)
    db = SQLite3::Database.open("sweep.db")

    handles_to_tweet = db.execute("SELECT handle
                          FROM tweet
                          WHERE date = '#{date}' AND time = '#{time}'").flatten
    handles_to_tweet.each {|handle| send(handle, message)}
  end

end