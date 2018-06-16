def objifyProvinces(savegame)
	require_relative '..\Classes\Province.rb'
	require 'fileutils'
	
	#### list of poptypes for string matching to tell when we are in a pop block
	poptypes = ['farmers','aristocrats','artisans','bureaucrats',
	'soldiers', 'capitalists', 'clergymen', 'clerks', 'craftsmen',
	'labourers','officers','slaves','soldiers']
	
	
	### Persistent Variables
	prov_hash = Hash.new
	prov_id = nil
	this_prov = nil
	fired_events_opened = 0
	fired_events_closed = 0
	depth = 0
	rgo = false
	railroad = false
	fort = false
	pop = false 
	party_loyalty = false
	current_ideology = nil
	#### RGO Employee Variables
	rgo_emp_index = nil
	rgo_emp_type = nil
	
	##### We attach the date to this data in case we ever want to use it in large
	##### mixed game data sets
	date = 0
	File.open(savegame).each do |line|
		if line =~ /date/
			line.gsub! /\n/, ''
			split_line = line.split('=')
			date = split_line[1].gsub!(/\A"|"\Z/, '')
		end
			
		break unless date == 0
	end
	
	
	
	File.open(savegame).each do |line|
		
		
		#### skip everything prior to fired_events, it would be nice to stop checking
		#### this once it is 1 but it can't take too long to check a variable once
		if fired_events_opened == 0 
			if line =~ /fired_events/
				fired_events_opened = 1
				next
			else
				next
			end
		end
		
		
		
		#### If we get any tax_base lines we're into country data and can stop
		if line =~ /tax_base/
			prov_hash[prov_id] = this_prov
			break
		end
		
		
		## We keep track of how many parens 'deep' we are with the depth variable
		if line =~ /\{/
			depth = depth + 1
		end

		###### Check if we are in an rgo={ block
		if depth == 1 && line =~ /rgo\=/
			rgo = true
			next
		end
		
		###### Check if we are in a railroad={ block
		if depth == 1 && line =~ /railroad\=/
			railroad = true
			next
		end
		
		
		###### Check if we are in a railroad={ block
		if depth == 1 && line =~ /fort\=/
			fort = true
			next
		end
		
		#### Check if we are in a party loyalty block
		if depth == 1 && line =~ /party_loyalty\=/
			party_loyalty = true
			next
		end
		
		
		#### Check if we are in a pop block
		if depth == 1 && line =~ /[a-zA-Z]{1,}\=\n/
			poptypes.each do |type|
				if line =~ /\A\t#{type}\=/
					pop = true
					next
				end
			end
		end
		
		
		### We have to check that fired events opened, and then closed, before we 
		### knows it's time to start looking for pop data/
		unless fired_events_closed == 1
			if fired_events_opened == 1 && depth == 0
				fired_events_closed = 1
			end
		end
		
		
		
		
		#### If the line is just n= then thats a prov id
		if depth == 0 && line =~ /\d{1,}\=\n/
			unless this_prov == nil
				prov_hash[prov_id] = this_prov
			end
			prov_id = line.chomp('=').to_i
			this_prov = Province.new(prov_id)
			this_prov.date = date
		end
		
		
		### start checking for province attributes
		if depth == 1
			
			if line =~ /name\=/
				this_prov.name = line.split('=')[1].gsub!(/\A"|"\Z/, '').strip
				next
			end
			
			if line =~ /owner\=/
				this_prov.owner = line.split('=')[1].gsub!(/\A"|"\Z/, '').strip
				next
			end
			
			
			if line =~ /last_imigration\=/
				this_prov.last_imigration = line.split('=')[1].gsub!(/\A"|"\Z/, '').strip
				next
			end
			
			if line =~ /controller\=/
				controller = line.split('=')[1]
				this_prov.controller = controller.gsub!(/\A"|"\Z/, '').strip
				next
			end
			
			if line =~ /garrison\=/
				garrison = line.split('=')[1]
				this_prov.garrison = garrison.to_i
				next
			end
			
			if line =~ /colonial\=/
				colonial = line.split('=')[1]
				this_prov.colonial = colonial.to_i
				next
			end
			
			if line =~ /life_rating\=/
				life_rating = line.split('=')[1]
				this_prov.life_rating = life_rating.to_i
				next
			end
			
			#### Saved as an int, probably need to look at game files to make this a string
			if line =~ /crime\=/
				crime = line.split('=')[1]
				this_prov.crime = crime.to_i
				next
			end
			
			if line =~ /infrastructure\=/
				infra = line.split('=')[1]
				this_prov.infrastructure = infra.to_f
			end
		end
		
		### look in the first level of the RGO block
		if depth == 2 && rgo == true
			if line =~ /goods\_type\=/
				this_prov.rgo_type = line.split('=')[1].gsub!(/\A"|"\Z/, '').strip
				next
			end
			
			if line =~ /last_income\=/
				last_income = line.split('=')[1]
				this_prov.rgo_income = last_income.to_f.round(3)
				next
			end
		end
		
		#### If we are at the right depth and railroad/forts are active, check for 
		#### railroads or forts
		if railroad == true && depth == 2
			if line =~ /\d\.\d\d\d\s\d\.\d\d\d/
				railroad_split = line.split(' ')
				this_prov.railroad = [railroad_split[0].to_i, railroad_split[1].to_i]
			end
		end
		
		if depth == 2 && fort == true
			if line =~ /\d\.\d\d\d\s\d\.\d\d\d/
				fort_split = line.split(' ')
				this_prov.fort = [fort_split[0].to_i, fort_split[1].to_i]
			end
		end
		
		if pop == true && depth == 2
			if line =~ /\t\tid\=\d{1,}\n/
				pop_id = line.split('=')[1].to_i
				this_prov.pop_ids.push(pop_id)
			end
		end
		
		if party_loyalty == true && depth == 2
			if line =~ /ideology\=/
				current_ideology = line.split('="')[1]
				unless current_ideology == nil
					current_ideology = current_ideology.gsub!(/\A"|"\Z/, '').strip
				end
			end
			
			if line =~ /loyalty_value\=/
				this_prov.party_loyalty[current_ideology] = line.split('=')[1].to_f
			end
		end
		
		#### Look way inside the RGO block of the employee index. I'm not sure precisely
		#### what that corresponds to. Might be an internal memory way to distinguish different
		#### pops employed at the same place. 
		if depth == 6 && rgo == 1
			if line =~ /index\=/
				rgo_emp_index = line.split('=')[1].to_i
				next
			end
			if line =~ /type\=/
				rgo_emp_type = line.split('=')[1].to_i
				next
			end
		end
		
		##### Here pop type is saved as a number rather than a string, 
		##### turning it into a string will probably require 
		if depth == 5 && rgo == 1	
			if line =~ /count\=/
				count = line.split('=')[1].to_i
				this_prov.employees[rgo_emp_index]["type"] = rgo_emp_type
				this_prov.employees[rgo_emp_index]["count"] = count
			end
		end
		
		
		#### We have to count close parens at the end cause Paradox 
		#### didn't put all their close parens on their own lines
		#### Also whenever w eencounter close parens we check if we
		#### should close our conditionals for various block types
		if line =~ /\}/
			if pop == 1 && depth == 1
				pop = false
			end
			
			if party_loyalty == 1 && depth == 1
				party_loyalty = false
				current_ideology = nil
			end
			
			if rgo == 1 && depth == 1
				 rgo = false 
			end
			
			if depth == 1 && fort == 1
				fort = false
			end
			
			if railroad == 1 && depth == 1 
				railroad = false
			end
			
			depth = depth - 1
			if depth < 0 
				abort "Block depth is less than 0, something went wrong with counting parens"
			end
			
		end
		
		
	end
	
	File.write('Provinces.yml', prov_hash.to_yaml)
end