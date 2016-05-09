#!/Users/dvezzani/.rvm/rubies/ruby-2.0.0-p353/bin/ruby
# add_alarms.rb

content = ARGF.readlines
home='/Users/davidvezzani/scripts'

content.map!{|x|
  re = /DTSTART;TZID=([^:]+):(.*)/
  
  if(x =~ re)
    stzon = x.match(re)[1]
    sdate = x.match(re)[2]
    alarm = `ruby #{home}/create_alarm.rb #{sdate}`

    due_date = "DUE;TZID=#{stzon}:#{sdate}\n"
    
    [x, due_date, alarm].join("")
  else
    x
  end
}

puts content
