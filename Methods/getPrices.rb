require 'descriptive_statistics'
####### Pulls Goods Prices and Price History from Save File
def getPrices(savefile, prices)

	price_io = false

	## Establish the date
	date = 0
	File.open(savefile).each do |line|
		if line =~ /date/
			line.gsub! /\n/, ''
			splitline = line.split('=')
			date = splitline[1].gsub!(/\A"|"\Z/, '')
		end
			
		break unless date == 0
	end

	if prices.class == Hash
		File.open(savefile).each do |line|
			if line =~ /price_pool/
				price_io = true
			end

			if price_io == true
				unless line =~ /\}/ or line =~ /\{/ or line =~/price_pool/
					line.gsub! /\t/,''
					split_line = line.chomp.split('=')
					prices[date][split_line[0]] = split_line[1]
				end
			end

			if line =~ /\}/ && price_io == true
				price_io = false
			end
			
			break if line =~ /price_history/
		end
	end
	
	if prices.class == Array
		File.open(savefile).each do |line|
			if line =~ /price_pool/
				price_io = true
			end

			if price_io == true
				unless line =~ /\}/ or line =~ /\{/ or line =~/price_pool/
					line.gsub! /\t/,''
					split_line = line.chomp.split('=')
					prices.push ([date, split_line[0], split_line[1]])
				end
			end

			if line =~ /\}/ && price_io == true
				price_io = false
			end
			
			break if line =~ /price_history/
		end
	end

end





def getPriceAverages(savefile, price_average)

	
	## Establish the date
	date = 0
	save_prices = Hash.new{|hash, key| hash[key] = Array.new}
	price_average_io = false
	File.open(savefile).each do |line|
		if line =~ /date/
			line.gsub! /\n/, ''
			split_line = line.split('=')
			date = split_line[1].gsub!(/\A"|"\Z/, '')
			date_splits = split_line[1].split('.')
		end
			
		break unless date == 0
	end


	if price_average.class == Hash
		File.open(savefile).each do |line|

			
			#### Get the Last Price History
			if line =~ /price_history/ or line =~ /price_pool/
				unless line =~ /update/
					price_average_io = true
					next
				end
			end
			
			if line =~ /\}/ && price_average_io == true
				price_average_io = false
				next
			end
			
			if price_average_io == true
				unless line =~ /\}/ or line =~ /\{/
					line.gsub! /\t/,''
					split_line = line.chomp.split('=')
					save_prices[split_line[0]].push(split_line[1])
				end
			end
			

			
			break if line =~ /price_change/
		end
	end
	
	save_prices.each do |key, value|
		stats = DescriptiveStatistics::Stats.new(value)
		price_average[date][key] = stats.mean
	end

	return price_average
end










def getPriceHistory(savefile, price_history)

	
	## Establish the date
	date = 0
	price_date = 0
	year = 0
	price_history_io = false
	File.open(savefile).each do |line|
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


	if price_history.class == Hash
		File.open(savefile).each do |line|

			if line =~ /last_price_history/
				year = year - 1
			end
			
			#### Get the Last Price History
			if line =~ /price_history/ or line =~ /price_pool/
				unless line =~ /update/
					price_history_io = true
					next
				end
			end
			
			
			
			if line =~ /\}/ && price_history_io == true
				price_history_io = false
				price_date = price_date - 1
				next
			end
			
			if price_history_io == true
				unless line =~ /\}/ or line =~ /\{/ or line =~ /last_price_history/
					line.gsub! /\t/,''
					split_line = line.chomp.split('=')
					hist_date = year.to_s + '-' + price_date.mon.to_s + '-' + price_date.mday.to_s
					price_history[hist_date][split_line[0]] = split_line[1]
				end
			end
			

			
			break if line =~ /price_change/
		end
	end
	
	
	if price_history.class == Array
		File.open(savefile).each do |line|


			#### Get the Last Price History
			if line =~ /price_history/ or line =~ /price_pool/
				unless line =~ /update/
					price_history_io = true
					next
				end
			end
			
			if line =~ /\}/ && price_history_io == true
				price_history_io = false
				price_date = price_date - 1
				next
			end
			
			if price_history_io == true
				unless line =~ /\}/ or line =~ /\{/ or line =~ /last_price_history/
					line.gsub! /\t/,''
					split_line = line.chomp.split('=')
					hist_date = year.to_s + '-' + price_date.mon.to_s + '-' + price_date.mday.to_s
					price_history.push([hist_date, split_line[0], split_line[1]])
				end
			end
			

			
			break if line =~ /price_change/
		end
	end
	
	
	

end


