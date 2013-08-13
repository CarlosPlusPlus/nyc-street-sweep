class Scheduler

  # Schedule text based on alternate side parking rules.
  def self.schedule_text(asp_days, asp_times, increment, phone, message)
    sched_date_time = get_sched_date_time(asp_days, asp_times, increment)
    schedule_date = sched_date_time.first
    schedule_time = sched_date_time.last

    Text.schedule_text(phone, schedule_date, schedule_time, message)
  end

  # Schedule tweet based on alternate side parking rules.
  def self.schedule_tweet(asp_days, asp_times, increment, handle, message)
    sched_date_time = get_sched_date_time(asp_days, asp_times, increment)
    schedule_date = sched_date_time.first
    schedule_time = sched_date_time.last

    Tweet.schedule_tweet(handle, schedule_date, schedule_time, message)
  end

  def self.get_sched_date_time(asp_days, asp_times, increment)
    daytime = DateTime.now

    while !asp_days.include?(daytime.strftime("%A"))
      daytime += 1
    end

    schedule_date = daytime.strftime("%B %d %Y")

    begin_time = asp_times.first
    schedule_time = (begin_time - (increment.to_f*60*60)).strftime("%k:%M")
    schedule_time.strip!

    [schedule_date,schedule_time]
  end

end