require 'oj'
require_relative '..\Classes\Pop.rb'
require_relative '..\Classes\Country.rb'
require_relative '..\Classes\Factory.rb'
require_relative '..\Classes\GlobalMarketData.rb'
require_relative '..\Methods\ExtractFactoryFinancials.rb'
require_relative '..\Methods\PrintHashAsCsv.rb'
require 'csv'
save_dir = '..\Savegames\Vanilla 3.04'








#### Make a 2d Hash of relevant market data.
world_market = Oj.load(File.read(save_dir + '\\' 'Extracts' + '\\' + 'GlobalMarketData.json'))
market_hash = Hash.new{|hash, key| hash[key] = Hash.new}

world_market.each do |data_set|
	market_hash[data_set.year]['total_output'] = data_set.getWorldOutput
	market_hash[data_set.year]['percent output sold'] = data_set.getPrctOutputSold
	market_hash[data_set.year]['percent output gold'] = data_set.getPrctOutputGold	
end

### Make a 2d Hash of relevant pop and country data. 
nominal_money_supply = Hash.new{|hash, key| hash[key] = Hash.new}


pops = Oj.load(File.read(save_dir + '\\' 'Extracts' + '\\' + 'PopFinancialInformation.json'))
pops.each do |this_pop|
	if nominal_money_supply[this_pop.date].has_key?('pop cash reserves')
		nominal_money_supply[this_pop.date]['pop cash reserves'] = this_pop.money + nominal_money_supply[this_pop.date]['pop cash reserves']
	else
		nominal_money_supply[this_pop.date]['pop cash reserves'] = this_pop.money		
	end

	
	if nominal_money_supply[this_pop.date].has_key?('pop bank deposits')
		nominal_money_supply[this_pop.date]['pop bank deposits'] = this_pop.bank + nominal_money_supply[this_pop.date]['pop bank deposits']
	else
		nominal_money_supply[this_pop.date]['pop bank deposits'] = this_pop.bank
	end
end

countries = Oj.load(File.read(save_dir + '\\' 'Extracts' + '\\' + 'CountryFinancialInformation.json'))
countries.each do |country|

	if nominal_money_supply[country.date].has_key?('country cash')
		nominal_money_supply[country.date]['country cash'] = country.money + nominal_money_supply[country.date]['country cash']
	else
		nominal_money_supply[country.date]['country cash'] = country.money
	end
	
	if nominal_money_supply[country.date].has_key?('national bank')
		nominal_money_supply[country.date]['national bank'] = country.bank['money'] + nominal_money_supply[country.date]['national bank']
	else
		nominal_money_supply[country.date]['national bank'] = country.bank['money']
	end
	
	if nominal_money_supply[country.date].has_key?('national bank lent')
		nominal_money_supply[country.date]['national bank lent'] = country.bank['money_lent'] + nominal_money_supply[country.date]['national bank lent']
	else
		nominal_money_supply[country.date]['national bank lent'] = country.bank['money_lent']
	end
end

factories = Oj.load(File.read(save_dir + '\\' 'Extracts' + '\\' + 'FactoryFinancialInformation.json'))
factories.each do |factory|
	if nominal_money_supply[factory.date].has_key?('factory savings')
		nominal_money_supply[factory.date]['factory savings'] = factory.money + nominal_money_supply[factory.date]['factory savings']
		nominal_money_supply[factory.date]['factory savings'] = factory.money
	end
end

#### Calculate National Bank Less Pop Deposits
bank_less_depo_hash = Hash.new

# Throws a fit whenever I try to do this because it says I can't add keys while iterating
# I have no idea what I'm doing that is adding a key here? Does it think bank_less_depo_hash is part 
# of the hash it is iterating?
#nominal_money_supply.each do |cat, hash|
#	hash.each do |year, value|
#		nb = nominal_money_supply['national bank'][year]
#		pb = nominal_money_supply['pop bank deposits'][year]
#		bank_less_deposits =  nb - pb
#		bank_less_depo_hash[year] = bank_less_deposits
#	end
#end

#nominal_money_supply['National Bank Less Pop Deposits'] = bank_less_depo_hash
#####  construct real money supply
real_money_supply = Hash.new{|hash, key| hash[key] = Hash.new}


nominal_money_supply.each do |year, inner_hash|
	inner_hash.each do |cat, val|
		yearly_output = market_hash[year]['total_output']
		new_val =  val / yearly_output
		real_money_supply[year][cat] = new_val
	end
end

output_dir = save_dir + '\\' + 'Analyses\\MonetarySupply\\'

print_hash_as_csv(nominal_money_supply, output_dir + 'NominalMoneySupply.csv', true) 
print_hash_as_csv(real_money_supply, output_dir + 'RealMoneySupply.csv', true) 
print_hash_as_csv(market_hash, output_dir + 'WorldOutput.csv', true) 

