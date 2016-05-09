if [ $# -gt 1 ]; then
  src_file="$1"
else
  src_file='/Users/davidvezzani/Documents/TimeManagement.ics'
fi

home='/Users/davidvezzani/scripts'
ruby_home='/Users/davidvezzani/.rvm/rubies/ruby-2.2.0/bin'

if [ -e "$src_file" ]; then
  
  cat "$src_file" | "$ruby_home/ruby" "$home/create_timesheet_projections.rb" | pbcopy
  "$home/notify" "Done"'!' "timesheet has been copied to clipboard"
  
else
  echo "File not found: $src_file"
  exit 1
fi

