require 'Date'
require 'yaml'

require_relative '..\Classes\Country.rb'
require_relative '..\Classes\Pop.rb'
require_relative '..\Classes\State.rb'
require_relative '..\Classes\Province.rb'
save_dir = 'C:\Users\sdras\Documents\Paradox Interactive\Victoria II\save games\madagascar'

start = Time.now
pop_money = Hash.new{|hash, key| hash[key] = Hash.new{|h, k| h[k] = Hash.new}}
pop_bank = Hash.new{|hash, key| hash[key] = Hash.new{|h, k| h[k] = Hash.new}}
country_money = Hash.new{|hash, key| hash[key] = Hash.new{|h, k| h[k] = Hash.new}}
factory_money = Hash.new{|hash, key| hash[key] = Hash.new}
state_money = Hash.new{|hash, key| hash[key] = Hash.new}

(1837..1935).each do |year|
	this_dir = save_dir + '\\' + year.to_s + '-Objectified'
	prov_owners = Hash.new
	puts year
	#### We already parsed each save file into arrays/hashes of objects and now we 
	#### load them
	pop_arr = YAML.load(File.read(this_dir + '\\' + 'Pops.yml'))
	puts "loaded pops"
	puts Time.now - start
	
	#### Calculate Pop Savings & Pop Money sorted by owner & type
	pop_arr.each do |this_pop|
		if this_pop.bank.nil?
			bank = 0.0
		else
			bank = this_pop.bank
		end
		
		if pop_money[year][this_pop.owner][this_pop.type].nil?
		  pop_money[year][this_pop.owner][this_pop.type] = this_pop.money
		else
			pop_money[year][this_pop.owner][this_pop.type] = this_pop.money + pop_money[year][this_pop.owner][this_pop.type]
		end
		
		if pop_bank[year][this_pop.owner][this_pop.type].nil?
		  pop_bank[year][this_pop.owner][this_pop.type] = bank
		else
			pop_bank[year][this_pop.owner][this_pop.type] = bank + pop_bank[year][this_pop.owner][this_pop.type]
		end
	end
	
	#### Calculate Country Money
	tag_hash = YAML.load(File.read(this_dir + '\\' + 'Countries.yml'))
	puts "loaded tags"
	puts Time.now - start
	
	##### Money is just an attr with an accesor for country objects, bank is a hash
	##### withing the country object with keys, money and money_lent
	tag_hash.each do |tag, data|
		country_money[year][tag]['money'] = data.money
		country_money[year][tag]['bank'] = data.bank['money']
		country_money[year][tag]['bank lent'] = data.bank['money_lent']
	end
	

	### Calculate Factory money
	state_arry = YAML.load(File.read(this_dir + '\\' + 'States.yml'))
	puts "loaded states"
	puts Time.now - start
	
	state_arry.each do |this_state|
		this_state.buildings.each do |this_building|
			if factory_money[year][this_state.owner].nil?
				factory_money[year][this_state.owner] = this_building.money / 1000.0
			else
				factory_money[year][this_state.owner] = (this_building.money / 1000.0) + factory_money[year][this_state.owner]
			end
		end
	end	
	
	puts year
end
	
File.write('pop_money.yml', pop_money.to_yaml)
File.write('pop_bank.yml', pop_bank.to_yaml)
File.write('country_money.yml', country_money.to_yaml)
File.write('factory_money.yml', factory_money.to_yaml)