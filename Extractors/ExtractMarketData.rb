require 'Date'
require 'yaml'
require 'oj'
require_relative '..\Classes\GlobalMarketData.rb'



save_dir = '..\Savegames' + '\\' + ARGV[0]

start = Time.now
world_markets = Array.new




Dir.foreach(save_dir) do |file_name|
	start = Time.now
	unless file_name =~ /Objectified/
		next
	end
	
	this_dir = save_dir + '\\' + file_name

	world_market = Oj.load(File.read(this_dir + '\\' + 'MarketData.json'))
	puts "loaded  world_market JSON in #{Time.now - start} seconds"
	time_2 = Time.now
	
	world_markets.push(world_market)
	
	puts "extracted world market data for #{file_name} in #{Time.now - start} seconds"
end
	

write_location = save_dir + '\\' + 'Extracts' + '\\' + 'GlobalMarketData.json'	
File.write(write_location, Oj.dump(world_markets))