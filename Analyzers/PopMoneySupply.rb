require 'oj'
require_relative '..\Objectifier\Classes\Pop.rb'
require_relative '..\Extractors\Methods\ExtractFactoryFinancials.rb'
require_relative '..\Methods\PrintHashAsCsv.rb'
require 'csv'
save_dir = 'C:\Users\sdras\Documents\Paradox Interactive\Victoria II\save games\madagascar'



pops = Oj.load(File.read(save_dir + '\\' 'Extracts' + '\\' + 'PopFinancialInformation.json'))

by_type_money = Hash.new{|hash, key| hash[key] = Hash.new}
by_type_bank = Hash.new{|hash, key| hash[key] = Hash.new}
by_tag_money = Hash.new{|hash, key| hash[key] = Hash.new}
by_tag_bank = Hash.new{|hash, key| hash[key] = Hash.new}

pops.each do |this_pop|
	unless by_type_money[this_pop.date][this_pop.type].nil?
		by_type_money[this_pop.date][this_pop.type] = this_pop.money + by_type_money[this_pop.date][this_pop.type]
	else
		by_type_money[this_pop.date][this_pop.type] = this_pop.money
	end
	
	unless by_type_bank[this_pop.date][this_pop.type].nil?
		pop_bank = 0
		unless this_pop.bank.nil?
			pop_bank = this_pop.bank
		end
		by_type_bank[this_pop.date][this_pop.type] = pop_bank + by_type_bank[this_pop.date][this_pop.type]
	else
		
		pop_bank = 0
		unless this_pop.bank.nil?
			pop_bank = this_pop.bank
		end
		
		by_type_bank[this_pop.date][this_pop.type] = pop_bank
	end
	
	unless by_tag_money[this_pop.date][this_pop.owner].nil?
		by_tag_money[this_pop.date][this_pop.owner] = this_pop.money + by_tag_money[this_pop.date][this_pop.owner]
	else
		by_tag_money[this_pop.date][this_pop.owner] = this_pop.money
	end
	
	unless by_tag_bank[this_pop.date][this_pop.owner].nil?
		pop_bank = 0
		
		##### Getting errors where some pop banks are nil, will search later for why
		unless this_pop.bank.nil?
			pop_bank = this_pop.bank
		end
		by_tag_bank[this_pop.date][this_pop.owner] = pop_bank + by_tag_bank[this_pop.date][this_pop.owner]
	else
	
		pop_bank = 0
		
		##### Getting errors where some pop banks are nil, will search later for why
		unless this_pop.bank.nil?
			pop_bank = this_pop.bank
		end
		by_tag_bank[this_pop.date][this_pop.owner] = pop_bank
	end

end

output_dir = save_dir + '\\' + 'Analyses' + '\\'
type_money_out = output_dir + 'Poptype_Money.csv'
type_bank_out = output_dir + 'Poptype_Bank.csv'
tag_money_out = output_dir + 'Tag_Money.csv'
tag_bank_out = output_dir + 'Tag_Bank.csv'

f_type_money = File.new(type_money_out, 'w')
f_type_bank = File.new(type_bank_out, 'w')
f_tag_bank = File.new(tag_bank_out, 'w')
f_tag_money = File.new(tag_money_out, 'w')


print_hash_as_csv(by_type_money, f_type_money)
print_hash_as_csv(by_type_bank, f_type_bank)
print_hash_as_csv(by_tag_money, f_tag_money)
print_hash_as_csv(by_tag_bank, f_tag_bank)