#!/Users/dvezzani/.rvm/rubies/ruby-2.0.0-p353/bin/ruby

# import tasks from plain text file into Reminders
# 
# e.g.,
# ruby create-ics-reminders.rb /Users/davidvezzani/Documents/journal/in-reminders.txt > out-reminders.ics; open out-reminders.ics

# require 'byebug'
require 'time'
dir = "/Users/davidvezzani/Documents/journal"

filename = "#{dir}/tmp-reminders.txt"
tasks = nil
if(ARGV.length > 0)
  filename = ARGV[0]
  tasks = IO.readlines(filename)
  
else
  tds = Time.now
  puts "give me the reminders, please:"
  #tasks = STDIN.gets.chomp.split(/[\r\n]+/)
  `mvim #{dir}/in-reminders.txt`

  filename = "#{dir}/in-reminders.txt"
  # loop do
  #   f = File.open(filename)
  #   mtime = File.mtime(f)
  #   f.close
  #   break if(mtime > tds)
  #   puts "comparing #{tds} with #{mtime}..."
  #   sleep(2)
  # end

  tasks = IO.readlines(filename)

  if(!(tasks and tasks.length > 0))
    puts "Usage: ruby create-ics-reminders.rb /Users/davidvezzani/Documents/journal/in-reminders.txt > out-reminders.ics; open out-reminders.ics"
    exit(1)
  end
end

#File.open(filename, "w"){|f| f.write tasks}

# debugger
out = tasks.map do |task|

#md = task.match(/(.*)\t([^\t]*)\t(\d+:\d\d) ([AP]M)$/)
#md = task.match(/(.*)\t([^\t]*)\t(\d+:\d\d)$/)
#md = task.match(/^((\t*)|([^\t]*)\t)([^\t]*)\t(\d+:\d\d)$/)
md = task.split(/[\t\n]/)

summary = md[1]
# summary.gsub!(/https*:\/\/[^ 	]+/, '<a href="\0">\0</a>')
summary.gsub!(/https*:\/\/[^ 	]+/, '<\0>')

jira_task_id = md[0]
hr_min = md[4]
#am_pm = md[4]
time_zone_indicator = ["PST", "America/Los_Angeles"]
time_zone_offset = '-08:00'

#39D78C4C-638D-4DBD-880E-78C499F1CD41
uid = "#{rand.to_s.slice(2,8)}-#{rand.to_s.slice(2,4)}-#{rand.to_s.slice(2,4)}-#{rand.to_s.slice(2,4)}-#{rand.to_s.slice(2,12)}"

#20150206T165758Z
dtstamp_gmt = Time.now.gmtime
dtstamp_local_dts = dtstamp_gmt.getlocal(time_zone_offset).strftime("%Y%m%dT%H%M%S")
dtstamp_gmt_dts = dtstamp_gmt.strftime("%Y%m%dT%H%M%SZ")

#due_gmt = DateTime.strptime(Time.now.getlocal('-08:00').strftime("%Y%m%dT") + "#{hr_min}:00 #{am_pm} #{time_zone_indicator[0]}", "%Y%m%dT%H:%M:%S %p %Z").to_time.gmtime
due_gmt = DateTime.strptime(Time.now.getlocal(time_zone_offset).strftime("%Y%m%dT") + "#{hr_min}:00 #{time_zone_indicator[0]}", "%Y%m%dT%H:%M:%S %Z").to_time.gmtime
#due = DateTime.strptime(Time.now.gmtime.strftime("%Y%m%dT") + "#{hr_min}:00 #{am_pm}", "%Y%m%dT%H:%M:%S %p")
due_local_dts = due_gmt.to_time.getlocal(time_zone_offset).strftime("%Y%m%dT%H%M%S")

# unsure why "+8" is necessary for Exchange, but it's working; strange...
#trigger_gmt_dts = due_gmt.to_time.getlocal(time_zone_offset).strftime("%Y%m%dT%H%M%SZ")
# this is what I use for my Google reminders
# trigger_gmt_dts = due_gmt.to_time.getlocal('+01:00').strftime("%Y%m%dT%H%M%SZ")
# and now I need to do this (getting off/on daylight savings time?)
#
# day light savings ON
# trigger_gmt_dts = due_gmt.to_time.getlocal('-01:00').strftime("%Y%m%dT%H%M%SZ")
#
# day light savings OFF
trigger_gmt_dts = due_gmt.to_time.getlocal('+00:00').strftime("%Y%m%dT%H%M%SZ")

x_wr_alarmuid = "#{rand.to_s.slice(2,8)}-#{rand.to_s.slice(2,4)}-#{rand.to_s.slice(2,4)}-#{rand.to_s.slice(2,4)}-#{rand.to_s.slice(2,12)}"

entry = <<-EOL
BEGIN:VTODO
CREATED:#{dtstamp_gmt_dts}
UID:#{uid}
X-APPLE-EWS-CHANGEKEY:EwAAABYAAADmBoe15NdiSLhyIEakJjs4AAFC/gnl
X-APPLE-EWS-NEEDSSERVERCONFIRMATION:TRUE
SUMMARY:#{summary}
DESCRIPTION:#{jira_task_id}
DTSTART;TZID=#{time_zone_indicator[1]}:#{due_local_dts}
DTSTAMP:#{due_local_dts}
X-APPLE-EWS-ITEMID:AAMkADM2MTQyZjUyLTQ4NTktNDYzNS1iNGM2LTgwMGZlYThhNmMyM
 gBGAAAAAAB2XSLIqaOOR7qu3Kn3upEYBwDmBoe15NdiSLhyIEakJjs4AAFC45JsAADmBoe15
 NdiSLhyIEakJjs4AAFC45o+AAA=
SEQUENCE:0
DUE;TZID=#{time_zone_indicator[1]}:#{due_local_dts}
BEGIN:VALARM
X-WR-ALARMUID:#{x_wr_alarmuid}
UID:#{x_wr_alarmuid}
TRIGGER;VALUE=DATE-TIME:#{trigger_gmt_dts}
DESCRIPTION:Event reminder
ACTION:DISPLAY
END:VALARM
END:VTODO
EOL

end


#File.open("#{dir}/out-reminders.ics", "w"){|f| f.write <<-EOL

res = <<-EOL
BEGIN:VCALENDAR
VERSION:2.0
PRODID:-//Apple Inc.//Mac OS X 10.10.2//EN
CALSCALE:GREGORIAN
BEGIN:VTIMEZONE
TZID:America/Los_Angeles
BEGIN:DAYLIGHT
TZOFFSETFROM:-0800
RRULE:FREQ=YEARLY;BYMONTH=3;BYDAY=2SU
DTSTART:20070311T020000
TZNAME:PDT
TZOFFSETTO:-0700
END:DAYLIGHT
BEGIN:STANDARD
TZOFFSETFROM:-0700
RRULE:FREQ=YEARLY;BYMONTH=11;BYDAY=1SU
DTSTART:20071104T020000
TZNAME:PST
TZOFFSETTO:-0800
END:STANDARD
END:VTIMEZONE
#{out.join("").chomp}
END:VCALENDAR
EOL

puts res
#}


