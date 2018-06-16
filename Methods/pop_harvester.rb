require 'Date'
require 'yaml'
require_relative '..\Classes\Pop.rb'
require_relative '..\Classes\Province.rb'

savefile = 'C:\Users\sdras\OneDrive\Documents\Paradox Interactive\Victoria II\HFM_LMM\save games\The_United States of America1845_08_01.v2'

time = Time.now

pop_hash = Hash.new{}
poptypes = ['farmers','aristocrats','artisans','bureaucrats',
	'soldiers', 'capitalists', 'clergymen', 'clerks', 'craftsmen',
	'labourers','officers','slaves','soldiers']


### Get the Date!	
date = 0
File.open(savefile).each do |line|
	if line =~ /date/
		line.gsub! /\n/, ''
		splitline = line.split('=')
		date = splitline[1].gsub!(/\A"|"\Z/, '')
	end
	
	break unless date == 0
end

##Figure out what line provinces start at
id_check = false
prov_lines_start = 0 
File.open(savefile).each do |line|
	prov_lines_start = prov_lines_start + 1
	if line =~ /\A\tid=/
			id_check = true
	end

	break if line =~ /\A\d*\=\n/ && id_check == true
end



### Begin to extract Pops
## We do this by finding the current province and the current type, creating a pop, and then adding values each time they 
## are found via regex. Then resetting. 
pop_count = 0
prov_count = 0
pop_array = Array.new{}
current_prov_id = nil
current_pop = nil
current_type = nil
this_pop = nil
this_instance = nil
current_line = 0
open_count = 0
ideologies = false
issues = false
rgo = false

File.open(savefile).each do |line|
	### Count lines, and don't start checking until you hit the right lines
	current_line = current_line + 1
	line.gsub! /\n/, ''
	next if current_line < prov_lines_start
	
	
	# Issues and Ideologies are large and we are leaving them out for now
	
	#if issues == true && line =~ /\}/
	#	issues = false
	#	open_count = open_count - 1
	#	next
	#end
	
	#if ideologies == true && line =~ /\}/
	#	ideologies = false
	#	open_count = open_count - 1
	#	next
	#end
		
	
	if line =~ /\{/
		open_count = open_count + 1
		next
	end
	
	if line =~ /\}/ 
		open_count = open_count - 1
		next
	end
	
	#### If out block depth is 0, then when we get a match for the regex n= we parse it as a province id.
	#### Also reset the current poptype
	if open_count == 0
		if line =~ /\A\d*\=/ 
			id = line.split('=')
			current_prov_id = id[0].to_i
			prov_count = prov_count + 1
			current_type = nil
		end
	end
	
	### If our depth block is 1, then every time we get a poptypes word match
	### we start a new pop
	if open_count == 1
		poptypes.each do |type|
			if line =~ /\A\t#{type}\=/
				current_type = type
			end
		end
	end
	
	#### If our depth block is 2, we load data into the current pop
	if open_count == 2
		unless current_type == nil
			##### Everytime we see a new ID, we create a pop with that ID and a pop Instance for this year
			
			if line =~ /\A\t\tid\=\d{1,}\Z/
				#### Push current pop instance into pop and add pop to pop array. 
				unless this_pop == nil
					this_pop.addPopInstance(this_instance)
					pop_array.push(this_pop)
					
					#### Add this pop to the correct id in pop hash
					if pop_hash.key?(this_pop.id)
						pop_hash[this_pop.id].addPopInstance(this_instance)
					else
						pop_hash[this_pop.id] = this_pop
					end
				end
				

				
				
				split_line = line.split('=')
				id = split_line[1].chomp
				this_pop = Pop.new(id)
				this_pop.type = current_type
				this_instance = PopInstance.new(date)
				next
			end
			
			unless this_pop == nil	
				
				#### if we have size=d add that size to the pop_instance
				if line =~ /\A\t\tsize=\d{1,}/
					split_line = split_line = line.split('=')
					this_instance.size = split_line[1].to_i
					next
				end
				
				#### if we have money=d add that size to the pop_instance
				if line =~ /\A\t\tmoney=\d{1,}/
					split_line = split_line = line.split('=')
					this_instance.money = split_line[1].to_f
					next
				end
				
				#### if we have con=d add that to the pop_instance
				if line =~ /\A\t\tcon=\d{1,}/
					split_line = split_line = line.split('=')
					this_instance.con = split_line[1].to_f
					next
				end
				
				#### if we have mil=d add that  to the pop_instance
				if line =~ /\A\t\tmil=\d{1,}/
					split_line = split_line = line.split('=')
					this_instance.mil = split_line[1].to_f
					next
				end
				
				#### if we have lit=d add that to the pop_instance
				if line =~ /\A\t\tliteracy=\d{1,}/
					split_line = split_line = line.split('=')
					this_instance.lit = split_line[1].to_f
					next
				end
				
				#### if we have everyday_needs add that to the pop_instance
				if line =~ /\A\t\teveryday_needs=\d{1,}/
					split_line = split_line = line.split('=')
					this_instance.erry_needs = split_line[1].to_f
					next
				end
				
				#### if we have everyday_needs add that to the pop_instance
				if line =~ /\A\t\tluxury_needs=\d{1,}/
					split_line = split_line = line.split('=')
					this_instance.lux_needs = split_line[1].to_f
					next
				end
				
				#### if we have everyday_needs add that to the pop_instance
				if line =~ /\A\t\tbank=\d{1,}/
					split_line = split_line = line.split('=')
					this_instance.bank = split_line[1].to_f
					next
				end
				
				#### If we have word=word split it and use them as culture and religion
				if line =~ /\A\t\t[a-zA-Z]{1,}\=[a-zA-Z]{1,}\Z/
					line.gsub! /\t/, ''
					split_line = line.split('=')
					this_pop.religion = split_line[1]			
					this_pop.culture = split_line[0]
					next
				end
				
				
				#### Set Ideologes and Issues to true if we start reading them
				if line =~ /\A\t\tissues=/
					issues = true
					next
				end
				
				if line =~/\A\t\tideology=/
					ideologies = true
					next
				end
				
			end
		end
	end
	
	if open_count == 3
		#if ideologies == true
		#	if line =~ /\d{1,2}\=/
		#		split_line = line.split('=')
		#		this_instance.ideologies[split_line[0]] = split_line[1]
		#		next
		#	end
		#end
		
		#if issues == true
		#	if line =~ /\d{1,2}\=/
		#		split_line = line.split('=')
		#		this_instance.issues[split_line[0]] = split_line[1]
		#		next
		#	end
		#end
	end
	
	
	
	if line =~ /tax_base/
		puts line, current_line
		this_pop.addPopInstance(this_instance)
		pop_array.push(this_pop)
		break
	end			
		
	#break if line =~ /Gulf/
end


File.write('Pop.yml', pop_array.to_yaml)
File.write('PopHash.yml', pop_hash.to_yaml)
runtime = Time.now - time
puts "runtime was #{runtime} seconds" 
