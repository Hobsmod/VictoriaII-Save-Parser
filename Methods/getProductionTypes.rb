require_relative '..\Classes\Productiontype.rb'

def getFactoryTemplates(dir)
	template_hash = Hash.new{}
	efficiency_io = false
	efficiency_goods = Hash.new{}
	open_count = 0
	template_name = nil
	#owner_io = false
	#employees_io = false
	File.open(dir + "\\" + 'production_types.txt').each do |line|
		break if line=~ /aeroplane_factory/
		
		if open_count == 0 && line =~ /template/
			split_line = line.split(' ')
			template_name = split_line[0]
		end
		
		if efficiency_io == true && open_count != 2
			efficiency_io = false
		end
		
		if efficiency_io == true && line =~ /\w{1,}\ \=/
			split_line = line.split(/['=',"\#"]/)
			efficiency_goods[split_line[0].strip] = split_line[1].to_f 

		end
			
		if line =~ /efficiency/ && open_count == 1
			efficiency_io = true
		end
		#if line =~ /owner/
		#	owner_io = true
		#end
		#if line =~ /employees/
		#	employees_io = true
		#end
		if line =~ /\}/
			open_count = open_count - 1
		end
		if line =~ /\{/
			open_count = open_count + 1
		end

		if open_count == 0 && template_name != nil
			this_template = FactoryTemplate.new(template_name)
			this_template.efficiency = efficiency_goods
			template_hash[template_name] = this_template
			template_name = nil
			efficiency_goods = Hash.new{}
		end
	end
	
	File.write('Templates.yml', template_hash.to_yaml)
	return template_hash
end


def getProductionTypes(dir)
	current_template = nil
	current_good = nil
	factory_start = false
	production_types = Array.new{}
	current_type = nil
	inputs_start = nil
	out_start = nil
	artisan_start = false
	inputs = Hash.new{}
	open_count = 0
	factory_templates = getFactoryTemplates(dir)

	File.open(dir + "\\" + 'production_types.txt').each do |line|
		
		line.gsub! /\n/, ''
		line.gsub! /\t/, ''

		### Assuming Aeroplane Factory is the First to Appear
		unless factory_start == true
			if line =~ /aeroplane_factory/
				factory_start = true
				current_type = 'factory'
			end
		end

		if line =~ /RGO/
			factory_start = false
		end

		unless artisan_start == true
			if line =~ /artisan_aeroplane/
				factory_start = false
				artisan_start = true
				current_type = 'artisan'
			end
		end
		
		if line =~ /\Atemplate\ \=\ /
			split_line = line.split(' = ')
			current_template = split_line[1].strip
		end

		if inputs_start == true && line =~ /\=/
			line.strip
			split_line = line.split(' = ')
			inputs[split_line[0].to_s] = split_line[1].to_f
		end

		if line =~ /input_goods/ && open_count == 1 
			if factory_start == true or artisan_start == true
				inputs_start = true
			end
		end
	
	

		if open_count == 1 && line =~ /output_good/
			line.gsub! /\t/,''
			split_line = line.split(/['=',"\#"]/)
			current_good = split_line[1].strip
		end
		
		if open_count == 1 && line =~ /value/
			if factory_start == true or artisan_start == true
				line.gsub! /\t/,''
				split_line = line.split(/['=',"\#"]/)
				out_value = split_line[1].strip.to_f
				this_type = ProductionType.new(current_type, current_good)
				this_type.out_value = out_value
				this_type.inputs = inputs
				this_type.template = current_template
				if current_type == 'factory'
					this_type.efficiency = factory_templates[current_template].efficiency
				end
				inputs = Hash.new{}
				production_types.push(this_type)
			end
		end

			
		#### Open Count
		if line =~ /\}/
			open_count = open_count - 1
		end

		if line =~ /\{/ 
			open_count = open_count + 1
		end

		if open_count != 2 && inputs_start == true
			inputs_start = false
		end
			

	end
	

	return production_types
end