require 'json'
require 'time'

content = IO.read('/Users/dcvezzani/Documents/journal/current/20180314-storm-session-01.json')
json = JSON.parse(content)

# puts json

state = 'ended'
fromPhone, toPhone, dateStart, dateStop, startCall = nil
history = []

json.each do |entry|
	# if entry.status == 'ORIGINATED'
	t = Time.at(entry['outgoingTime'])
	dts = t.to_s.gsub(/49847/, '2017')
	dts.to_s.gsub!(/49846/, '2016')
	attrs = {}
	attrs['outgoingTime'] = dts

	if entry['status'] == 'ORIGINATING' && entry['callType'] == 'TARGET'
		toPhone = entry['phone']
		# history << ''
	end

	if entry['status'] == 'BRIDGED' && entry['callType'] == 'USER'
		fromPhone = entry['phone']
	end
	
	if entry['status'] == 'BRIDGED' && entry['callType'] == 'TARGET'
		startCall = dts;
	end

	if entry['hangupCause']
		attrs['legConnection'] = "#{fromPhone} > #{toPhone}"
		toPhone = nil;

		case entry['hangupCause']
		when "DESTINATION_OUT_OF_ORDER"
			attrs['hangupDesc'] = "destination device failed to receive signal from freeswitch"
		when "MANAGER_REQUEST"
			attrs['hangupDesc'] = "agent (a-leg) hung up the target (b-leg)"
		when "NORMAL_CLEARING"
			attrs['hangupDesc'] = "target (b-leg) hung up the agent (a-leg)"
		when "NO_ANSWER"
			attrs['hangupDesc'] = "nobody answered the phone"
		when "UNALLOCATED_NUMBER"
			attrs['hangupDesc'] = "phone number is no longer in service"
		end
	end

	if entry['hangupCause'] && !startCall.nil?
		attrs['callTimeElapsed'] = (((Time.parse(dts) - Time.parse(startCall)) / 3600) * 10).ceil/10.0
		attrs['startCall'] = startCall 
		attrs['stopCall'] = dts
		startCall = nil
	end

	history << entry.merge(attrs)
end

puts JSON.dump(history)
# puts history

 #"outgoingTime"=>"2017-02-14 05:44:04 -0700", "legConnection"=>"7028719500 > 5105626097", "hangupDesc"=>"agent (a-leg) hung up the target (b-leg)", "callTimeElapsed"=>1.7}

