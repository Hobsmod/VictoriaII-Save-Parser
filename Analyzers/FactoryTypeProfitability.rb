require 'oj'
require_relative '..\Objectifier\Classes\Factory.rb'
require_relative '..\Extractors\Methods\ExtractFactoryFinancials.rb'
require 'csv'
save_dir = 'C:\Users\sdras\Documents\Paradox Interactive\Victoria II\save games\madagascar'



factories = Oj.load(File.read(save_dir + '\\' 'Extracts' + '\\' + 'FactoryFinancialInformation.json'))
subsidised_hash = Hash.new{|hash, key| hash[key] = Array.new}
unsub_hash = Hash.new{|hash, key| hash[key] = Array.new}
both_hash = Hash.new{|hash, key| hash[key] = Array.new}

factories.each do |this_factory|
	if this_factory.subsidised == true
		factory_arr = Array.new
		factory_arr.push(this_factory.date)
		factory_arr.push(this_factory.money)
		factory_arr.push(this_factory.level)
		factory_arr.push(this_factory.avg_profit)
		factory_arr.push(this_factory.total_employees)
		subsidised_hash[this_factory.type].push(factory_arr)
	else
		factory_arr = Array.new
		factory_arr.push(this_factory.date)
		factory_arr.push(this_factory.money)
		factory_arr.push(this_factory.level)
		factory_arr.push(this_factory.avg_profit)
		factory_arr.push(this_factory.total_employees)
		unsub_hash[this_factory.type].push(factory_arr)
	end
	
	factory_arr = Array.new
	factory_arr.push(this_factory.date)
	factory_arr.push(this_factory.money)
	factory_arr.push(this_factory.level)
	factory_arr.push(this_factory.avg_profit)
	factory_arr.push(this_factory.total_employees)
	both_hash[this_factory.type].push(factory_arr)

end

unsub_hash.each do |type, value|
	out_file = save_dir + '\\' 'Extracts' + '\\' + 'FactoryProfitability' + '-' + type + '.csv'
	open(out_file, 'w') { |f|
		value.each do |factory_arr|
			f.print factory_arr.to_csv
		end
	}
end