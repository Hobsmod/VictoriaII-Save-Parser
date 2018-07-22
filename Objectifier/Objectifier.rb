require 'Date'
require 'oj'

require_relative 'Methods\objifyMarketData.rb'
require_relative 'Methods\objifyProvinces.rb'
require_relative 'Methods\objifyCountries.rb'
require_relative 'Methods\objifyStatesAndFactories.rb'
require_relative 'Methods\objifyPops.rb'

save_dir = 'C:\Users\sdras\Documents\Paradox Interactive\Victoria II\save games\madagascar'

Dir.foreach(save_dir) do |save_game|
  next if save_game == '.' or save_game == '..' or save_game =~ /Objectified/
	puts save_game
	start = Time.now
	market_data = objifyMarketData(save_dir + '\\' + save_game)
	
	File.write('MarketData.json', Oj.dump(market_data))
	
	mdat2 = Oj.load(File.read('MarketData.json'))
	puts mdat2.getWorldOutput
end

	
