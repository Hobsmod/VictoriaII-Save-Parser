def getDemand(savefile, real_demand, demand)

	###on off switches
	demand_io = false
	real_demand_io = false
	
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
	
	
	### Make the real demand hash
	if real_demand.class == Hash
		File.open(savefile).each do |line|
			
			if line =~ /real_demand/
				real_demand_io = true
				next
			end
			
			if real_demand_io == true && line =~ /\}/
				real_demand_io = false
				next
			end
			
			
			if real_demand_io == true
				unless line =~ /demand/ or line =~ /\{/
					line.gsub! /\t/,''
					split_line = line.chomp.split('=')
					real_demand[date][split_line[0]] = split_line[1]
				end
			end
			
			break if line =~ /player_balance/
		end
	end
	
	##Make the real demand Array
	if real_demand.class == Array
		File.open(savefile).each do |line|
			
			if line =~ /real_demand/
				real_demand_io = true
				next
			end
			
			if real_demand_io == true && line =~ /\}/
				real_demand_io = false
				next
			end
			
			
			if real_demand_io == true
				unless line =~ /demand/ or line =~ /\{/
					line.gsub! /\t/,''
					split_line = line.chomp.split('=')
					real_demand.push([date, split_line[0], split_line[1]])
				end
			end
			
			break if line =~ /player_balance/
		end
	end
	
	
	
	
	unless demand == nil
		if demand.class == Hash
			File.open(savefile).each do |line|
				if line =~ /demand/
					unless line =~ /real_demand/
						demand_io = true
						next
					end
				end
				
				
				if demand_io == true && line =~ /\}/
					demand_io = false
					next
				end
				
				
				if demand_io == true
					unless line =~ /demand/ or line =~ /\{/
						line.gsub! /\t/,''
						split_line = line.chomp.split('=')
						demand[date][split_line[0]] = split_line[1]
					end
				end
				
				
				break if line =~ /player_balance/
			end
		end
		
		
		if demand.class == Array
			File.open(savefile).each do |line|
				if line =~ /demand/
					unless line =~ /real_demand/
						demand_io = true
						next
					end
				end
				
				
				if demand_io == true && line =~ /\}/
					demand_io = false
					next
				end
				
				
				if demand_io == true
					unless line =~ /demand/ or line =~ /\{/
						line.gsub! /\t/,''
						split_line = line.chomp.split('=')
						demand.push([date, split_line[0], split_line[1]])
					end
				end
				
				
				break if line =~ /player_balance/
			end
		end
	end
end