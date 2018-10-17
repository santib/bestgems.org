require "sequel"
require "date"

DB = Sequel.sqlite("db/master.sqlite3")
total = DB[:total]
daily = DB[:daily]

total.where(:date => Date::today - 2).order(:name).each { |row0|
  row1 = total.where(:name => row0[:name], :date => Date::today - 3).first
  next unless row1

  STDERR.puts "aggrigating ... #{row1[:name]}."

  row = {:name => row0[:name], :version => row0[:version], :summary => row0[:summary], :date => Date::today - 2, :downloads => row0[:downloads] - row1[:downloads]}

  tmp = daily.where(:name => row[:name], :date => row[:date])
  if tmp.count > 0
    tmp.update(:version => row[:version], :summary => row[:summary], :downloads => row[:downloads])
  else
    daily.insert(row)
  end
}
