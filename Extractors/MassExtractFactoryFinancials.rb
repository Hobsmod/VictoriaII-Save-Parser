require 'oj'
require_relative '..\Classes\Pop.rb'
require_relative '..\Methods\ExtractFactoryFinancials.rb'

save_dir = '..\Savegames\\' + ARGV[0]


all_factories_array = Array.new


Dir.foreach(save_dir) do |file_name|
	start = Time.now
	unless file_name =~ /Objectified/
		next
	end
	
	this_dir = save_dir + '\\' + file_name

	states = Oj.load(File.read(this_dir + '\\' + 'States.json'))
	puts "loaded states JSON in #{Time.now - start} seconds"
	time_2 = Time.now
	
	all_factories_array.push(*ExtractFactoryFinancials(states))
	
	puts "extracted financial info from factories for #{file_name} in #{Time.now - start} seconds"
end
	

Dir::chdir(save_dir)
Dir.mkdir('Extracts') unless File.exists?('Extracts')
write_location = 'Extracts' + '\\' + 'CountryFinancialInformation.json'	
File.write(write_location, Oj.dump(all_factories_array))
