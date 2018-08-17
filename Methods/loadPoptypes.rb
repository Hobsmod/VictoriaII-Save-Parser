def loadPoptypes(mod_dir)

	require 'fileutils'
	require 'yaml'
	require_relative '..\Classes\Poptype.rb'
	
	### You pass this method a mod directory and it goes in
	### and parses the poptypes into ruby objects that can be
	### conveniently called for other methods. This is automated
	### so these programs can handle a variety of mods. 

	
	types_arr = Array.new
	targ_dir = mod_dir + '\\poptypes'
	Dir.chdir(targ_dir)
	
	
	Dir.foreach(targ_dir) do |file|
		unless file =~ /\.txt/
			next
		end
		
		poptype_name = file.split('.')[0]
		this_type = Poptype.new(poptype_name)
		
		#### Persistent Vars
		what_bloc = nil
		depth = 0
		
		
		File.open(file).each do |line|
		
			#### count open and close parens
			if line =~ /\{/
			depth = depth + 1
			end
			
			if line =~ /\}/
				depth = depth - 1
				if depth < 0 
					abort "Block depth is less than 0, something went wrong with counting parens"
				end
			end
		
			##### What bloc are we in?
			if line =~ /rebel/
				what_bloc = 'rebel'
			end
			
			if line =~ /life_needs/
				what_bloc = 'life_needs'
			end
			
			if line =~ /everyday_needs/
				what_bloc = 'everyday_needs'
			end
				
			if line =~ /luxury_needs/
				what_bloc = 'luxury_needs'
			end
			
			
			if depth == 1
				if what_bloc == 'rebel'
					if line =~ /[a-z]{1,}\s\=\s\d{1,}/
						line.gsub! /\t/,''
						split_line = line.chomp.split('=')
						this_type.rebel[split_line[0]] = split_line[1].to_f
					end
				end
				
				if what_bloc == 'life_needs'
					if line =~ /[a-z]{1,}\s\=\s\d*/
						line.gsub! /\t/,''
						split_line = line.chomp.split('=')
						this_type.life_needs[split_line[0]] = split_line[1].to_f
					end
				end
			
				if what_bloc == 'everyday_needs'
					if line =~ /[a-z]{1,}\s\=\s\d{1,}/
						line.gsub! /\t/,''
						split_line = line.chomp.split('=')
						this_type.everyday_needs[split_line[0]] = split_line[1].to_f
					end
				end
				
				if what_bloc == 'luxury_needs'
					if line =~ /[a-z]{1,}\s\=\s\d{1,}/
						line.gsub! /\t/,''
						split_line = line.chomp.split('=')
						this_type.luxury_needs[split_line[0]] = split_line[1].to_f
					end
				end
			end
			
			if depth == 0 && line =~ /}/
				what_bloc = nil
			end
		end
		
		types_arr.push(this_type)
			
	end
	
	return types_arr
end