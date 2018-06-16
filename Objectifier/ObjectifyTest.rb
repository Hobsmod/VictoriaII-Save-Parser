require 'Date'
require 'yaml'

require_relative 'Methods\objifyMarketData.rb'
require_relative 'Methods\objifyProvinces.rb'
require_relative 'Methods\objifyCountries.rb'
require_relative 'Methods\objifyStatesAndFactories.rb'


save_game = 'C:\Users\sdras\Documents\Paradox Interactive\Victoria II\save games\madagascar\1837.txt'

start = Time.now


#objifyProvinces(save_game)
objifyStatesAndFactories(save_game)

finish = Time.now - start

puts finish