
every :day, at: "3:00am", roles: [:app] do
  command "find #{ENV['INSCREVA_SHARED']}/public/downloads/Inscreva_*.zip -mtime +0 -exec rm {} \\;"
end
