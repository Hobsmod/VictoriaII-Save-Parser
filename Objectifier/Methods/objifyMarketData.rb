def objifyMarketData(savegame)
	require 'descriptive_statistics'
	require 'fileutils'
	### This method takes a savegame and creates two data structures
	### The first is a hash of hashes containing the price history of all goods
	### The second is a hash of hashes containing averages for prices, global supply,
	### demand, prices etc.
	### It then prints paths to these files in what I am calling a game index
	
	### Price_history_hash date->good->price
	price_history_hash = Hash.new{|hash, key| hash[key] = Hash.new}
	#### Market Data Hash Type->Good-> Array of Values (averaged at end)
	market_data_hash = Hash.new{|hash, key| hash[key] = Hash.new{|inner_hash, key| inner_hash[key] = Array.new}}
	
	
	
	## Go into the savegame and grab the in-game date it was saved on, which we need 
	## to attach to price histories (usually as a label in the hash) in order to make 
	## price histories that span multiple games
	date = 0
	price_date = 0
	year = 0
	price_history_io = false
	File.open(savegame).each do |line|
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
	
	

	### We use a combination of how deep we are in the parens block, and a tag
	### telling us what block we are in to put the data in the corresponding
	### Hash. 
	
	
	what_bloc = nil
	depth = 0 
	
	File.open(savegame).each do |line|
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
		
		#### The date gem has trouble with years in the 1800s which is why year
		#### is a seperate variable. If date is january 1 then when we subtract 
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
			market_data_hash[what_bloc][split_line[0]].push(split_line[1])
			#### For the price history block 
			if what_bloc == 'price_history'
				hist_date = year.to_s + '-' + price_date.mon.to_s + '-' + price_date.mday.to_s
				price_history_hash[hist_date][split_line[0]] = split_line[1]
			end
		end
	end	

	
	#### At the end we take the values in the hash of hash of arrays and average
	### them and turn them into a new hash which we return
	market_data_hash_avg = Hash.new{|hash, key| hash[key] = Hash.new}
	
	market_data_hash.each do |key, value|
		value.each do |k, v|
			market_data_hash_avg[key][k] = v.mean.to_f	
		end
	end
	
	
	##### Here is the part where we start to output data structures into
	##### Folders wherever the savegame is 
		
		#### Create an Objectified folder wherever the savegame is
		#### which is the top level folder (There is surely a better
		#### way to do this but I suck and this works)
		save_dir = File.dirname(savegame)
		game_name = File.basename(savegame, ".*") + '-Objectified' 
		Dir::chdir(save_dir)
		Dir.mkdir(game_name) unless File.exists?(game_name)
		
		
		#### Move down into the objectified folder and create a 
		#### Market data folder, 
		Dir::chdir(game_name)
		Dir.mkdir('MarketData') unless File.exists?('MarketData')
		Dir::chdir('MarketData')
		File.write('MarketData.yml', market_data_hash_avg.to_yaml)
		File.write('PriceHistory.yml', price_history_hash.to_yaml)
		
	
end	