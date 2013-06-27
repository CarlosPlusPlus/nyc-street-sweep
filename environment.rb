# Load all ruby files in /lib directory.

Dir.glob('/lib').each do |folder|
  Dir.glob(folder +"/*.rb").each do |file|
    require file
  end
end