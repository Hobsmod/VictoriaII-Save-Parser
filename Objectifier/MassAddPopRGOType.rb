require 'yaml'

require_relative 'Classes\Pop.rb'
require_relative 'Classes\Province.rb'
require_relative 'Methods\addPopRgoType.rb'

save_dir = 'C:\Users\sdras\Documents\Paradox Interactive\Victoria II\save games\madagascar'

Dir.foreach(save_dir) do |file_name|
	start = Time.now
	unless file_name =~ /Objectified/
		next
	end
	
	this_dir = save_dir + '\\' + file_name

	provs = YAML.load(File.read(this_dir + '\\' + 'Provinces.yml'))
	puts "loaded prov YAML in #{Time.now - start} seconds"
	time_2 = Time.now
	pops = YAML.load(File.read(this_dir + '\\' + 'Pops.yml'))
	puts "loaded pop YAML in #{Time.now - time_2} seconds"
	
	
	
	addPopRgoType(pops, provs)
	puts "added trade_goods to pops for #{file_name} in #{Time.now - start} seconds"
end
	
	
