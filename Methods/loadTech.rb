def loadTech(mod_dir)

	require 'fileutils'
	require 'yaml'
	require_relative '..\Classes\Techs.rb'
	
	### You pass this method a mod directory and it goes in
	### and parses the poptypes into ruby objects that can be
	### conveniently called for other methods. This is automated
	### so these programs can handle a variety of mods. 

	unit_names = Array.new
	techs = Hash.new
	targ_dir = mod_dir + '\\technologies'
	unit_dir = mod_dir + '\\units'
	Dir.chdir(targ_dir)
	
	Dir.foreach(unit_dir) do |file|
		unless file =~ /\.txt/
			next
		end
		unit = file.split('.txt')
		unit_names.push(unit[0])
	end

	
	Dir.foreach(targ_dir) do |file|
		unless file =~ /\.txt/
			next
		end
		

		
		#### Persistent Vars
		what_bloc = nil
		depth = 0
		this_tech = nil
		what_unit = nil
		
		File.open(file).each do |line|
		
			#### count open and close parens
			if line =~ /\w*\s\=\s\{/ && depth == 0
				unless this_tech == nil
					if this_tech.unciv_mil == nil 
						this_tech.unciv_mil = false
					end
					techs[this_tech.name] = this_tech
				end
				name = line.split(' = ')[0]
				this_tech = Tech.new(name)
			end
			
			if line =~ /\{/
			depth = depth + 1
			end
			
			if line =~ /\}/
				depth = depth - 1
				if depth < 0 
					abort "Block depth is less than 0, something went wrong with counting parens"
				end
			end
		
			
			if line =~ /\#/
				next
			end
			
			if depth == 1
				##### What bloc are we in?
				if line =~ /ai_chance/
					what_bloc = 'ai'
				end
				
				if line =~ /modifier/
					what_bloc = 'modifier'
				end

				
				#### grab object attributes
				if line =~ /area\s\=\s\w*/
					line.gsub! /\t/,''
					split_line = line.chomp.split('=')
					this_tech.area = split_line[1].strip
					next
				end
				
				if line =~ /year\s\=\s\w*/
					line.gsub! /\t/,''
					split_line = line.chomp.split('=')
					this_tech.year = split_line[1].to_i
					next
				end
				
				if line =~ /cost\s\=\s\w*/
					line.gsub! /\t/,''
					split_line = line.chomp.split('=')
					this_tech.cost = split_line[1].to_f
					next
				end
				
				if line =~ /unciv\_military\s\=\syes/
					this_tech.unciv_mil = true
					next
				end
				
				#### grab effects				
				if line =~ /\w*\s\=\s\d*/ 
					unless line =~ /{/
						line.gsub! /\t/,''
						split_line = line.chomp.split('=')
						
						if line =~ /\d\.\d/
							this_tech.effects[split_line[0].strip] = split_line[1].to_f
						else
							this_tech.effects[split_line[0].strip] = split_line[1].to_i
						end
					end
				end	
				
				
				if line =~ /\w*\s\=\s\D{1,}/
					unless line =~ /{/
						line.gsub! /\t/,''
						split_line = line.chomp.split('=')
						this_tech.effects[split_line[0].strip] = split_line[1].strip
					end
				end	
			end
					
			if depth == 2 
							
				if line =~ /rgo_goods_output\s\=\s\{/
					what_bloc = 'rgo_good_output'
					next
				end
				
				if line =~ /rgo_size\s\=\s\{/
					what_bloc = 'rgo_size'
					next
				end
				
				if line =~ /army_base\s\=\s\{/
					what_bloc = 'army_base'
					next
				end
				
				### check last
				unit_names.each do |unit|
					if line =~ /#{unit}\s\=\s\{/
						what_bloc = 'unit'
						what_unit = unit
					end
				end
				
				### add effects
				if what_bloc == 'rgo_good_output' && line =~ /\w*\s\=\s\d*/
					line.gsub! /\t/,''
					split_line = line.chomp.split('=')
					this_tech.effects["#{split_line[0].strip}\_rgo_out"] = split_line[1].to_f
				end
				
				if what_bloc == 'rgo_size' && line =~ /\w*\s\=\s\d*/
					line.gsub! /\t/,''
					split_line = line.chomp.split('=')
					this_tech.effects["#{split_line[0].strip}\_rgo_size"] = split_line[1].to_f
				end
				
				if what_bloc == 'army_base' && line =~ /\w*\s\=\s\d*/
					line.gsub! /\t/,''
					split_line = line.chomp.split('=')
					this_tech.effects["army\_base\_#{split_line[0].strip}"] = split_line[1].to_f
				end
				
				if what_bloc == 'unit' && line =~ /\w*\s\=\s\d*/
					unless line =~ /#{what_unit}/
						line.gsub! /\t/,''
						split_line = line.chomp.split('=')
						this_tech.effects["#{what_unit}\_#{split_line[0].strip}"] = split_line[1].to_f
					end
				end
			end
			
			if depth == 1 && line =~ /}/
				what_bloc = nil
			end
			
			if depth == 2 && line =~ /}/
				what_bloc = nil
			end
		
		end
		
		
		unless this_tech == nil
			techs[this_tech.name] = this_tech
		end
			
	end
	
	return techs
end