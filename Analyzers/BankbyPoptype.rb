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
pops = Oj.load(File.read(save_dir + '\\' 'Extracts' + '\\' + 'PopFinancialInformation.json'))
savings_by_type = Hash.new{|hash, key| hash[key] = Hash.new}
laborers_by_good = Hash.new{|hash, key| hash[key] = Hash.new}
### Make a 2d Hash of relevant pop and country data. 
nominal_money_supply = Hash.new{|hash, key| hash[key] = Hash.new}


pops = Oj.load(File.read(save_dir + '\\' 'Extracts' + '\\' + 'PopFinancialInformation.json'))
pops.each do |this_pop|
	if savings_by_type[this_pop.date].has_key?(this_pop.type)
		savings_by_type[this_pop.date][this_pop.type] = this_pop.bank + savings_by_type[this_pop.date][this_pop.type]
	else
		savings_by_type[this_pop.date][this_pop.type] = this_pop.bank	
	end

	if this_pop.type =~ /labourer/
		if laborers_by_good[this_pop.date].has_key?(this_pop.rgo_type)
			laborers_by_good[this_pop.date][this_pop.rgo_type] = this_pop.bank + laborers_by_good[this_pop.date][this_pop.rgo_type]
		else
			laborers_by_good[this_pop.date][this_pop.rgo_type] = this_pop.bank
		end
	end
end

output_dir = save_dir + '\\' + 'Analyses\\MonetarySupply\\'

print_hash_as_csv(savings_by_type, output_dir + 'PopBankbyPoptype.csv', true) 
print_hash_as_csv(laborers_by_good, output_dir + 'LabourerSavingsbyGood.csv', true) 


