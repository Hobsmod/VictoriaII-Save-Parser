require 'oj'
require_relative '..\Classes\Pop.rb'
require_relative '..\Classes\Country.rb'
require_relative '..\Classes\Factory.rb'
require_relative '..\Classes\GlobalMarketData.rb'
require_relative '..\Methods\ExtractFactoryFinancials.rb'
require_relative '..\Methods\PrintHashAsCsv.rb'
require 'csv'
save_dir = '..\Savegames\no_sphere_test'








#### Make a 2d Hash of relevant market data.
world_market = Oj.load(File.read(save_dir + '\\' 'Extracts' + '\\' + 'GlobalMarketData.json'))
market_hash = Hash.new{|hash, key| hash[key] = Hash.new}

world_market.each do |data_set|
	market_hash[data_set.year]['total_output'] = data_set.getWorldOutput
	market_hash[data_set.year]['percent output sold'] = data_set.getPrctOutputSold
	market_hash[data_set.year]['percent output gold'] = data_set.getPrctOutputGold	
end



output_dir = save_dir + '\\' + 'Analyses\\'

print_hash_as_csv(market_hash, output_dir + 'WorldOutput.csv', true) 

