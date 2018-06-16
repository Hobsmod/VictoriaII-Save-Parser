def objifyCountries(savegame)
	require_relative '..\Classes\Country.rb'
	require 'fileutils'
	
	
	### Persistent Variables
	tag_hash = Hash.new
	found_a_tag = false
	this_tag = nil
	this_country = nil
	depth = 0
	line_count = 0
	relation_tag = nil
	ai_id = nil
	creditor_tag = nil
	
	#### Conditionals for block types
	#### We turn these flags on whenever we encounter the correct string at depth 1
	#### Whenever we encounter a close parens at the right depth we turn them off
	#### which is further down where we check for close parens
	#### There might be a more elegant way to do this, if anyone reading this stuff 
	#### Knows a better way let me know
	flags = false
	variables = false
	tech = false
	research = false
	upper_house = false
	naval_need = false
	land_supply_cost = false
	naval_supply_cost = false
	modifier = false
	modifier_name = nil
	rich_tax = false
	middle_tax = false
	poor_tax = false
	tax_income = false
	tax_eff = false
	education_spending = false
	crime_fighting = false
	social_spending = false
	military_spending = false
	active_inventions = false
	illegal_inventions = false
	ai = false
	ai_hard_strategy = false
	government_flag = false
	conquer_prov = false
	threat = false
	antagonize = false
	befriend = false
	protect = false
	rival = false
	culture = false
	bank = false
	domestic_supply_pool = false
	sold_supply_pool = false
	domestic_demand_pool = false
	actual_sold_domestic = false
	saved_country_supply = false
	max_bought = false
	national_focus = false
	expenses = false
	incomes = false
	interesting_countries = false
	creditor = false
	
	
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
		
		#### Everytime we encounter a new tag at 0 depth we are starting a new country
		#### so we shift the old country into the tag hash and create a new country objifyCountries
		#### with the new tag
		if depth == 0 && line =~ /[A-Z]{3}\=/
			tag_hash[this_tag] = this_country
			this_tag = line.split('=')[0]
			this_country = Country.new(this_tag)
			this_country.date = date
		end
		

		#### Look for variables at depth 1
		
		if depth == 1
			
			
			#### Where we turn on conditionals for block types
			if line =~ /flags\=/
				flags = true
				next
			end
			
			if line =~ /variables\=/
				variables = true
				next
			end
			
			if line =~ /technology\=/
				#puts "tech on"
				tech = true
				next
			end
			
			if line =~ /research\=/
				research = true
				next
			end
			
			if line =~ /upper_house\=/
				upper_house = true
				next
			end
			
			if line =~ /naval_need\=/
				naval_need = true
				next
			end
			
			if line =~ /land_supply_cost\=/
				land_supply_cost = true
				next
			end
			
			if line =~ /naval_supply_cost\=/
				naval_supply_cost = true
				next
			end
			
			if line =~ /modifier\=/
				modifier = true
				next
			end
			
			if line =~ /poor_tax\=/
				poor_tax = true
				next
			end
			
			if line =~ /rich_tax\=/ 
				rich_tax = true
				next
			end
			
			if line =~ /middle_tax\=/
				middle_tax = true
				next
			end
			
			if line =~ /education_spending\=/
				education_spending = true
				next
			end
			
			if line =~/crime_fighting\=/
				crime_fighting = true
				next
			end
			
			if line =~ /social_spending\=/
				social_spending = true
				next
			end
			
			if line =~ /military_spending\=/
				military_spending = true
				next
			end
			
			if line =~ /illegal_inventions\=/
				illegal_inventions = true
				next
			end
			
			if line =~ /active_inventions\=/
				active_inventions = true
				next
			end
			
			if line =~ /ai_hard_strategy\=/
				ai_hard_strategy = true
				next
			end
			
			if line =~ /ai\=/
				ai = true
				next
			end
			
			if line =~ /\sculture\=\n/
				culture = true
				next
			end
			
			if line =~ /bank\=/
				bank = true
				next
			end
			
			if line =~ /creditor\=/
				creditor = true
				next
			end
			
			if line =~ /domestic_supply_pool\=/
				domestic_supply_pool = true
				next
			end
			
			if line =~ /domestic_demand_pool\=/
				domestic_demand_pool = true
				next
			end
			
			if line =~ /sold_supply_pool\=/
				sold_supply_pool = true
				next
			end
			
			if line =~ /actual_sold_domestic\=/
				actual_sold_domestic = true
				next
			end
			
			
			if line =~ /max_bought\=/
				max_bought = true
				next
			end
			
			if line =~ /national_focus\=/
				national_focus = true
				next
			end
			
			if line =~ /expenses\=/
				expenses = true
				next
			end
			
			if line =~ /\sincomes\=\n/
				incomes = true
				next
			end
			
			if line =~ /interesting_countries\=/
				interesting_countries = true
				next
			end
			
			if line =~ /saved_country_supply\=/
				saved_country_supply = true
				next
			end
			
			### Check all variables saved at depth 1 
			if line =~ /tax_base\=/
				this_country.tax_base = line.split('=')[1].to_f
				next
			end
			if line =~ /capital\=/
				this_country.capital = line.split('=')[1].to_i
				next
			end
			
			if line =~ /last_election\=/
				this_country.last_election = line.split('=')[1].gsub!(/\A"|"\Z/, '').strip
				next
			end
			if line =~ /ruling_party\=/
				this_country.ruling_party = line.split('=')[1].to_i
				next
			end
			if line =~ /active_party\=/ 
				this_country.active_parties.push(line.split('=')[1].to_i)
				next
			end
			
			if line =~ /revanchism\=/
				this_country.revanchism = line.split('=')[1].to_f
				next
			end
			
			if line =~ /plurality\=/
				this_country.plurality = line.split('=')[1].to_f
				next
			end
			
			if line =~ /overseas_penalty\=/
				this_country.overseas_penalty = line.split('=')[1].to_f
				next
			end
			
			if line =~ /leadership\=/
				this_country.leadership = line.split('=')[1].to_f
				next
			end
			
			if line =~ /schools\=/
				this_country.schools = line.split('=')[1].gsub(/\A"+(.*?)"+\Z/m, '\1').strip
				next
			end
			
			if line =~ /primary_culture\=/
				this_country.primary_culture = line.split('=')[1].gsub(/\A"+(.*?)"+\Z/m, '\1').strip
				next
			end
			
			if line =~ /prestige\=/
				this_country.prestige = line.split('=')[1].to_f
				next
			end
			
			if line =~ /nationalvalue\=/
				this_country.national_value = line.split('=')[1].gsub(/\A"+(.*?)"+\Z/m, '\1').strip
				next
			end
			
			if line =~ /suppression\=/
				this_country.suppression = line.split('=')[1].to_f
				next
			end
			
			#### Start tracking relations with other countries
			if line =~ /[A-Z]{3}\=/
				relation_tag = line.split('=')[0].strip
			end
			
			if line =~ /money\=/
				this_country.money = line.strip.split('=')[1].to_f
			end
			
			if line =~ /last_bankrupt\=/
				this_country.last_bankrupt = line.strip.split('=')[1].gsub(/\A"+(.*?)"+\Z/m, '\1')
			end
			
			if line =~ /badboy\=/
				this_country.badboy = line.strip.split('=')[1].to_f
			end
			
			if line =~ /tarrifs\=/
				this_country.tarrifs = line.strip.split('=')[1].to_f
			end
			
			if line =~ /trade_cap_land\=/
				this_country.trade_cap_land = line.strip.split('=')[1].to_f
			end
			
			if line =~ /trade_cap_naval\=/
				this_country.trade_cap_naval = line.strip.split('=')[1].to_f
			end
			
			if line =~ /trade_cap_projects\=/
				this_country.trade_cap_projects = line.strip.split('=')[1].to_f
			end
			
			if line =~ /max_tarrif\=/
				this_country.max_tarrif = line.strip.split('=')[1].to_f
			end
		end
		
		if depth == 2
			
			#### Here is where we get variables stored in their own blocks
			if flags == true && line =~ /[a-zA-Z]*\=yes/
				this_country.flags.push(line.split('=')[0].strip)
			end
			
			if variables == true && line =~ /[a-zA-Z]*\=/
				split_line = line.split('=')
				this_country.variables[split_line[0].strip] = split_line[1].to_i
			end
			
			if upper_house == true && line =~ /[a-zA-Z]*\=\d*/
				split_line = line.split('=')
				this_country.upper_house[split_line[0].strip] = split_line[1].to_f.round(3)
			end
			
			if research == true && line =~ /[a-zA-Z]*\=/
				split_line = line.split('=')
				
				if split_line[1] =~ /\d/
					split_line[1] = split_line[1].to_f.round(1)
				else 
					split_line[1] = split_line[1].strip
				end
				this_country.research[split_line[0].strip] = split_line[1]
			end
			
			if naval_need == true && line =~ /[a-zA-Z]*\=\d*/
				split_line = line.split('=')
				this_country.naval_need[split_line[0].strip] = split_line[1].to_f.round(3)
				next
			end
			
			if land_supply_cost == true && line =~ /[a-zA-Z]*\=\d*/
				split_line = line.split('=')
				this_country.land_supply_cost[split_line[0].strip] = split_line[1].to_f.round(3)
				next
			end
			
			if naval_supply_cost == true && line =~ /[a-zA-Z]*\=\d*/
				split_line = line.split('=')
				this_country.naval_supply_cost[split_line[0].strip] = split_line[1].to_f.round(3)
				next
			end
			
			if rich_tax == true && line =~ /[a-zA-Z]*\=\d{1,}/
				split_line = line.split('=')
				this_country.rich_tax[split_line[0].strip] = split_line[1].to_f.round(3)
				next
			end
			
			if middle_tax == true && line =~ /[a-zA-Z]*\=\d{1,}/
				split_line = line.split('=')
				this_country.middle_tax[split_line[0].strip] = split_line[1].to_f.round(3)
				next
			end
			
			if poor_tax == true && line =~ /[a-zA-Z]*\=\d{1,}/
				split_line = line.split('=')
				this_country.poor_tax[split_line[0].strip] = split_line[1].to_f.round(3)
				next
			end
			
			##### Here is where we grab the different kinds of spending
			if social_spending == true && line =~ /[a-zA-Z]*\=\d{1,}/
				split_line = line.split('=')
				this_country.social_spending[split_line[0].strip] = split_line[1].to_f.round(3)
				next
			end
			
			if crime_fighting == true && line =~ /[a-zA-Z]*\=\d{1,}/
				split_line = line.split('=')
				this_country.crime_fighting[split_line[0].strip] = split_line[1].to_f.round(3)
				next
			end
			
			if education_spending == true && line =~ /[a-zA-Z]*\=\d{1,}/
				split_line = line.split('=')
				this_country.education_spending[split_line[0].strip] = split_line[1].to_f.round(3)
				next
			end
			
			if military_spending == true && line =~ /[a-zA-Z]*\=\d{1,}/
				split_line = line.split('=')
				this_country.military_spending[split_line[0].strip] = split_line[1].to_f.round(3)
				next
			end
			
			##### Get Active and Illegal inventions
			if active_inventions == true && line =~ /\d{1,}/
				split_line = line.strip.split(' ')
				split_line.each do |n|
					n = n.to_i
				end
				split_line.pop
				this_country.active_inventions = split_line
			end
			
			if illegal_inventions == true && line =~ /\d{1,}/
				split_line = line.strip.split(' ')
				split_line.each do |n|
					n = n.to_i
				end
				split_line.pop
				this_country.illegal_inventions = split_line
			end
				
			
			
			#### Modifiers are annoyingly saved as two things and not just name=date 
			#### so we have to create a persistent modifier name and then add it whenever
			#### we encounter the date
			if modifier == true && line =~ /modifier\=/
				modifier_name = line.split('=')[1].strip.gsub!(/\A"|"\Z/, '')
			end
			
			if modifier == true && line =~ /date\=/
				mod_date = line.split('=')[1].strip.gsub!(/\A"|"\Z/, '')
				this_country.modifiers[modifier_name] = mod_date
				next
			end
			
			#### We also have to check if we are in a tax eff or tax income array
			if line =~ /tax_eff\=/
				tax_eff = true
			end
			
			if line =~ /tax_income\=/
				tax_income = true
				next
			end
			
			#### Here is where we extract values for diplomacy
			unless relation_tag == nil
				if line =~ /\=/
					split_line = line.split('=')
					unless split_line[1] =~ /\"/
						split_line[1] = split_line[1].to_i
					else 
						split_line[1] = split_line[1].strip.gsub!(/\A"|"\Z/, '')
					end
					this_country.relations[relation_tag][split_line[0].strip] = split_line[1]
				end
			end
			
			#### Grab AI Variables Here
			if ai == true && line =~ /[A-Za-z]{1,}\=/
				### We grab variables saved at the top level 
				### like personality here
				if line =~ /[A-Za-z]{1,}\=\S{1,}/
					split_line = line.strip.split('=')
					this_country.ai[split_line[0]] = split_line[1]
				end
				
				#### Turn on conditionals for which AI blocks we are in
				if line =~ /rival\=/
					rival = true
					next
				end
				
				if line =~ /protect\=/
					protect = true
					next
				end
				
				if line =~ /befriend\=/
					befriend = true
					next
				end
				
				if line =~ /antagonize\=/
					antagonize = true
					next
				end
				
				if line =~ /threat\=/
					threat = true
					next
				end
				
				if line =~ /conquer_prov\=/
					conquer_prov = true
				end
					
			end
			
			
			#### Get Cultures (I Think Accepted Cultures)
			if culture == true && line =~ /[A-Za-z]{1,}/
				this_country.accepted_cultures.push(line.strip.gsub(/\A"+(.*?)"+\Z/m, '\1'))
			end
			
			
			#### Get Bank && creditor Values
			if bank == true && line =~ /[A-Za-z]{1,}/
				split_line = line.split('=')
				this_country.bank[split_line[0].strip] = split_line[1].to_f
			end
			
			if creditor == true && line =~ /[A-Za-z]{1,}/
				
				if line =~ /country\=\"/
					creditor_tag = line.strip.split('=')[1].gsub(/\A"+(.*?)"+\Z/m, '\1')
					puts creditor_tag
				else
					split_line = line.strip.split('=')
					unless split_line[1] =~ /[A-Za-z]{1,}/
						split_line[1] = split_line[1].to_f
					end
					if split_line[1] =~ /yes/
						split_line[1] = true
					end
					this_country.creditors[creditor_tag][split_line[0]] = split_line[1]
				end
				next
			end
			
			
			
			#### Get Supply and Demand Pools
			#### I can guess what some of these are but I'm not sure what max_bought
			#### and saved_country_supply are
			if domestic_supply_pool == true &&  line =~ /[A-Za-z]{1,}\=\d{1,}/
				split_line = line.strip.split('=')
				this_country.domestic_supply_pool[split_line[0]] = split_line[1].to_f
				next
			end
			
			if domestic_demand_pool == true &&  line =~ /[A-Za-z]{1,}\=\d{1,}/
				split_line = line.strip.split('=')
				this_country.domestic_demand_pool[split_line[0]] = split_line[1].to_f
				next
			end
			
			if sold_supply_pool == true &&  line =~ /[A-Za-z]{1,}\=\d{1,}/
				split_line = line.strip.split('=')
				this_country.sold_supply_pool[split_line[0]] = split_line[1].to_f
				next
			end
			
			if actual_sold_domestic == true &&  line =~ /[A-Za-z]{1,}\=\d{1,}/
				split_line = line.strip.split('=')
				this_country.actual_sold_domestic[split_line[0]] = split_line[1].to_f
				next
			end
			
			if max_bought == true &&  line =~ /[A-Za-z]{1,}\=\d{1,}/
				split_line = line.strip.split('=')
				this_country.max_bought[split_line[0]] = split_line[1].to_f
				next
			end
			
			if saved_country_supply == true &&  line =~ /[A-Za-z]{1,}\=\d{1,}/
				split_line = line.strip.split('=')
				this_country.saved_country_supply[split_line[0]] = split_line[1].to_f
				next
			end
			
			#### Get National Foci
			if national_focus == true && line =~ /[A-Za-z]{1,}/
				split_line = line.strip.split('=')
				this_country.national_focus[split_line[1].gsub(/\A"+(.*?)"+\Z/m, '\1')] = split_line[0].gsub(/\A"+(.*?)"+\Z/m, '\1')
				next
			end
			
			#### Get Expenses
			if expenses == true && line =~ /\d{1,}\s/
				expense_arry = line.split(' ')
				expense_arry.pop
				expense_arry.each do |n|
					n = n.to_f
				end
				this_country.expenses = expense_arry
			end
			
			if incomes == true && line =~ /\d{1,}\s/
				income_arry = line.split(' ')
				income_arry.pop
				income_arry.each do |n|
					n = n.to_f
				end
				this_country.incomes = income_arry
			end
			
			
			#### get interesting_countries
			if interesting_countries == true && line =~ /\d{1,}\s/
				interesting_arry = line.split(' ')
				interesting_arry.pop
				interesting_arry.each do |n|
					n = n.to_i
				end
				this_country.interesting_countries = interesting_arry
			end
			
		end
		
		

		
		if depth == 3
			if tech == true && line =~ /[a-zA-Z]*\=/
				#puts line
				split_line = line.split('{')
				split_line_2 = split_line[1].split(' ')
				this_country.technology[split_line[0].gsub!(/\=/, '').strip] = [split_line_2[0].to_i, split_line_2[1].to_f.round(2)]
			end
			
			#### Capture tax eff and tax income arrays, not sure what they mean
			#### but at this point just grabbing everything. We also can't do next at
			#### the end of these because this is an instance where Pdox didn't give
			#### close parens their own line
			
			if poor_tax == true && tax_income == true && line =~ /\d{1,}/
				split_line = line.split(' ')
				income_array = Array.new
				split_line.each do |d|
					income_array.push(d.to_f)
				end
				this_country.poor_tax['tax_income'] = income_array
			end
			
			if poor_tax == true && tax_eff == true && line =~ /\d{1,}/
				split_line = line.split(' ')
				income_array = Array.new
				split_line.each do |d|
					income_array.push(d.to_f)
				end
				this_country.poor_tax['tax_eff'] = income_array
			end
			
			if middle_tax == true && tax_income == true && line =~ /\d{1,}/
				split_line = line.split(' ')
				income_array = Array.new
				split_line.each do |d|
					income_array.push(d.to_f)
				end
				this_country.middle_tax['tax_income'] = income_array
			end
			
			if middle_tax == true && tax_eff == true && line =~ /\d{1,}/
				split_line = line.split(' ')
				income_array = Array.new
				split_line.each do |d|
					income_array.push(d.to_f)
				end
				this_country.middle_tax['tax_eff'] = income_array
			end
			
			if rich_tax == true && tax_income == true && line =~ /\d{1,}/
				split_line = line.split(' ')
				income_array = Array.new
				split_line.each do |d|
					income_array.push(d.to_f)
				end
				this_country.rich_tax['tax_income'] = income_array
			end
			
			if rich_tax == true && tax_eff == true && line =~ /\d{1,}/
				split_line = line.split(' ')
				income_array = Array.new
				split_line.each do |d|
					income_array.push(d.to_f)
				end
				this_country.rich_tax['tax_eff'] = income_array
			end
			
			#### Grab the AI id
			if line =~ /id\=/ 
				if conquer_prov == true or threat == true || antagonize == true || befriend == true || protect == true || 
				rival == true
					ai_id = line.split('=')[1].strip.gsub(/\A"+(.*?)"+\Z/m, '\1')
				end
			end
			
			if conquer_prov == true && line =~/value\=/
				split_line = line.strip.split('=')
				this_country.ai['conquer_prov'][ai_id] = split_line[1]
			end
			
			if threat == true && line =~/value\=/
				split_line = line.strip.split('=')
				this_country.ai['threat'][ai_id] = split_line[1]
			end
			
			if antagonize == true && line =~/value\=/
				split_line = line.strip.split('=')
				this_country.ai['antagonize'][ai_id] = split_line[1]
			end
			
			if befriend == true && line =~/value\=/
				split_line = line.strip.split('=')
				this_country.ai['befriend'][ai_id] = split_line[1]
			end
			
			if protect == true && line =~/value\=/
				split_line = line.strip.split('=')
				this_country.ai['protect'][ai_id] = split_line[1]
			end
			
			if rival == true && line =~/value\=/
				split_line = line.strip.split('=')
				this_country.ai['rival'][ai_id] = split_line[1]
			end
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
			
			if naval_need == true && depth == 1
				naval_need = false
			end
			
			if land_supply_cost == true && depth == 1
				land_supply_cost = false
			end
			
			if naval_supply_cost == true && depth == 1
				naval_supply_cost = false
			end
			
			if modifier == true && depth ==1 
				modifier = false
				modifier_name = nil
			end
			
			if flags == true && depth == 1
				flags = false
			end
			
			if upper_house == true && depth == 1
				upper_house = false
			end
			
			if variables == true && depth == 1
				variables = false
			end
			
			if tech == true && depth == 1
				tech = false
				#puts "tech off"
			end
			
			if research == true && depth == 1
				research = false
			end
			
			if poor_tax == true && depth == 1
				poor_tax = false
			end
			
			if rich_tax == true && depth == 1
				rich_tax = false
			end
			
			if middle_tax == true && depth == 1
				middle_tax = false
			end
			
			if education_spending == true && depth == 1
				education_spending = false
			end
			
			if crime_fighting == true && depth == 1
				crime_fighting = false
			end
			
			if social_spending == true && depth == 1
				social_spending = false
			end
			
			if military_spending == true && depth == 1
				military_spending = false
			end
			
			if culture == true && depth == 1
				culture = false
			end
			
			if tax_eff == true && depth  == 2
				tax_eff = false
			end
			
			if tax_income == true && depth == 2
				tax_income = false
			end
			
			if ai == true && depth == 1
				ai = false
			end
			
			if ai_hard_strategy == true && depth == false
				ai_hard_strategy = false
			end
			
			if depth == 1
				relation_tag = nil
			end
			
			if active_inventions == true && depth == 1 
				active_inventions = false
			end
			
			if illegal_inventions == true && depth == 1
				illegal_inventions = false
			end
			
			if conquer_prov == true && depth == 2
				conquer_prov = false
			end
			
			if threat == true && depth == 2
				threat = false
			end
			
			if antagonize == true && depth == 2
				antagonize = false
			end
			
			if befriend == true && depth == 2
				befriend = false
			end
			
			if protect == true && depth == 2
				protect = false
			end
			
			if rival == true && depth == 2
				rival = false
			end
			
			if ai_id =! nil && depth == 2
				ai_id = nil
			end
			
			if creditor_tag =! nil && depth == 1
				creditor_tag = nil
			end
			
			if bank == true && depth == 1
				bank = false
			end
			
			if domestic_supply_pool == true && depth == 1
				domestic_supply_pool = false
			end
			
			if domestic_demand_pool == true && depth == 1
				domestic_demand_pool = false
			end
			
			if creditor == true && depth == 1
				creditor = false
			end
			
			if sold_supply_pool == true && depth == 1
				sold_supply_pool = false
			end
			
			if actual_sold_domestic == true && depth == 1
				actual_sold_domestic = false
			end
			
			if saved_country_supply == true && depth == 1
				saved_country_supply = false
			end
			
			if max_bought == true && depth == 1
				max_bought = false
			end
			
			if national_focus == true && depth == 1
				national_focus = false
			end
			
			if expenses == true && depth == 1
				expenses = false
			end
			
			if incomes == true && depth == 1
				incomes = false
			end
			
			if interesting_countries == true && depth == 1
				interesting_countries = false
			end
		end
		
		if line =~ /news_scope/
			break
		end
		
	end
	
	File.write('Countries.yml', tag_hash.to_yaml)
end