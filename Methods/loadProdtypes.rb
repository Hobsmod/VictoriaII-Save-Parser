def loadProdtypes(mod_dir)

	require 'fileutils'
	require 'yaml'
	require_relative '..\Classes\ProdTypeWIP.rb'
	
	### You pass this method a mod directory and it goes in
	### and parses the production into ruby objects that can be
	### conveniently called for other methods. This is automated
	### so these programs can handle a variety of mods. 

	templates = Array.new
	types_arr = Array.new
	targ_file = mod_dir + '\\common\\production_types.txt'
	this_temp = nil
	this_type = nil
	what_emp = nil
	
	#### Persistent Vars
	what_bloc = nil
	depth = 0
		
	File.open(targ_file).each do |line|
		
		#### count open and close parens
	
	
		#### Create a new template object if we encounter the string 'template' at depth 0
		if depth == 0 
			if line =~ /template/
				puts 'found template'
				unless this_temp == nil
					templates.push(this_temp)
					this_temp = nil
					puts 'pushed template'
				end
				temp_name = line.split(' ')[0]
				this_temp = ProductionTemplate.new(temp_name)
			end
			
			
			if line =~ /\S{5,}\s\S*\s\{/
				unless this_type == nil
					types_arr.push(this_type)
					this_type = nil
				end
				type_name = line.split(' ')[0]
				this_type = ProductionTypeWIP.new(type_name)
			end
		end
	
		##### What bloc are we in?
		if depth == 1
			if line =~ /type/
				unless this_temp == nil
					line.gsub! /\t/,''
					split_line = line.chomp.split(' = ')
					this_temp.type = split_line[1]
				end
				unless this_type == nil
					line.gsub! /\t/,''
					split_line = line.chomp.split(' = ')
					this_type.type = split_line[1]
				end
			end
			
			if line =~ /workforce/
				unless this_temp == nil
					line.gsub! /\t/,''
					split_line = line.strip.chomp.split(' = ')
					this_temp.workforce = split_line[1].to_i
				end
				
				unless this_type == nil
					line.gsub! /\t/,''
					split_line = line.chomp.split(' = ')
					this_type.workforce = split_line[1].to_i
				end
			end
			
			if line =~ /output_goods/
				unless this_type == nil
					line.gsub! /\t/,''
					split_line = line.chomp.split(' ')
					this_type.output = split_line[2]
				end
			end
			
			if line =~ /value/
				unless this_type == nil
					line.gsub! /\t/,''
					split_line = line.chomp.split(/[\s,\#]/)
					this_type.out_value = split_line[2].to_f
				end
			end
			
			if line =~ /efficiency/
				what_bloc = 'efficiency'
			end
			
			if line =~ /owner/
				what_bloc = 'owner'
			end
			
			if line =~ /employees/
				what_bloc = 'employees'
			end
				
			if line =~ /input_goods/
				what_bloc = 'input_goods'
			end
			
			if line =~ /bonus/
				what_bloc = 'bonus'
			end
		end
		

		#### dealing with sub blocs
		if depth == 2
			if what_bloc == 'efficiency'
				puts 'in eff bloc'
				if line =~ /[a-z]*\s\=\s\d*/
					line.gsub! /\t/,''
					split_line = line.chomp.split(' = ')
					this_temp.efficiency[split_line[0]] = split_line[1].to_f
				end
			end
			
			if what_bloc == 'owner'
				if line =~ /[a-z]{1,}\s\=\s\d*/
					unless this_temp == nil
						line.gsub! /\t/,''
						split_line = line.strip.chomp.split(' = ')
						if split_line[1] =~ /\d/
							split_line[1] = split_line[1].to_f
						end
						this_temp.owner[split_line[0]] = split_line[1]
					end
					
					unless this_type == nil
						line.gsub! /\t/,''
						split_line = line.strip.chomp.split(' = ')
						if split_line[1] =~ /\d/
							split_line[1] = split_line[1].to_f
						end
						this_type.owner[split_line[0]] = split_line[1]
					end
				end
			end
	
			if what_bloc == 'input_goods'
				if line =~ /[a-z]{1,}\s\=\s\d*/
					line.gsub! /\t/,''
					split_line = line.chomp.split(' = ')
					this_type.inputs[split_line[0]] = split_line[1].to_f
				end
			end
		end
		
		
		if depth == 3
			if what_bloc == 'employees'
				if line =~ /poptype/
					line.gsub! /\t/,''
					split_line = line.chomp.split(' = ')
					what_emp = split_line[1]
				else 
					if line =~ /[a-z]{1,}\s\=\s*/
						line.gsub! /\t/,''
						split_line = line.chomp.split(' = ')
						if split_line[1] =~ /\d/
							split_line[1] = split_line[1].to_f
						end
						this_temp.employees[split_line[0]] = split_line[1]
					end
				end
			end
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
		
		if depth == 0
			what_bloc = nil
		end
	end
		
	types_arr.push(this_type)
	types_arr.push(templates)
	
	return types_arr
end