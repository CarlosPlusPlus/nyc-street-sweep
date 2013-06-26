require_relative 'tweet'
require_relative 'text'

class Scheduler

  def self.schedule_text(asp_days, asp_times, increment, phone)
    daytime = DateTime.now


    while !asp_days.include?(daytime.strftime("%A"))
      daytime += 1
    end

    schedule_date = daytime.strftime("%B %d %Y")

    begin_time = asp_times.first
    schedule_time = (begin_time - (increment.to_f*60*60)).strftime("%k:%M")

    Text.schedule_text(phone, schedule_date, schedule_time)
  end


  def self.schedule_tweet(asp_days, asp_times, increment, handle)
    daytime = DateTime.now


    while !asp_days.include?(daytime.strftime("%A"))
      daytime += 1
    end

    schedule_date = daytime.strftime("%B %d %Y")

    begin_time = asp_times.first
    schedule_time = (begin_time - (increment.to_f*60*60)).strftime("%k:%M")

    Tweet.schedule_tweet(handle, schedule_date, schedule_time)
  end

end