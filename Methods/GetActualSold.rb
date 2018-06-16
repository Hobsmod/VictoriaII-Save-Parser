def getActualSold(savefile, actual_sold_world, actual_sold_country)
	
	###on off switches
	actual_sold_io = false
	actual_sold_world_io = false
	
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
	
	
	### Make the actual sold world hash
	if actual_sold_world.class == Hash
		File.open(savefile).each do |line|
			
			if line =~ /actual_sold_world/
				actual_sold_world_io = true
				next
			end
			
			if actual_sold_world_io == true && line =~ /\}/
				actual_sold_world_io = false
				next
			end
			
			
			if actual_sold_world_io == true
				unless line =~ /actual_sold/ or line =~ /\{/
					line.gsub! /\t/,''
					split_line = line.chomp.split('=')
					actual_sold_world[date][split_line[0]] = split_line[1]
				end
			end
			
			break if line =~ /real_demand/
		end
	end
	
	if actual_sold_world.class == Array
		File.open(savefile).each do |line|
			
			if line =~ /actual_sold_world/
				actual_sold_world_io = true
				next
			end
			
			if actual_sold_world_io == true && line =~ /\}/
				actual_sold_world_io = false
				next
			end
			
			
			if actual_sold_world_io == true
				unless line =~ /actual_sold/ or line =~ /\{/
					line.gsub! /\t/,''
					split_line = line.chomp.split('=')
					actual_sold_world.push([date, split_line[0], split_line[1]])
				end
			end
			
			break if line =~ /real_demand/
		end
	end
	
	
	
	
	unless actual_sold_country == nil
		if actual_sold_country.class == Hash
			File.open(savefile).each do |line|
				if line =~ /actual_sold/
					unless line =~ /actual_sold_world/
						actual_sold_io = true
						next
					end
				end
				
				
				if actual_sold_io == true && line =~ /\}/
					actual_sold_io = false
					next
				end
				
				
				if actual_sold_io == true
					unless line =~ /actual_sold/ or line =~ /\{/
						line.gsub! /\t/,''
						split_line = line.chomp.split('=')
						actual_sold_country[date][split_line[0]] = split_line[1]
					end
				end
				
				
				break if line =~ /real_demand/
			end
		end
		
		
		if actual_sold_country.class == Array
			File.open(savefile).each do |line|
				if line =~ /actual_sold/
					unless line =~ /actual_sold_world/
						actual_sold_io = true
						next
					end
				end
				
				
				if actual_sold_io == true && line =~ /\}/
					actual_sold_io = false
					next
				end
				
				
				if actual_sold_io == true
					unless line =~ /actual_sold/ or line =~ /\{/
						line.gsub! /\t/,''
						split_line = line.chomp.split('=')
						actual_sold_country.push([date, split_line[0], split_line[1]])
					end
				end
				
				
				break if line =~ /real_demand/
			end
		end
	end
			
end