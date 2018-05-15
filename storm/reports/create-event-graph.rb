#
# ruby /Users/dcvezzani/scripts/create-event-graph.rb ./freeswitch-prodstorm4-report-by-target-2017_12_18T16_44_49_0700.json

#

require 'json'
require 'time'
require 'byebug'
require 'csv'

json_filename = ARGV[0]
ds = ARGV[1]
html_filename = ARGV[2]

csv_filename = json_filename.gsub(/json$/, 'csv')
js_filename = json_filename.gsub(/json$/, 'js')

if html_filename.nil?
  html_filename = json_filename.gsub(/json$/, 'html')
end

# json_filename = "freeswitch-prodstorm4-report-by-target-2017_12_18T16_44_49_0700.json"
content = `cat #{json_filename} | jq '.uuids | to_entries | map(.key as $key | .value | to_entries | map({b_leg: .value.uuid, time_orig: .value.date})) | flatten'`; content.length

# >> hereiam

json = JSON::load(content); json.length
json_collection = {}
json.map!{|entry| 
	re = Regexp.new("^#{ds}")
	if (entry["time_orig"].match(re))
		the_time =  Time.parse(entry["time_orig"] + " UTC") 
		entry["time_orig"] = the_time.localtime.strftime("%H:%M:%S")

		hr, min, sec = entry["time_orig"].split(/:/)
		percentage_precision = 25
		minute_precision = (60 / (100 / percentage_precision)) * 0.01
		minute_percentage = ((min.to_i / minute_precision).round * (percentage_precision * 0.01)) * 0.01
		entry["time_percentage"] = (hr.to_i + minute_percentage)

		json_collection[(entry["time_percentage"])] = [] unless json_collection.has_key?(entry["time_percentage"])
		json_collection[(entry["time_percentage"])] << entry
		
		entry
	else
		nil
	end
}; json.length
json.select{|x| x.nil?}.length
json.first

# new_json = json_collection.map{|k, v| {time_percentage: v.first['time_percentage'], count: v.length} }
new_json = json_collection.map{|k, v| [v.first['time_percentage'], v.length]}

new_json.sort!{|a,b| a[0] <=> b[0]}

new_json.unshift(['start', 'count'])

CSV.open(csv_filename, "wb") do |csv|
	new_json.each do |entry|
		csv << entry
	end
end

rows = new_json.map(&:to_s)
File.open(js_filename, "wb") do |f|
	f.write "#{rows.join(",\n")}"
end

`awk '/__event_data__/{while(getline line<"#{js_filename}"){print line}} //' #{html_filename} > #{html_filename}.tmp; mv #{html_filename}.tmp #{html_filename}`
`sed -i'' -e '/__event_data__/d' #{html_filename}`
