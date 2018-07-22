require 'Date'
require 'yaml'

require_relative '..\Methods\objifyMarketData.rb'
require_relative '..\Methods\objifyProvinces.rb'
require_relative '..\Methods\objifyCountries.rb'
require_relative '..\Methods\objifyStatesAndFactories.rb'
require_relative '..\Methods\objifyPops.rb'
require_relative '..\Methods\addPopOwners.rb'

save_dir = 'C:\Users\sdras\Documents\Paradox Interactive\Victoria II\save games\madagascar'

(1837..1936).each do |year|
	this_dir = save_dir + '\\' + year.to_s + '-Objectified'
	
	#### We already parsed each save file into arrays/hashes of objects and now we 
	#### load them
	provs = this_dir + '\\' + 'Provinces.yml'
	pops = this_dir + '\\' + 'Pops.yml'
	
	addPopOwners(pops, provs)
	
	puts year
end
	
	
