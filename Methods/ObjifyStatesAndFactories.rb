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
	emp_prov_id = nil
	emp_index = nil
	emp_type = nil
	emp_count = nil
	
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
	profit_history_entry = false
	
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
		
		
		#### skip everything until we find our first tag 
		#### 3 capital letters followed by an equal sign
		unless found_a_tag == true
			if line =~ /[A-Z]{3}\=/
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
		
		### We have some booleans here to check when we start a bloc of a certain type,
		### they get turned off when we find the close parens at adequate depth
		### I can probably get away with putting next after these but I'm not certain
		### so let's be cautious for now. 
		
		if depth == 1 && line =~ /state\=/
			state = true
		end
		
		if depth == 2 && line =~ /id\=/ && state == true
			id_bloc = true
		end
		
		if depth == 2 && state == true && line =~ /provinces\=/
			provinces_bloc = true
		end
		
		if depth == 2 && state == true && line =~ /popproject\=/
			pop_project = true
		end
		
		if depth == 2 && state == true && line =~ /state_buildings\=/
			state_buildings = true
		end
		
		if depth == 3 && state_buildings == true && line =~ /employment\=/
			employment = true
		end
		
		if depth == 3 && state_buildings == true && line =~ /profit_history_entry\=/
			profit_history_entry = true
		end
		
		if depth == 4 && employment == true && line =~ /employees\=/
			employees = true
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
				unless this_factory.nil? or this_state.nil?
					## For some reason I am getting errors where this_state is defined
					## but this_state.buildings is nil even though creating it is supposed
					## to be part of initialization for state objects, so I'm not sure what the 
					## problem is and I'm redundantly creating the array here. I'll have to check
					## later why this is happening and if it causes problems
					## Did you check? -- Not Yet
					if this_state.buildings.nil?
						this_state.buildings = Array.new
					end
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
			
			if line =~ /\tmoney\=/ && depth == 3
				this_factory.money = line.strip.split('=')[1].to_f / 1000
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
			
			if line =~ /subsidised\=yes/ && depth == 3
				this_factory.subsidised = true
			end
			
			if stockpile == true && line =~ /[a-zA-Z]*\=\d*/
				split_line = line.strip.split('=')
				this_factory.stockpile[split_line[0]] = split_line[1]
			end
		end
		
		##### Grab employee data
		if employment == true && line =~ /state_province_id\=/
			this_factory.employee_prov_id = line.strip.split('=')[1].to_i
			next
		end
		
		if employees == true
			if line =~ /province_id\=/
				emp_prov_id = line.strip.split('=')[1].to_i
				next
			end
			if line =~ /index\=/
				emp_index = line.strip.split('=')[1].to_i
				next
			end
			if line =~ /type\=/
				emp_type = line.strip.split('=')[1].to_i
				next
			end
			if line =~ /count\=/
				emp_count = line.strip.split('=')[1].to_i
				these_employees = Employees.new(emp_prov_id, emp_index)
				these_employees.type = emp_type
				these_employees.count = emp_count
				this_factory.employees.push(these_employees)
			end
		end
		
		#### Grab Profit History
		if profit_history_entry == true && line =~ /\d\.\d{1,}/
			profit_history = line.strip.split(' ')
			profit_history.pop
			profit_history.each do |n|
				n = n.to_f
			end
			this_factory.profit_history_arr = profit_history
		end
		
		
		#### When we get to newspaper stuff it's over
		if line =~ /news_scope/
			break
		end
		
		
		#### Here is where we count close parens and close any 'block type' conditionals
		#### If PDOX had been consistent about giving open and close parens their own 
		#### line we could do this at the start and skip all other checks, but they
		#### only gave 99% of parens their own line grrrrr.....
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
					## For some reason I am getting errors where this_state is defined
					## but this_state.buildings is nil even though creating it is supposed
					## to be part of initialization for state objects, so I'm not sure what the 
					## problem is and I'm redundantly creating the array here. I'll have to check
					## later why this is happening and if it causes problems
					## Did you check? -- Not Yet
					if this_state.buildings.nil?
						this_state.buildings = Array.new
					end
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
				employment = false
				profit_history_entry = false
			end
			if depth == 4
				employees = false
				emp_count = nil
				emp_index = nil
				emp_prov_id = nil
				emp_type = nil
			end
		end
		
		
	end
	
	
	return state_arry
	
end