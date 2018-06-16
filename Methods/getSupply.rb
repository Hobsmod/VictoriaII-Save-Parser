def getSupply(savefile, supply)

	supply_io = false

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

	if supply.class == Hash
		File.open(savefile).each do |line|
			if line =~ /supply_pool/
				supply_io = true
			end

			if supply_io == true
				unless line =~ /\}/ or line =~ /\{/ or line =~/supply_pool/
					line.gsub! /\t/,''
					split_line = line.chomp.split('=')
					supply[date][split_line[0]] = split_line[1]
				end
			end

			if line =~ /\}/ && supply_io == true
				supply_io = false
			end
			
			break if line =~ /last_supply_pool/
		end
	end
	
	if supply.class == Array
		File.open(savefile).each do |line|
			if line =~ /supply_pool/
				supply_io = true
			end

			if supply_io == true
				unless line =~ /\}/ or line =~ /\{/ or line =~/supply_pool/
					line.gsub! /\t/,''
					split_line = line.chomp.split('=')
					supply.push([date, split_line[0], split_line[1]])
				end
			end

			if line =~ /\}/ && supply_io == true
				supply_io = false
			end
			
			break if line =~ /last_supply_pool/
		end
	end

end



def getSupplyHistory(savefile, supply_pool)

	
	## Establish the date
	date = 0
	supply_date = 0
	year = 0
	supply_pool_io = false
	File.open(savefile).each do |line|
		if line =~ /date/
			line.gsub! /\n/, ''
			split_line = line.split('=')
			date = split_line[1].gsub!(/\A"|"\Z/, '')
			date_splits = split_line[1].split('.')
			year = date_splits[0].to_i
			supply_date = Date.new(2000,date_splits[1].to_i,date_splits[2].to_i)
		end
			
		break unless date == 0
	end


	if supply_pool.class == Hash
		File.open(savefile).each do |line|

			if line =~ /last_supply_pool/
				year = year - 1
			end
			
			#### Get the Last supply pool
			if line =~ /supply_pool/ or line =~ /supply_pool/
				unless line =~ /update/
					supply_pool_io = true
					next
				end
			end
			
			
			
			if line =~ /\}/ && supply_pool_io == true
				supply_pool_io = false
				supply_date = supply_date - 1
				next
			end
			
			if supply_pool_io == true
				unless line =~ /\}/ or line =~ /\{/ or line =~ /last_supply_pool/
					line.gsub! /\t/,''
					split_line = line.chomp.split('=')
					hist_date = year.to_s + '-' + supply_date.mon.to_s + '-' + supply_date.mday.to_s
					supply_pool[hist_date][split_line[0]] = split_line[1]
				end
			end
			

			
			break if line =~ /supply_change/
		end
	end
	
	
	if supply_pool.class == Array
		File.open(savefile).each do |line|


			#### Get the Last supply pool
			if line =~ /supply_pool/ or line =~ /supply_pool/
				unless line =~ /update/
					supply_pool_io = true
					next
				end
			end
			
			if line =~ /\}/ && supply_pool_io == true
				supply_pool_io = false
				supply_date = supply_date - 1
				next
			end
			
			if supply_pool_io == true
				unless line =~ /\}/ or line =~ /\{/ or line =~ /last_supply_pool/
					line.gsub! /\t/,''
					split_line = line.chomp.split('=')
					hist_date = year.to_s + '-' + supply_date.mon.to_s + '-' + supply_date.mday.to_s
					supply_pool.push([hist_date, split_line[0], split_line[1]])
				end
			end
			

			
			break if line =~ /supply_change/
		end
	end
	
	
	

end