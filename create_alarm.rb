#!/Users/dvezzani/.rvm/rubies/ruby-2.0.0-p353/bin/ruby

require 'time'

target_time = Time.parse(ARGV[0])
hr_min = target_time.strftime("%H:%M")
time_zone_indicator = ["PST", "America/Los_Angeles"]
time_zone_offset = '-08:00'

due_gmt = DateTime.strptime(target_time.getlocal(time_zone_offset).strftime("%Y%m%dT") + "#{hr_min}:00 #{time_zone_indicator[0]}", "%Y%m%dT%H:%M:%S %Z").to_time.gmtime
trigger_gmt_dts = due_gmt.to_time.getlocal('-01:00').strftime("%Y%m%dT%H%M%SZ")
x_wr_alarmuid = "#{rand.to_s.slice(2,8)}-#{rand.to_s.slice(2,4)}-#{rand.to_s.slice(2,4)}-#{rand.to_s.slice(2,4)}-#{rand.to_s.slice(2,12)}"

entry = <<-EOL
BEGIN:VALARM
X-WR-ALARMUID:#{x_wr_alarmuid}
UID:#{x_wr_alarmuid}
TRIGGER;VALUE=DATE-TIME:#{trigger_gmt_dts}
DESCRIPTION:Event reminder
ACTION:DISPLAY
END:VALARM
EOL

puts entry.strip
