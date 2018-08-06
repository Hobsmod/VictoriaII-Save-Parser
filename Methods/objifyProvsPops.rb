def objifyProvsPops(savegame)
	require_relative '..\Classes\Province.rb'
	require_relative '..\Classes\RGO.rb'
	require_relative '..\Classes\Pop.rb'
	require 'fileutils'
	require 'yaml'
	
	#### list of poptypes for string matching to tell when we are in a pop block
	poptypes = ['farmers','aristocrats','artisans','bureaucrats',
	'soldiers', 'capitalists', 'clergymen', 'clerks', 'craftsmen',
	'labourers','officers','slaves','soldiers']
	
	
	### Province Variables
	prov_hash = Hash.new
	prov_id = nil
	this_prov = nil
	fired_events_opened = 0
	fired_events_closed = 0
	depth = 0
	what_bloc = nil
	rgo = false
	railroad = false
	fort = false
	pop = false 
	party_loyalty = false
	current_ideology = nil
	#### RGO Employee Variables
	rgo_emp_index = nil
	rgo_emp_type = nil
	this_rgo = nil
	prod_type_array = nil
	rgo_array = Array.new
	#### Pop Variables
	pop_type = nil
	what_sub_bloc = nil
	pop_hash = Hash.new
	this_pop = nil
	this_art_prod = nil
	
	
	
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
		
		
		### We have to check that fired events opened, and then closed, before we 
		### knows it's time to start looking for pop data/
		unless fired_events_closed == 1
			if fired_events_opened == 1 && depth == 0
				fired_events_closed = 1
			end
		end
		
		
		
		
		#### This is just to make sure that when we get to the end we add the last province,
		#### since previously we were using starting a new province as the trigger for adding
		#### the last province to the hash
		if line =~ /tax_base/
			prov_hash[prov_id] = this_prov
			this_rgo.calcTotalEmp()
			rgo_array.push(this_rgo)
			unless this_art_prod == nil
				this_pop.artisan_production = this_art_prod
			end
			pop_hash[this_pop.id] = this_pop
			break
		end
		
		
		## We keep track of how many parens 'deep' we are with the depth variable
		if line =~ /\{/
			depth = depth + 1
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
		

		######################################################
		############ Check Depth 1 Variables #################
		######################################################
		
		if depth == 1 
			
			##### Check for the things that open sub blocks
			##### if we know for sure that PDX does not put any parens
			##### on the same line as these strings we can go 'next'
			##### to save time
			if line =~ /rgo\=/
				what_bloc = 'rgo'
				unless this_rgo == nil
					this_rgo.calcTotalEmp
					rgo_array.push(this_rgo)
				end
				this_rgo = RGO.new
				this_rgo.prov_id = this_prov.id
				this_rgo.prov_name = this_prov.name
				this_rgo.owner = this_prov.owner
				next
			end
		
			if line =~ /railroad\=/
				what_bloc = 'railroad'
				next
			end
		
		
			if line =~ /fort\=/
				what_bloc = 'fort'
				next
			end
		
			if line =~ /party_loyalty\=/
				what_bloc = 'party_loyalty'
				next
			end
		
			if line =~ /[a-zA-Z]{1,}\=\n/
				poptypes.each do |type|
					if line =~ /\A\t#{type}\=/
						what_bloc = 'pop'
						pop_type = type
						unless pop_type == 'artisans'
							this_art_prod = nil
						end
						next
					end
				end
			end
		
		
			###########################################
			#### Get Prov Data stored at depth 1 ######
			###########################################
		
			if line =~ /name\=/
				this_prov.name = line.split('=')[1].gsub!(/\A"|"\Z/, '').strip
				next
			end
			
			if line =~ /owner\=/
				this_prov.owner = line.split('=')[1].gsub!(/\A"|"\Z/, '').strip
				next
			end
			
			if line =~ /core\=/
				core_owner = line.split('=')[1].gsub!(/\A"|"\Z/, '').strip
				this_prov.cores.push(core_owner)
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
		
		
		
####################################################################################################
##################### Pop Parsing ############################ Pop Parsing #########################
####################################################################################################
		
		
		##### Pop Infortmation at Depth 2
		if depth == 2 && what_bloc == 'pop'
			if line =~ /\t\tid\=\d{1,}\n/
				### Unless this is the first pop, we push the old pop into the 
				### Pop array and create a new one on encountering ID
				unless this_pop == nil
					unless this_art_prod == nil
						this_pop.artisan_production = this_art_prod
					end
					pop_hash[this_pop.id] = this_pop
				end
				### Create new pop object
				pop_id = line.split('=')[1].to_i
				this_pop = Pop.new(pop_id)
				this_pop.type = pop_type
				this_pop.prov_id = prov_id
				this_pop.owner = this_prov.owner
				this_pop.date = date
				
				#### Addd this pops id to the province ID array
				this_prov.pop_ids.push(pop_id)
				
				
				this_art_prod = nil
			end
		
			### Add various named attributes
			if line =~ /size=\d{1,}/
				this_pop.size = line.split('=')[1].to_i
				next
			end
		
			if line =~ /money=\d{1,}/
				this_pop.money = line.split('=')[1].to_f / 1000
				next
			end
			
			if line =~ /con=\d{1,}/
				this_pop.con = line.split('=')[1].to_f.round(3)
				next
			end
			
			if line =~ /literacy=\d{1,}/
				this_pop.lit = line.split('=')[1].to_f.round(3)
				next
			end
			
			if line =~ /bank=\d{1,}/
				this_pop.bank = line.split('=')[1].to_f.round(3) / 1000
				next
			end
			
			if line =~ /con_factor=\d{1,}/
				this_pop.con_factor = line.split('=')[1].to_f.round(3)
				next
			end
			
			if line =~ /everyday_needs=\d{1,}/
				this_pop.every_needs = line.split('=')[1].to_f.round(3)
				next
			end
			
			if line =~ /luxury_needs=\d{1,}/
				this_pop.lux_needs = line.split('=')[1].to_f.round(3)
				next
			end
			if line =~ /life_needs=\d{1,}/
				this_pop.life_needs = line.split('=')[1].to_f.round(3)
				next
			end
			if line =~ /promoted=\d{1,}/
				this_pop.promoted = line.split('=')[1].to_f.round(3)
				next
			end
			if line =~ /demoted=\d{1,}/
				this_pop.demoted = line.split('=')[1].to_f.round(3)
				next
			end
			
			if line =~ /converted=\d{1,}/
				this_pop.converted = line.split('=')[1].to_f.round(3)
				next
			end
			
			if line =~ /days\_of\_loss=\d{1,}/
				this_pop.days_of_loss = line.split('=')[1].to_f.round(3)
				next
			end
			
			#### IF we have word=word then we assume this is culture & religion
			if line =~ /[a-zA-Z]{1,}\=[a-zA-Z]{1,}\n/
				line.gsub! /\t/, ''
				line.gsub! /\n/, ''
				line.gsub! /' '/, ''
				split_line = line.split('=')
				this_pop.religion = split_line[1]			
				this_pop.culture = split_line[0]
				next
			end
			
			### we set this if we enter into any additional weird blocks
			if line =~ /ideology=/
				what_sub_bloc = 'ideology'
				next
			end
			if line =~ /issues=/
				what_sub_bloc = 'issues'
				next
			end
			
			
			###########################################
			####### Artisan Production Parsing ########
			###########################################
			
			if pop_type == 'artisans'
				if line =~ /production_type/
					prod_type = line.split('=')[1].gsub!(/\A"|"\Z/, '').strip
					this_art_prod = ArtisanProduction.new(prod_type)
				end
				
				###### Set flags for artisan sub blocks ####
				if line =~ /stockpile=/
					what_sub_bloc = 'stockpile'
					next
				end
				if line =~ /need=/
					what_sub_bloc = 'need'
					next
				end
				unless this_art_prod == nil
					#### Weird factors that only apply to artisans
					if line =~ /last_spending=\d{1,}/
						this_art_prod.last_spending = line.split('=')[1].to_f.round(3)
						next
					end
					
					if line =~ /current_producing=\d{1,}/
						this_art_prod.current_producing = line.split('=')[1].to_f.round(3)
						next
					end
				
					if line =~ /percent_afforded=\d{1,}/
						this_art_prod.percent_afforded = line.split('=')[1].to_f.round(3)
						next
					end
					
					if line =~ /percent_sold_domestic=\d{1,}/
						this_art_prod.percent_sold_domestic = line.split('=')[1].to_f.round(3)
						next
					end
					
					if line =~ /percent_sold_export=\d{1,}/
						this_art_prod.percent_sold_export = line.split('=')[1].to_f.round(3)
						next
					end
				
					if line =~ /leftover=\d{1,}/
						this_art_prod.leftover = line.split('=')[1].to_f.round(3)
						next
					end
				
					if line =~ /throttle=\d{1,}/
						this_art_prod.throttle = line.split('=')[1].to_f.round(3)
						next
					end
					
					if line =~ /needs_cost=\d{1,}/
						this_art_prod.needs_cost = line.split('=')[1].to_f.round(3)
						next
					end
					
					
					if line =~ /production_income=\d{1,}/
						this_art_prod.production_income = line.split('=')[1].to_f.round(3)
						next
					end
				end
			end
			
		end
		
		#### When depth  is 3 we start looking at ideology and issues,
		if depth == 3
			if line =~ /\d{1,2}\=\d{1,}/
				split_line = line.split('=')
				if what_sub_bloc == 'ideology'
					this_pop.ideology[split_line[0].to_i] = split_line[1].to_f.round(1)
					next
				end
				if what_sub_bloc == 'issues'
					this_pop.issues[split_line[0].to_i] = split_line[1].to_f.round(1)
					next
				end
			end
		end
		
		

		
################################################################		
####### Return to parsing province data at level 2 #############
################################################################
	
		
		### look in the first level of the RGO block
		if depth == 2 && what_bloc == 'rgo'
			if line =~ /goods\_type\=/
				type = line.split('=')[1].gsub!(/\A"|"\Z/, '').strip
				this_prov.rgo_type = type
				this_pop.rgo_type = type
				this_rgo.type = type
				next
			end
			
			if line =~ /last_income\=/
				last_income = line.split('=')[1]
				this_prov.rgo_income = last_income.to_f / 1000
				unless this_rgo == nil
					this_rgo.income = last_income.to_f / 1000
				end
				next
			end
		end
		
		#### If we are at the right depth and railroad/forts are active, check for 
		#### railroads or forts
		if what_bloc == 'railroad' && depth == 2
			if line =~ /\d\.\d\d\d\s\d\.\d\d\d/
				railroad_split = line.split(' ')
				this_prov.railroad = [railroad_split[0].to_i, railroad_split[1].to_i]
			end
		end
		
		if depth == 2 && what_bloc == 'fort'
			if line =~ /\d\.\d\d\d\s\d\.\d\d\d/
				fort_split = line.split(' ')
				this_prov.fort = [fort_split[0].to_i, fort_split[1].to_i]
			end
		end
		

		
		if what_bloc == 'party_loyalty' && depth == 2
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
		if depth == 6 && what_bloc == 'rgo'
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
		if depth == 5 && what_bloc == 'rgo'	
			if line =~ /count\=/
				count = line.split('=')[1].to_i
				this_prov.employees[rgo_emp_index]["type"] = rgo_emp_type
				this_prov.employees[rgo_emp_index]["count"] = count
				unless this_rgo == nil
					this_rgo.employees[rgo_emp_index]["type"] = rgo_emp_type
					this_rgo.employees[rgo_emp_index]["count"] = count
				end
			end
		end
		
		
		#### We have to count close parens at the end cause Paradox 
		#### didn't put all their close parens on their own lines
		#### Also whenever we encounter close parens we check if we
		#### should close our conditionals for various block types
		if line =~ /\}/
			depth = depth - 1
			
			if depth == 1
				what_bloc = nil
				pop_type = nil
			end

			if depth == 2
				what_sub_bloc = nil
			end
			
			if depth < 0 
				abort "Block depth is less than 0, something went wrong with counting parens"
			end
			
		end
		
		
	end
	
	
	return prov_hash, pop_hash
end