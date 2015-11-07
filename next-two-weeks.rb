require 'date'

Date.today + (60*60*24)
(Date.today + 7).strftime("%a, %Y-%m-%d")

d = Date.today

while(d.strftime("%a") != 'Sun') do
  d += 1
end

(0..11).each do |x|
  puts (d + (x*7)).strftime("%Y-%m-%d")
end
