#!/Users/dvezzani/.rvm/rubies/ruby-2.0.0-p353/bin/ruby

require 'time'

content = ARGF.readlines
home='/Users/davidvezzani/scripts'

def parse_time(target_time_str)
  target_time = Time.parse(target_time_str)
  hr_min = target_time.strftime("%H:%M")
  time_zone_indicator = ["PST", "America/Los_Angeles"]
  time_zone_offset = '-08:00'

  due_gmt = DateTime.strptime(target_time.getlocal(time_zone_offset).strftime("%Y%m%dT") + "#{hr_min}:00 #{time_zone_indicator[0]}", "%Y%m%dT%H:%M:%S %Z").to_time.gmtime
  trigger_gmt_dts = due_gmt.to_time.getlocal(time_zone_offset)#.strftime("%Y%m%dT%H%M%SZ")
end

res = []
content.map{|x|
  re = /^DTSTART;TZID=([^:]+):(.*)/
  re2 = /^SUMMARY:(.*)/
  
  if(x =~ re)
    res.last[:start] = parse_time(x.match(re)[2])
  elsif(x =~ re2)
    res << {start: nil, summary: x.match(re2)[1].strip}
  else
    nil
  end
}

re = /breakfast|lunch|walk/
re2 = /dinner/
summary = nil
last_summary = nil
res2 = (res.sort{|obj, obj_other| obj[:start] <=> obj_other[:start]}).map do |event|
  summary = (summary == nil) ? "good morning" : (event[:summary].match(re) ? "biab" : (event[:summary].match(re2) ? "good evening" : "back"))
  next if(summary == last_summary and last_summary.match(/back|biab/))
  last_summary = summary

  [
    event[:start].strftime("%Y"), 
    event[:start].strftime("%m"), 
    event[:start].strftime("%d"), 
    event[:start].strftime("%H"), 
    event[:start].strftime("%M"), 
    event[:start].strftime("%S"), 
    "0", 
    "", 
    "", 
    "", 
    "", 
    "", 
    "", 
    "", 
    summary
  ].join("\t")
end

puts res2.compact
