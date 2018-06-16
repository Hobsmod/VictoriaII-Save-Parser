def objifyStatesAndFactories(savegame)
	require_relative '..\Classes\Country.rb'
	require_relative '..\Classes\State.rb'
	require_relative '..\Classes\Factory.rb'
	require 'fileutils'
	
	
	### Persistent Variables
	factory_arry = Array.new{}
	state_arry = Array.new{}
	date = nil
	this_state = nil
	this_factory = nil
	line_count = 0
	depth = 0
	
	#### Conditionals for block types
	#### We turn these flags on whenever we encounter the correct string at depth 1
	#### Whenever we encounter a close parens at the right depth we turn them off
	#### which is further down where we check for close parens
	#### There might be a more elegant way to do this, if anyone reading this stuff 
	#### Knows a better way let me know
	found_a_tag = false
	owner = nil
	state = false
	id_bloc = false
	provinces_bloc = false
	state_buildings = false
	pop_project = false
	stockpile = false
	employment = false
	employees = false
	
	##### We attach the date to this data in order to use it in larger mixed game sets
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
		
		line_count = line_count + 1
		#### skip everything prior to fired_events, it would be nice to stop checking
		#### this once it is 1 but it can't take too long to check a variable once
		unless found_a_tag == true
			if line =~ /[A-Z]{3}\=/
				this_tag = line.split('=')[0]
				this_country = Country.new(this_tag)
				found_a_tag = true
			end
			if found_a_tag == false
				next
			end
		end
		## We keep track of how many parens 'deep' we are with the depth variable
		if line =~ /\{/
			depth = depth + 1
		end
		
		#### Everytime we encounter a new tag at 0 depth we set that to be the owner for 
		#### tagging countries and states
		if depth == 0 && line =~ /[A-Z]{3}\=/
			owner = line.split('=')[0].strip
		end
		
		if depth == 1 && line =~ /state\=/
			state = true
			next
		end
		
		if depth == 2 && line =~ /id\=/ && state == true
			id_bloc = true
			next
		end
		
		if depth == 2 && state == true && line =~ /provinces\=/
			provinces_bloc = true
			next
		end
		
		if depth == 2 && state == true && line =~ /popproject\=/
			pop_project = true
			next
		end
		
		if depth == 2 && state == true && line =~ /state_buildings\=/
			state_buildings = true
			next
		end
		
		
		##### We create a state everytime we encounter a new state id 
		##### And pass it to the state array, we will need a way to pass the last one
		if id_bloc == true && depth == 3 && line =~ /id\=/
			unless this_state == nil
				state_arry.push(this_state)
			end
			id = line.split('=')[1].to_i
			this_state = State.new(id)
			this_state.year = date
			this_state.owner = owner
			next
		end
			
		if id_bloc == true && depth == 3 && line =~ /type\=/
			type = line.split('=')[1].to_i
			this_state.type = type
			next
		end
		
		if provinces_bloc == true && line =~ /\d{1,}/
			split_line = line.split(' ')
			prov_array = Array.new
			split_line.each do |d|
				prov_array.push(d.to_i)
			end
			prov_array.pop
			this_state.provinces = prov_array
		end
		
		if state == true && line =~ /is_colonial\=/
			this_state.is_colonial = line.split('=')[1].strip
		end
		
		if state == true && line =~ /savings\=/
			this_state.savings = line.split('=')[1].to_f
		end
		
		if state == true && line =~ /interest\=/
			this_state.interest = line.split('=')[1].to_f
		end
		
		if state == true && line =~ /is_slave\=/
			this_state.is_slave = line.strip.split('=')[1].to_s
			if this_state.is_slave =~ /yes/
				this_state.is_slave = true
			else
				this_state.is_slave = false
			end
		end
		
		##### Create State Building Object
		if state_buildings == true 
			if line =~ /building\=/
					### Push the last building we did into the state
					### We also do this when we close the state block
				unless this_factory == nil
					this_state.buildings.push(this_factory)
				end
				type = line.split('=')[1].gsub(/\A"+(.*?)"+\Z/m, '\1').strip
				this_factory = Factory.new(type)
			end
			if line =~ /level\=/
				level = line.split('=')[1].to_i
				this_factory.level = level
			end
			
			if line =~ /stockpile\=/ 
				stockpile = true
				next
			end
			
			if line =~ /money\=/ && depth == 3
				this_factory.money = line.strip.split('=')[1].to_f
			end
			
			if line =~ /last_spending\=/ && depth == 3
				this_factory.last_spending = line.strip.split('=')[1].to_f
			end
			
			if line =~ /last_income\=/ && depth == 3
				this_factory.last_income = line.strip.split('=')[1].to_f
			end
			
			if line =~ /pops_paychecks\=/ && depth == 3
				this_factory.pops_paychecks = line.strip.split('=')[1].to_f
			end
			
			if line =~ /last_investment\=/ && depth == 3
				this_factory.last_investment = line.strip.split('=')[1].to_f
			end
			
			if line =~ /unprofitable_days\=/ && depth == 3
				this_factory.unprofitable_days = line.strip.split('=')[1].to_f
			end
			
			if line =~ /leftover\=/ && depth == 3
				this_factory.leftover = line.strip.split('=')[1].to_f
			end
			
			if line =~ /injected_money\=/ && depth == 3
				this_factory.injected_money = line.strip.split('=')[1].to_f
			end
			
			if line =~ /injected_days\=/ && depth == 3
				this_factory.injected_days = line.strip.split('=')[1].to_f
			end
			
			if line =~ /produces\=/ && depth == 3
				this_factory.produces = line.strip.split('=')[1].to_f
			end
			
			if line =~ /profit_history_days\=/ && depth == 3
				this_factory.profit_history_days = line.strip.split('=')[1].to_f
			end
			
			if line =~ /profit_history_current\=/ && depth == 3
				this_factory.profit_history_current = line.strip.split('=')[1].to_f
			end
			
			if stockpile == true && line =~ /[a-zA-Z]*\=\d*/
				split_line = line.strip.split('=')
				this_factory.stockpile[split_line[0]] = split_line[1]
			end
		end
		
		
		
		#### Here is where we count close parens and close any 'block type' conditionals
		#### If PDOX had been consistent about giving open and close parens their own 
		#### line we could do this at the start and skip all other checks, but they
		#### only gave 99% of parens their own line grrrrr.....
		if line =~ /news_scope/
			break
		end
		
		if line =~ /\}/
			depth = depth - 1
			if depth < 0 
				abort "Block depth is less than 0, something went wrong with counting parens"
			end
			if depth == 0 
				owner = nil
			end
			#### This is where the state ends so we have to transfer the last building
			#### into the state building array and then push the state building array
			#### into the state object
			if depth == 1
				unless this_factory == nil
					this_state.buildings.push(this_factory)
				end
				this_factory = nil
				state = false
			end
			if depth == 2
				id_bloc = false
				provinces_bloc = false
				pop_project = false
				state_buildings = false
			end
			if depth == 3 
				stockpile = false
			end
		end
		
		
	end
	
	File.write('States.yml', state_arry.to_yaml)
end