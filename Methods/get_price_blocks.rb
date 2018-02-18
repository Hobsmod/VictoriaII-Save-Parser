require 'Date'
require 'csv'

savefile = 'C:\Users\sdras\OneDrive\Documents\Paradox Interactive\Victoria II\HFM_LMM\save games\The_United States of America1845_08_01.v2'

def getSold(savefile)
actual_sold_io = false
actual_sold_world_io = false
actual_sold = Hash.new{}
actual_sold_world = Hash.new{}

	File.open(savefile).each do |line|
		if line =~ /actual_sold/
			unless line =~ /actual_sold_world/
				actual_sold_io = true
			end
		end
		
		if line =~ /actual_sold_world/
			actual_sold_world_io = true
		end
		
		if actual_sold_io == true && line =~ /\}/
			actual_sold_io = false
		end
		
		if actual_sold_world_io == true && line =~ /\}/
			actual_sold_world_io = false
		end
		
		if actual_sold_io == true
			unless line =~ /actual_sold/ or line =~ /\{/
				line.gsub! /\t/,''
				split_line = line.chomp.split('=')
				actual_sold[split_line[0]] = split_line[1]
			end
		end
		
		if actual_sold_world_io == true
			unless line =~ /actual_sold/ or line =~ /\{/
				line.gsub! /\t/,''
				split_line = line.chomp.split('=')
				actual_sold_world[split_line[0]] = split_line[1]
			end
		end
		
		break if line =~ /real_demand/
	end
	
	return actual_sold, actual_sold_world
end


def getDemand(savefile)
real_demand_io = false
demand_io = false
demand = Hash.new{}
real_demand = Hash.new{}

	File.open(savefile).each do |line|
		if line =~ /demand/
			unless line =~ /real_demand/
				demand_io = true
			end
		end
		
		if line =~ /real_demand/
			real_demand_io = true
		end
		
		if demand_io == true && line =~ /\}/
			demand_io = false
		end
		
		if real_demand_io == true && line =~ /\}/
			real_demand_io = false
		end
		
		if demand_io == true
			unless line =~ /demand/ or line =~ /\{/
				line.gsub! /\'/,''
				split_line = line.chomp.split('=')
				demand[split_line[0]] = split_line[1]
			end
		end
		
		if real_demand_io == true
			unless line =~ /demand/ or line =~ /\{/
				line.gsub! /\t/,''
				split_line = line.chomp.split('=')
				real_demand[split_line[0]] = split_line[1]
			end
		end
		
		break if line =~ /player_balance/
	end
	
	File.close(savefile)
	return demand, real_demand
end



def getWorldMarket (savefile)

date = 0
year = 0
worldmarket_pool_io = false
worldmarket_pool = Hash.new{|hash, key| hash[key] = Hash.new}
worldmarket_pool_array = Array.new{}


	File.open(savefile).each do |line|
		#### Get the Worldmarket pool
		if line =~ /\Adate/
			line.gsub! /\t/,''
			split_line = line.chomp.split('=')
			date_splits = split_line[1].split('.')
			year = date_splits[0]
			date = Date.new(2000,date_splits[1].to_i,date_splits[2].to_i)
		end
		
		if line =~ /worldmarket_pool/
			worldmarket_pool_io = true
		end
		
		if worldmarket_pool_io == true
			unless line =~ /\}/ or line =~ /\{/ or line =~ /worldmarket_pool/
				line.gsub! /\t/,''
				split_line = line.chomp.split('=')
				hist_date = year.to_s + '-' + date.mon.to_s + '-' + date.mday.to_s
				worldmarket_pool[hist_date][split_line[0]] = split_line[1]
				worldmarket_pool_array.push([hist_date, split_line[0], split_line[1]])
			end
		end
		
		
		if line =~ /\}/ && worldmarket_pool_io == true
			worldmarket_pool_io = false
		end
		
		
		break if line =~ /price_change/
	end
	
	
	
	return worldmarket_pool_array
end


def getCurrentPrices(savefile)
current_prices = Hash.new
price_history_io = false


	File.open(savefile).each do |line|
		if line =~ /price_pool/
			price_history_io = true
		end

		if price_history_io == true
			unless line =~ /\}/ or line =~ /\{/ or line =~/price_pool/
				line.gsub! /\t/,''
				split_line = line.chomp.split('=')
				current_prices[split_line[0]] = split_line[1]
			end
		end

		if line =~ /\}/ && price_history_io == true
			price_history_io = false
		end
		
		break if line =~ /price_history/
	end
	
	return current_prices

end





def getSupplyPool (savefile)

date = 0
year = 0
supply_date = 0

supply_pool_io = false
supply_pool = Hash.new{|hash, key| hash[key] = Hash.new}
supply_pool_array = Array.new{}
supply_pool_increment = 0


	File.open(savefile).each do |line|
		
		if line =~ /\Adate/
			line.gsub! /\t/,''
			split_line = line.chomp.split('=')
			date_splits = split_line[1].split('.')
			supply_date = Date.new(2000,date_splits[1].to_i,date_splits[2].to_i)
			year = date_splits[0]
			date = Date.new(2000,date_splits[1].to_i,date_splits[2].to_i)
		end
		
		if line =~ /supply_pool/
			supply_pool_io = true
		end
		
		if supply_pool_io == true
			unless line =~ /\}/ or line =~ /\{/ or line =~ /supply_pool/
				line.gsub! /\t/,''
				split_line = line.chomp.split('=')
				hist_date = year.to_s + '-' + supply_date.mon.to_s + '-' + supply_date.mday.to_s
				supply_pool[hist_date][split_line[0]] = split_line[1]
				supply_pool_array.push([hist_date, split_line[0], split_line[1]])
			end
		end
		
		if line =~ /\}/ && supply_pool_io == true
			supply_pool_io = false
			supply_date = supply_date - 1
		end
		
		break if line =~ /price_change/
	end
	
	return supply_pool_array
end

def getPriceHistory(savefile)

year = 0
date = 0
price_date = 0
price_history_increment = 0
price_history = Hash.new{|hash, key| hash[key] = Hash.new}
price_history_array = Array.new{}
price_history_io = false


	File.open(savefile).each do |line|

		if line =~ /\Adate/
				line.gsub! /\t/,''
				split_line = line.chomp.split('=')
				date_splits = split_line[1].split('.')
				price_date = Date.new(2000,date_splits[1].to_i,date_splits[2].to_i)
				year = date_splits[0]
				date = Date.new(2000,date_splits[1].to_i,date_splits[2].to_i)
		end

		#### Get the Last Price History
		if line =~ /price_history/ or line =~ /price_pool/
			unless line =~ /update/
				price_history_io = true
			end
		end
		
		if price_history_io == true
			unless line =~ /\}/ or line =~ /\{/ or line =~ /last_price_history/
				line.gsub! /\t/,''
				split_line = line.chomp.split('=')
				hist_date = year.to_s + '-' + price_date.mon.to_s + '-' + price_date.mday.to_s
				hist_date.gsub! /\"/,''
				price_history[hist_date][split_line[0]] = split_line[1]
				price_history_array.push([hist_date, split_line[0], split_line[1]])
			end
		end
		
		if line =~ /\}/ && price_history_io == true
			price_history_io = false
			price_date = price_date - 1
		end
		
		break if line =~ /price_change/
	end
	
	return price_history_array
end



