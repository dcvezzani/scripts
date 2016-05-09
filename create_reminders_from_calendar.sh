if [ $# -gt 1 ]; then
  src_file="$1"
  dst_file="$2"
else
  src_file='/Users/davidvezzani/Documents/TimeManagement.ics'
  dst_file='/Users/davidvezzani/Documents/todays-reminders.ics'
fi

home='/Users/davidvezzani/scripts'
ruby_home='/Users/davidvezzani/.rvm/rubies/ruby-2.2.0/bin'

if [ -e "$src_file" ]; then
  cat $src_file | sed '/STATUS:CONFIRMED/d;s/:VEVENT/:VTODO/g' | "$ruby_home/ruby" "$home/add_alarms.rb" > $dst_file 
  open -a Reminders $dst_file

  "$home/notify" "Created notifications" File created: "${dst_file}"
  
else
  echo "File not found: $src_file"
  exit 1
fi
