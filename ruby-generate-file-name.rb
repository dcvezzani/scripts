#!/bin/ruby

title = ARGV[0]
clean_title = title.gsub(/^[^A-Za-z0-9]*|[^A-Za-z0-9]*$/, '').downcase.
  gsub(/[^A-Za-z0-9]+/, '-')
puts "#{Time.now.strftime('%Y%m%d')}-#{clean_title}.txt"
