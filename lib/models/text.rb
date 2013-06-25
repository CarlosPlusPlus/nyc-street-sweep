require 'twilio-ruby'
require 'sqlite3'

class Text

  account_sid = 'AC46a6a7b7c127ecf8874cdef50638d43f'
  auth_token = 'f1547331ba893b2f77077f6ff1388eb4'

  client = Twilio::REST::Client.new(account_sid, auth_token)
  @account = client.account

  def self.send(number, message)
    @account.sms.messages.create({:from => '17863759963',
                                  :to => "1#{number}",
                                  :body => "#{message}"})
  end

  def self.schedule_text(phone, date, time)
    db = SQLite3::Database.open("text.db")
    db.execute("INSERT INTO text VALUES(?, ?, ?)",[phone, date, time])
  end

  def self.send_scheduled(date, time, message)
    db = SQLite3::Database.open("text.db")

    numbers_to_text = db.execute("SELECT phone
                          FROM text
                          WHERE date = '#{date}' AND time = '#{time}'").flatten
    numbers_to_text.each {|phone| send(phone, message)}
  end

end