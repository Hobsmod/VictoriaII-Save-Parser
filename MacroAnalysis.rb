require 'Date'
require 'yaml'

require_relative 'Methods\GetActualSold.rb'
require_relative 'Methods\getDemand.rb'
require_relative 'Methods\getPrices.rb'
require_relative 'Methods\getSupply.rb'
require_relative 'Methods\getBasePrices.rb'

game_dir = 'C:\Program Files (x86)\Steam\steamapps\common\Victoria 2\common'
save_dir = 'C:\Users\sdras\Documents\Paradox Interactive\Victoria II\save games\madagascar'
time = Time.now

real_demand = Hash.new{|hash, key| hash[key] = Hash.new}
supply = Hash.new{|hash, key| hash[key] = Hash.new}
supply_history = Hash.new{|hash, key| hash[key] = Hash.new}
demand = Hash.new{|hash, key| hash[key] = Hash.new}
prices = Hash.new{|hash, key| hash[key] = Hash.new}
price_history = Hash.new{|hash, key| hash[key] = Hash.new}
actual_sold_world = Hash.new{|hash, key| hash[key] = Hash.new}
actual_sold_country = Hash.new{|hash, key| hash[key] = Hash.new}
price_averages = Hash.new{|hash, key| hash[key] = Hash.new}
base_prices = getBasePrices(game_dir)
puts base_prices

Dir.foreach(save_dir) do |filename|
	
	if filename.to_s.length < 3
		next
	end
	
	savefile = save_dir + "\\" + filename

	
	#getActualSold(savefile,	actual_sold_world, actual_sold_country)
	#getDemand(savefile, real_demand, demand)
	#getPrices(savefile, prices)
	#getPriceHistory(savefile, price_history)
	#getSupplyHistory(savefile, supply_history)
	getPriceAverages(savefile, price_averages)
	#puts "Finished Averages"
end


price_averages_csv = "Outputs\\PriceAverages.csv"
price_avg_out = File.open(price_averages_csv, 'w')

price_averages.each do |date, good_price|
	print_line = 'Date' + ','
	good_price.each do |good, price|
		print_line = print_line + good.to_s + ','
	end
	print_line = print_line + "\n"
	price_avg_out.write(print_line)
	break
end
	

price_averages.each do |date, good_price|
	print_line = date.to_s + ','
	good_price.each do |good, price|
		relative_price = price.to_f / base_prices[good]
		print_line = print_line + relative_price.to_s + ','
	end
	print_line = print_line + "\n"
	price_avg_out.write(print_line)
end


#### Print Price History as CSV
price_csv = "Outputs\\PriceHistory.csv"
price_out = File.open(price_csv, 'w')



price_history.each do |date, good_price|
	print_line = 'Date' + ','
	good_price.each do |good, price|
		print_line = print_line + good.to_s + ','
	end
	print_line = print_line + "\n"
	price_out.write(print_line)
	break
end
	


price_history.each do |date, good_price|
	print_line = date.to_s + ','
	good_price.each do |good, price|
		print_line = print_line + price.to_s + ','
	end
	print_line = print_line + "\n"
	price_out.write(print_line)
end
	
	
### Put Runtime	
runtime = Time.now - time
puts "Runtime was #{runtime} seconds"

