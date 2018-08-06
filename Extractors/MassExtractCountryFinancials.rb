require 'oj'
require_relative '..\Classes\Pop.rb'
require_relative '..\Methods\ExtractCountryFinancials.rb'

save_dir = '..\Savegames\\' + ARGV[0] 


country_array = Array.new


Dir.foreach(save_dir) do |file_name|
	start = Time.now
	unless file_name =~ /Objectified/
		next
	end
	
	this_dir = save_dir + '\\' + file_name

	countries = Oj.load(File.read(this_dir + '\\' + 'Countries.json'))
	puts "loaded countries JSON in #{Time.now - start} seconds"
	time_2 = Time.now
	
	country_array.push(*ExtractCountryFinancials(countries))
	
	puts "extracted financial info from countries for #{file_name} in #{Time.now - start} seconds"
end
	

Dir::chdir(save_dir)
Dir.mkdir('Extracts') unless File.exists?('Extracts')
write_location = 'Extracts' + '\\' + 'CountryFinancialInformation.json'	
File.write(write_location, Oj.dump(country_array))
