def objifyMarketData(save_game)

	require 'fileutils'
	require 'yaml'
	require_relative '..\Classes\GlobalMarketData.rb'
	
	### This method take a save game file and puts all the price and 
	### Market data at the top of it into a GlobalMarketData object
	### which it then returns for printing to whichever method called it. 
	

	
	## Go into the save_game and grab the in-game date it was saved on, which we need 
	## to attach the actual day to price_history. I am assuming price history is printed
	## sequentially in the save files. 
	date = 0
	price_date = 0
	year = 0
	price_history_io = false
	puts save_game
	File.open(save_game).each do |line|
		if line =~ /date/
			line.gsub! /\n/, ''
			split_line = line.split('=')
			date = split_line[1].gsub!(/\A"|"\Z/, '')
			date_splits = split_line[1].split('.')
			year = date_splits[0].to_i
			price_date = Date.new(2000,date_splits[1].to_i,date_splits[2].to_i)
		end
			
		break unless date == 0
		
		
		
	end
	
	market_data = GlobalMarketData.new(date)

	### We use a combination of how deep we are in the parens block, and a tag
	### telling us what block we are in to put the data in the corresponding
	### Hash. 
	
	
	what_bloc = nil
	depth = 0 
	
	File.open(save_game).each do |line|
		## We keep track of how many parens 'deep' we are with the depth variable
		
		if line =~ /\{/
			depth = depth + 1
		end
		if line =~ /\}/
			depth = depth - 1
			if depth < 0 
				abort "Block depth is less than 0, something went wrong with counting parens"
			end
		end
		
		### Everytime we encounter the correct string we set the bloc type
		if line =~ /worldmarket_pool/
			what_bloc = 'worldmarket_pool'
		end
		
		
		if line =~ /price_pool/
			what_bloc = 'price_history'
			next
		end
		
		if line =~ /price_change/
			what_bloc = 'price_change'
		end
		
		#### The date gem has trouble with years in the 1800s which is why year & price-date
		#### are seperate variables. If date is january 1 then when we subtract 
		#### we also subtract from year
		if line =~ /price_history/
			unless line =~ /update/
				what_bloc = 'price_history'
				if price_date == Date.new(2000,1,1)
					year = year - 1
				end
				price_date = price_date - 1
				next
			end
		end

		if line =~ /supply_pool/
			what_bloc = 'supply'
			next
		end
		
		if line =~ /discovered_goods/
			what_bloc = 'discovered'
			next
		end
		
		if line =~ /actual_sold\=/
			what_bloc = 'actual_sold'
			next
		end		
		
		if line =~ /actual_sold_world=/
			what_bloc = 'actual_sold_world'
			next
		end
			
		if line =~ /real_demand/
			what_bloc = 'real_demand'
			next
		end

		if line =~ /demand/ 
			unless line =~ /real_demand/
				what_bloc = 'demand'
				next
			end
		end
		
		#### Stop when we encounter this line/ 
		if line =~ /player_balance/
			break
		end
			
		#### Here is where we put the data into the relavent structure
		#### For any line where we are two parens deep, and it is formatted line word=nn.nnn
		if depth == 2 && line =~ /[a-zA-Z]{1,}\=\d{1,}/
			### remove extra tabs & split on the = 
			line.gsub! /\t/,''
			split_line = line.chomp.split('=')
			if what_bloc == 'supply'
				market_data.supply[split_line[0]] = split_line[1].to_f
			end
			if what_bloc == 'worldmarket_pool'
				market_data.worldmarket_supply[split_line[0]] = split_line[1].to_f
			end
			if what_bloc == 'discovered'
				market_data.discovered[split_line[0]] = split_line[1].to_f
			end
			if what_bloc == 'actual_sold'
				market_data.sold[split_line[0]] = split_line[1].to_f
			end
			if what_bloc == 'actual_sold_world'
				market_data.worldmarket_sold[split_line[0]] = split_line[1].to_f
			end
			if what_bloc == 'real_demand'
				market_data.real_demand[split_line[0]] = split_line[1].to_f
			end
			if what_bloc == 'demand'
				market_data.demand[split_line[0]] = split_line[1].to_f
			end
			
			
			
			#### For the price history block 
			if what_bloc == 'price_history'
				hist_date = year.to_s + '-' + price_date.mon.to_s + '-' + price_date.mday.to_s
				market_data.price_history[hist_date][split_line[0]] = split_line[1].to_f
			end
		end
	end	

	
	return market_data
	
end	