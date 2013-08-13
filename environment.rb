# require_relative 'lib/models/mapgenerator.rb'
# require_relative 'lib/models/parser.rb'
# require_relative 'lib/models/scheduler.rb'
# require_relative 'lib/models/text.rb'
# require_relative 'lib/models/tweet.rb'

# Include all models (.rb files) in /lib/*/

Dir.glob('./lib/*').each do |folder|
  Dir.glob(folder +"/*.rb").each do |file|
    require file
  end
end

require './config/pwd' if File.exists?('./config/pwd.rb')

# Load all ruby files in /lib directory.

# Dir.glob('/lib').each do |folder|
#   Dir.glob(folder +"/*.rb").each do |file|
#     require file
#   end
# end