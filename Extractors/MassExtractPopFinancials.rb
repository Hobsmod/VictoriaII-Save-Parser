require 'oj'
require_relative '..\Classes\Pop.rb'
require_relative '..\Methods\ExtractPopFinancials.rb'

save_dir = '..\Savegames\Vanilla 3.04'


all_pop_array = Array.new


Dir.foreach(save_dir) do |file_name|
	start = Time.now
	unless file_name =~ /Objectified/
		next
	end
	
	this_dir = save_dir + '\\' + file_name

	pops = Oj.load(File.read(this_dir + '\\' + 'Pops.json'))
	puts "loaded prov JSON in #{Time.now - start} seconds"
	time_2 = Time.now
	
	all_pop_array.push(*ExtractPopFinancials(pops))
	
	puts "extracted financial info from pops for #{file_name} in #{Time.now - start} seconds"
end
	

Dir::chdir(save_dir)
Dir.mkdir('Extracts') unless File.exists?('Extracts')
write_location = save_dir + '\\' + 'Extracts' + '\\' + 'PopFinancialInformation.json'	
File.write(write_location, Oj.dump(all_pop_array))
