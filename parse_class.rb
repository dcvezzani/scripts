load '/Users/davidvezzani/Dropbox/journal/04-apr-2016/my_class_parser.rb'

#class_name = 'Jobs::GetVariantSku::JobBuffer'
class_name = ENV['RAILS_CLASS_NAME']
filename = "#{class_name.gsub(/\W+/, '-').downcase}.json"
MyClassParser.new(class_name.constantize).write_report(filename)

puts filename
