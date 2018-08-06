require 'Date'
require 'Oj'

require_relative '..\Methods\objifyMarketData.rb'
require_relative '..\Methods\objifyProvsPops.rb'
require_relative '..\Methods\objifyCountries.rb'
require_relative '..\Methods\objifyStatesAndFactories.rb'
require_relative '..\Classes\GlobalMarketData.rb'




save_dir = 'C:\Program Files (x86)\Steam\steamapps\common\Victoria 2\mod\VictoriaII-Save-Parser\Savegames\PDM'

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
	
	##### Objify Pops and Provs used to be seperate methods but have been merged since there is a lot
	##### of information about provinces that I also want to have attached to pops, and making a seperate
	##### method to unite this info seems redundant.
	pops_n_provs = objifyProvsPops(save_game)
	pops = pops_n_provs[1]
	provinces = pops_n_provs[0]
	puts "finished parsing pop & province data for #{file_name} in #{Time.now - calc_time} seconds"
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
	File.write('Countries.json', Oj.dump(tag_hash))
	File.write('Pops.json', Oj.dump(pops))
	File.write('Provinces.json', Oj.dump(provinces))
	File.write('States.json', Oj.dump(states_n_factories))
	puts "finished writing all data for #{file_name} in #{Time.now - calc_time} seconds, hurrah for OJ's"
	calc_time = Time.now
	Dir::chdir(save_dir)
	puts "Total run time is #{(Time.now - start) / 60.0 } minutes"
end
