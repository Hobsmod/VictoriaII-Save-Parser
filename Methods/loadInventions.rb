def loadInventions(mod_dir)

	require 'fileutils'
	require 'yaml'
	require_relative '..\Classes\Techs.rb'
	
	### You pass this method a mod directory and it goes in
	### and parses the poptypes into ruby objects that can be
	### conveniently called for other methods. This is automated
	### so these programs can handle a variety of mods. 

	unit_names = Array.new
	invents = Hash.new
	targ_dir = mod_dir + '\\inventions'
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
		this_invent = nil
		eff_name = nil
		
		File.open(file).each do |line|
		
			#### count open and close parens
						
			if line =~ /^#/
				puts line
				next
			end
			
			if line =~ /\w*\s\=\s\{/ && depth == 0
				unless this_invent == nil
					invents[this_invent.name] = this_invent
				end
				name = line.split(' = ')[0]
				this_invent = Invention.new(name)
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
		

			
			#### grab object attributes
				if line =~ /limit/
					line.gsub! /\t/,''
					line.gsub! /\{/,''
					line.gsub! /\}/,''
					split_line = line.chomp.split('=')
					this_invent.limit = split_line[1].strip
					next
				end
			
			
			if depth == 2
				##### What bloc are we in?
				if line =~ /chance/
					what_bloc = 'chance'
					next
				end
				
				if line =~ /effect/
					what_bloc = 'effects'
					next
				end

			
				
			end
					
			if depth == 2 && what_bloc == 'effects'
				if line =~ /\w*\s\=\s\{/
					eff_name = line.chomp.split(' = ')[0].strip
				else
					if line =~ /\w*\s\=\s\D{2,}/
						unless line =~ /{/
							line.gsub! /\t/,''
							split_line = line.chomp.split('=')
							if split_line[1] =~ /yes/
								split_line[1] = true
								this_invent.effects[split_line[0].strip] = split_line[1]
							else
								this_invent.effects[split_line[0].strip] = split_line[1].strip
							end
						end
					end	
					
					if line =~ /\w*\s\=\s\D*\d{1,}/ or line =~ /\w*\s\=\s\-\d*/	
						unless line =~ /{/
							line.gsub! /\t/,''
							split_line = line.chomp.split('=')
							if line =~ /\d*\.\d*/					
								this_invent.effects[split_line[0].strip] = split_line[1].to_f
							else
								this_invent.effects[split_line[0].strip] = split_line[1].to_i
							end
						end
					end	
				end
			end

			if depth == 3 && what_bloc == 'effects'
				if line =~ /\w*\s\=\s\{/
					eff_name = line.chomp.split(' = ')[0].strip
				end
				
				
				if line =~ /\w*\s\=\s\d{1,}/ or line =~ /\w*\s\=\s\-\d*/
					unless line =~ /{/
						line.gsub! /\t/,''
						split_line = line.chomp.split('=')
						if line =~ /\d\.\d/					
							this_invent.effects["#{eff_name}_#{split_line[0].strip}"] = split_line[1].to_f
						else
							this_invent.effects["#{eff_name}_#{split_line[0].strip}"] = split_line[1].to_i
						end
					end
				end	
				
				
				if line =~ /\w*\s\=\s\D{2,}/
					unless line =~ /{/
						line.gsub! /\t/,''
						split_line = line.chomp.split('=')
						if split_line[1] =~ /yes/
							split_line[1] = true
						end
						this_invent.effects["#{eff_name}_#{split_line[0].strip}"] = split_line[1].strip
					end
				end	
			end
				
			
			if depth == 1 && line =~ /}/
				what_bloc = nil
				what_unit = nil
			end
			
			if depth == 2 && line =~ /}/
			end
			
			if depth == 3 && line =~ /}/
				what_unit = nil
				eff_name = nil
			end
		
		end
		
		
		unless this_invent == nil
			invents[this_invent.name] = this_invent
		end
			
	end

	return invents
end