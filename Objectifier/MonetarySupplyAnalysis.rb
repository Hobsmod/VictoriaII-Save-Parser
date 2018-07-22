require 'Date'
require 'yaml'

require_relative '..\Classes\Country.rb'
require_relative '..\Classes\Pop.rb'
require_relative '..\Classes\State.rb'
require_relative '..\Classes\Province.rb'
input_dir = 'C:\Program Files (x86)\Steam\steamapps\common\Victoria 2\mod\VictoriaII-Save-Parser\Outputs'

start = Time.now
pop_money = YAML.load(File.read(input_dir + '\\' + 'pop_money.yml'))
#puts "loaded pop_money"
pop_bank = YAML.load(File.read(input_dir + '\\' + 'pop_bank.yml'))
#puts "loaded pop_bank"
country_money = YAML.load(File.read(input_dir + '\\' + 'country_money.yml'))
#puts "loaded country_money"
factory_money = YAML.load(File.read(input_dir + '\\' + 'factory_money.yml'))
#puts "loaded factory_money"

total_hash = Hash.new{|hash, key| hash[key] = Hash.new}
total_hash['test']['test2'] = 'test'

(1837..1935).each do |year|
	total_arr = Array.new
	total_pop_money = 0
	total_pop_bank = 0
	total_country_money = 0
	total_country_bank = 0
	total_country_bank_lent = 0
	total_factory_money = 0
	
	pop_money[year].each do |key, value|
		value.each do |k, v|
			#puts v
			total_pop_money = total_pop_money + v
		end
	end
	
	total_pop_money = total_pop_money / 1000
	
	pop_bank[year].each do |key, value|
		value.each do |k, v|
			#puts v
			total_pop_bank = total_pop_bank + v
		end
	end
	
	total_pop_bank = total_pop_bank / 1000
	
	country_money[year].each do |key, value|
		total_country_money = value['money'] + total_country_money
		total_country_bank = value['bank'] + total_country_bank
		total_country_bank_lent = value['bank lent'] + total_country_bank_lent
	end
	
	factory_money[year].each do |key, value|
		total_factory_money = value + total_factory_money
	end
	
	
	total_hash[year]['pop_money'] = total_pop_money
	total_hash[year]['pop_bank'] = total_pop_bank
	total_hash[year]['country_money'] = total_country_money
	total_hash[year]['country_bank'] = total_country_bank
	total_hash[year]['country_bank_lent'] = total_country_bank_lent
	total_hash[year]['factory_money'] = total_factory_money
	
end


total_hash.each do |year, value|
	this_line = year.to_s + ','
	value.each do |k, v|
		this_line = this_line + v.to_s + ','
	end
	puts this_line
end
File.write('MoneySupply.yml', total_hash.to_yaml)

