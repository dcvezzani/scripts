#
# ruby /Users/dcvezzani/scripts/create-delay-graph.rb ./fs-node-delay-report-prodstorm0-20171214.json
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

content = `cat #{json_filename} | jq '. | flatten | map({b_leg: .b_leg, time_orig: .data.fs.time_orig, time_diff: .time_diff})'`; content.length

json = JSON::load(content); json.length
json.map!{|entry| 
	re = Regexp.new("^#{ds}")
	if (entry["time_orig"].match(re))
		the_time =  Time.parse(entry["time_orig"] + " UTC") 
		entry["time_orig"] = the_time.localtime.strftime("%H:%M:%S")
		entry
	else
		nil
	end
}; json.length
json.select{|x| x.nil?}.length
#TODO: compact entries with jq instead
json = json.select{|x| !x.nil?}
json.first

new_json = json.inject([]){|all, entry| 
	all.concat([{start: entry["time_orig"], delay: entry["time_diff"]}]) 
}
new_json.first

new_json = json.inject([]){|all, entry| 
	hr, min, sec = entry["time_orig"].split(/:/)
	# percentage_precision = 25
	# minute_precision = (60 / (100 / percentage_precision)) * 0.01
	# minute_percentage = ((min.to_i / minute_precision).round * (percentage_precision * 0.01)) * 0.01
	# the_time = (hr.to_i + minute_percentage)

	minute_percentage = (min.to_i / 60.00)
	the_time = (hr.to_i + minute_percentage)
	all << [the_time, entry["time_diff"]]; all 
}

new_json.sort!{|a,b| a[0] <=> b[0]}

new_json.unshift(['start', 'delay'])

CSV.open(csv_filename, "wb") do |csv|
	new_json.each do |entry|
		csv << entry
	end
end

rows = new_json.map(&:to_s)
File.open(js_filename, "wb") do |f|
	f.write "#{rows.join(",\n")}"
end

`awk '/__delay_data__/{while(getline line<"#{js_filename}"){print line}} //' #{html_filename} > #{html_filename}.tmp; mv #{html_filename}.tmp #{html_filename}`
`sed -i'' -e '/__delay_data__/d; s/__delays_count__/#{new_json.length}/g' #{html_filename}`
