def getBasePrices(dir)
	#categories = [military_goods, raw_material_goods, industrial_goods, consumer_goods]
	open_count = 0
	current_good = nil
	base_prices = Hash.new{}
	
	File.open(dir + "\\" + 'goods.txt').each do |line|
		
		if open_count == 1 && line =~ /\A\t\w{1,}\ \=\ \{/
				#puts "Getting Gurrent Good", line
				line.gsub! /\t/,''
				split_line = line.split(' = ')
				current_good = split_line[0]
		end

		if open_count == 2 && line =~ /\A\t\tcost/
			#puts "Getting Price", line
			line.gsub! /\t/,''
			split_line = line.split(' = ')
			base_prices[current_good] = split_line[1].to_f
		end

		if line =~ /\{/
			open_count = open_count + 1
		end

		if line =~ /\}/ 
			open_count = open_count - 1
		end

		puts open_count
	end
	

	return base_prices

end