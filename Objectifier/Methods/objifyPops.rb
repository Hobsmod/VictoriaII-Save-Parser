def objifyPops(savegame)
	require_relative '..\Classes\Pop.rb'
	require 'fileutils'
	### This method takes a savegame and creates a hash and an array of pop objects
	
	#### list of poptypes
	poptypes = ['farmers','aristocrats','artisans','bureaucrats',
	'soldiers', 'capitalists', 'clergymen', 'clerks', 'craftsmen',
	'labourers','officers','slaves','soldiers']

	pop_array = Array.new
	pop_hash = Hash.new
	### We track how many parens deep we are, what the current province is, and 
	### what the current poptype is. We also track whether we are in some of the
	### more detailed pop sub-blocks (ideology, issue, stockpile, etc)
	what_bloc = nil
	depth = 0
	fired_events_opened = 0
	fired_events_closed = 0
	prov_id = nil
	pop_type = nil
	this_pop = nil
	line_count = 0



	#### We need to get the date to attach it to pops in order to use it as a
	#### part of a larger data set
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
		## We keep track of how many parens 'deep' we are with the depth variable
		
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
		#### We add pops to the array when we're done because otherwise we would leave
		#### out the last pop. 
		if line =~ /tax_base/
			pop_array.push(this_pop)
			break
		end
		
		
		#### Count the line for depth
		if line =~ /\{/
			depth = depth + 1
			next
		end
		if line =~ /\}/
			depth = depth - 1
			if depth < 0 
				abort "Block depth is less than 0, something went wrong with counting parens"
			end
			next
		end
		
		### We have to check that fired events opened, and then closed, before we 
		### knows it's time to start looking for pop data/
		unless fired_events_closed == 1
			if fired_events_opened == 1 && depth == 0
				fired_events_closed = 1
			end
			next
		end
		
		
		
		
		#### If the line is just n= then thats a prov id
		if depth == 0 && line =~ /\d{1,}\=\n/
			prov_id = line.chomp('=').to_i
		end

		### Assign pop type
		if depth == 1 && line =~ /[a-zA-Z]{1,}\=\n/
			poptypes.each do |type|
				if line =~ /\A\t#{type}\=/
					pop_type = type
				end
			end
		end
		
		if depth == 2
			if line =~ /\t\tid\=\d{1,}\n/
				### Unless this is the first pop, we push the old pop into the 
				### Pop array and create a new one on encountering ID
				unless this_pop == nil
					pop_array.push(this_pop)
				end
				pop_id = line.split('=')[1].to_i
				this_pop = Pop.new(pop_id)
				this_pop.type = pop_type
				this_pop.prov_id = prov_id
				this_pop.date = date
			end
		
			### Add various named attributes
			if line =~ /size=\d{1,}/
				this_pop.size = line.split('=')[1].to_i
				next
			end
		
			if line =~ /money=\d{1,}/
				this_pop.money = line.split('=')[1].to_f.round(3)
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
				this_pop.bank = line.split('=')[1].to_f.round(3)
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
			
			#### Weird factors that only apply to artisans
			if line =~ /last_spending=\d{1,}/
				this_pop.last_spending = line.split('=')[1].to_f.round(3)
				next
			end
			
			if line =~ /current_producing=\d{1,}/
				this_pop.current_producing = line.split('=')[1].to_f.round(3)
				next
			end
			
			if line =~ /percent_afforded=\d{1,}/
				this_pop.percent_afforded = line.split('=')[1].to_f.round(3)
				next
			end
			
			if line =~ /percent_sold_domestic=\d{1,}/
				this_pop.percent_sold_domestic = line.split('=')[1].to_f.round(3)
				next
			end
			
			if line =~ /percent_sold_export=\d{1,}/
				this_pop.percent_sold_export = line.split('=')[1].to_f.round(3)
				next
			end
		
			if line =~ /leftover=\d{1,}/
				this_pop.leftover = line.split('=')[1].to_f.round(3)
				next
			end
		
			if line =~ /throttle=\d{1,}/
				this_pop.throttle = line.split('=')[1].to_f.round(3)
				next
			end
			
			if line =~ /needs_cost=\d{1,}/
				this_pop.needs_cost = line.split('=')[1].to_f.round(3)
				next
			end
			
			
			if line =~ /production_income=\d{1,}/
				this_pop.production_income = line.split('=')[1].to_f.round(3)
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
				what_bloc = 'ideology'
			end
			if line =~ /issues=/
				what_bloc = 'issues'
			end
			if line =~ /stockpile=/
				what_bloc = 'stockpile'
			end
			if line =~ /need=/
				what_bloc = 'need'
			end
		end
		
		#### When depth  is 3 we start looking at ideology and issues,
		#### as well as artisan stuff like need, and stockpile
		if depth == 3
			if line =~ /\d{1,2}\=\d{1,}/
				split_line = line.split('=')
				if what_bloc == 'ideology'
					this_pop.ideology[split_line[0].to_i] = split_line[1].to_f.round(1)
					next
				end
				if what_bloc == 'issues'
					this_pop.issues[split_line[0].to_i] = split_line[1].to_f.round(1)
					next
				end
			end
		end
				
	end	


	
		File.write('Pops.yml', pop_array.to_yaml)
		
	
end	