require 'Date'
require 'yaml'

require_relative 'Methods\objifyMarketData.rb'
require_relative 'Methods\objifyProvinces.rb'
require_relative 'Methods\objifyCountries.rb'
require_relative 'Methods\objifyStatesAndFactories.rb'


save_game = 'C:\Program Files (x86)\Steam\steamapps\common\Victoria 2\mod\save games\madagascar\1837.txt'

start = Time.now


#objifyProvinces(save_game)
objifyStatesAndFactories(save_game)

finish = Time.now - start

puts finish