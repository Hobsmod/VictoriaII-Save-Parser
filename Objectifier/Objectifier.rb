require 'Date'
require 'Oj'

require_relative 'Methods\objifyMarketData.rb'
require_relative 'Methods\objifyProvinces.rb'
require_relative 'Methods\objifyCountries.rb'
require_relative 'Methods\objifyStatesAndFactories.rb'
require_relative 'Classes\GlobalMarketData.rb'
require_relative 'Methods\addPopOwners.rb'
require_relative 'Methods\addPopRgoType.rb'
require_relative 'Methods\objifyPops.rb'



save_dir = '..\Savegames\Vanilla 3.04'

start = Time.now

Dir.foreach(save_dir) do |file_name|
	next if file_name == '.' or file_name == '..' or file_name =~ /Objectified/

	save_game = save_dir + '\\' + file_name
	calc_time = Time.now
	market_data = objifyMarketData(save_game)
	market_data.calcPriceAvgs
	puts "finished parsing market data for #{file_name} in #{Time.now - calc_time} seconds"
	calc_time = Time.now
	
	tag_hash = objifyCountries(save_game)
	puts "finished parsing country data for #{file_name} in #{Time.now - calc_time} seconds"
	calc_time = Time.now
	
	provinces = objifyProvinces(save_game)
	puts "finished parsing province data for #{file_name} in #{Time.now - calc_time} seconds"
	calc_time = Time.now
	
	pops = objifyPops(save_game)
	addPopOwners(pops, provinces)
	addPopRgoType(pops, provinces)
	
	puts "finished parsing pop data for #{file_name} in #{Time.now - calc_time} seconds"
	calc_time = Time.now
	
	states_n_factories = objifyStatesAndFactories(save_game)
	puts "finished parsing state and factory data for #{file_name} in #{Time.now - calc_time} seconds"
	calc_time = Time.now




	#### Create an Objectified folder wherever the save_game is
	#### which is the top level folder (There is surely a better
	#### way to do this but I suck and this works)
	save_dir = File.dirname(save_game)
	game_name = File.basename(save_game, ".*") + '-Objectified' 
	Dir::chdir(save_dir)
	Dir.mkdir(game_name) unless File.exists?(game_name)
		
		
		
	#### Move down into the objectified folder and print the 
	####  data as YAML's. I'd love to print these as JSON's but to_json just prints
	#### references to the objects not the whole object
	Dir::chdir(game_name)
	File.write('MarketData.json', Oj.dump(market_data))
	puts "finished writing market data for #{file_name} in #{Time.now - calc_time} seconds"
	calc_time = Time.now
	File.write('Countries.json', Oj.dump(tag_hash))
	puts "finished writing country data for #{file_name} in #{Time.now - calc_time} seconds"
	calc_time = Time.now
	File.write('Pops.json', Oj.dump(pops))
	puts "finished writing pop data for #{file_name} in #{Time.now - calc_time} seconds"
	calc_time = Time.now
	File.write('Provinces.json', Oj.dump(provinces))
	puts "finished writing province data for #{file_name} in #{Time.now - calc_time} seconds"
	calc_time = Time.now
	File.write('States.json', Oj.dump(states_n_factories))
	puts "finished writing state and factory data for #{file_name} in #{Time.now - calc_time} seconds"
	calc_time = Time.now

	puts "Total run time is #{Time.now - start}"
end
