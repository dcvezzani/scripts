# 
# ruby /Users/dcvezzani/scripts/time-slices-delay-report.rb './freeswitch-prodstorm3-events-2017_12_12T13_20_21_0700.json'

require 'time'
require 'json'

file_events_json = ARGV[0]

json = JSON::load(IO.read(file_events_json)); nil

json.map!{|entry| 
	the_time = Time.parse(entry['date'] + " UTC")
	entry['date'] = the_time
	entry['date-sec'] = the_time.to_i
	entry 
}; nil

by_date = json.inject({}){|h, e| 
	time_slice = (e['date-sec'].to_i / 10) * 10
	time_slice = (e['date-sec'].to_i / 600) * 600
	time_slice = (e['date-sec'].to_i / 300) * 300
  h[time_slice] = [] unless h.has_key?(time_slice)
	h[time_slice] << e
	h
}; nil

puts by_date.map{|k,v| "#{k}\t#{v.length}"}.sort.join("\n")

