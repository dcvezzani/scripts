
low = ARGV[1].to_i(10)
high = ARGV[0].to_i(10)
step = ((high - low) / 10)
#puts "#{low}, #{high}, #{step}"
sec = low
res = []
while(sec < high+1)
	res << "#{sec}; #{`date -r #{sec} -u`}"
	sec += step
end

#puts "\n  " + res.reverse.join("\n\n  ") + "\n\n"
puts (res.reverse.join("")).strip
