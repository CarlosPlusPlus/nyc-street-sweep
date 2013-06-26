require 'twilio-ruby'
require 'sqlite3'

class Text

  account_sid = 'AC46a6a7b7c127ecf8874cdef50638d43f'
  auth_token = 'f1547331ba893b2f77077f6ff1388eb4'

  client = Twilio::REST::Client.new(account_sid, auth_token)
  @account = client.account

  def self.send(number, message)
    number.strip!
    number.gsub!('-', '')
    number.gsub!('(', '')
    number.gsub!(')', '')

    @account.sms.messages.create({:from => '17863759963',
                                  :to => "1#{number}",
                                  :body => "#{message}"})
  end

  def self.schedule_text(phone, date, time, message)
    db = SQLite3::Database.open("sweep.db")
    db.execute("INSERT INTO text VALUES(?, ?, ?, ?)",[phone, date, time, message])
  end

  def self.send_scheduled(date, time)
    db = SQLite3::Database.open("sweep.db")

    numbers_to_text = db.execute("SELECT phone, message
                          FROM text
                          WHERE date = '#{date}' AND time = '#{time}'")

    numbers_to_text.each {|phone_msg| send(phone_msg.first, phone_msg.last)}
  end

end