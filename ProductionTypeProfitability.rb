require 'Date'
require 'yaml'

require_relative 'Methods\GetActualSold.rb'
require_relative 'Methods\getDemand.rb'
require_relative 'Methods\getPrices.rb'
require_relative 'Methods\getSupply.rb'
require_relative 'Methods\getBasePrices.rb'
require_relative 'Methods\getProductionTypes.rb'


game_dir = 'C:\Program Files (x86)\Steam\steamapps\common\Victoria 2\common'
save_dir = 'C:\Users\sdras\Documents\Paradox Interactive\Victoria II\save games\madagascar'
time = Time.now

prices = Hash.new{|hash, key| hash[key] = Hash.new}
profit_hash = Hash.new{|hash, key| hash[key] = Hash.new}

production_types = getProductionTypes(game_dir)


Dir.foreach(save_dir) do |filename|
	
	prices = Hash.new{|hash, key| hash[key] = Hash.new}
	
### Don't interate over . and .. create the filename
	if filename.to_s.length < 3
		next
	end
	savefile = save_dir + "\\" + filename
	
	# Get the Date!
	date = 0
	File.open(savefile).each do |line|
		if line =~ /date/
			line.gsub! /\n/, ''
			split_line = line.split('=')
			date = split_line[1].gsub!(/\A"|"\Z/, '')
			date_splits = split_line[1].split('.')
		end
			
		break unless date == 0
	end
	
	
	prices = getPriceAverages(savefile, prices)
	
	cattle =  prices[date]['cattle'] * 0.75
	wool =  prices[date]['wool']
	fruit = prices[date]['fruit']
	fish = prices[date]['fish']
	grain = prices[date]['grain'] * 2.5
	life_needs_cost = cattle + wool + fruit + fish + grain
	life_need_adj = life_needs_cost / 20
	
	production_types.each do |type|
		profit_hash[date][type.name] = type.getProfit(prices[date]) / life_needs_cost
	end


	#puts "Finished Averages"
end


prod_type_profit_csv = "Outputs\\Profits.csv"
price_avg_out = File.open(prod_type_profit_csv, 'w')

profit_hash.each do |date, good_profit|
	print_line = 'Date' + ','
	good_profit.each do |good, profit|
		print_line = print_line + good.to_s + ','
	end
	print_line = print_line + "\n"
	price_avg_out.write(print_line)
	break
end
	

profit_hash.each do |date, good_profit|
	print_line = date.to_s + ','
	good_profit.each do |good, profit|
		relative_price = profit
		print_line = print_line + relative_price.to_s + ','
	end
	print_line = print_line + "\n"
	price_avg_out.write(print_line)
end