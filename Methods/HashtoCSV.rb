#### A method that takes a 2d hash and prints it as a csv





def print_hash_as_csv(hash, out_file)
	column_labels = Array.new
	row_labels = Array.new
	hash.each do |key, value|
		row_labels.push(key)
		value.each do |k,v|
			column_labels.push(k)
		end
	end
	
	column_labels.uniq
	row_labels.uniq
	
	output = File.new(out_file, 'w')
	
	##### Print the header values
	print.output(',')
	column_labels.each do |label|
		print.output(label, ',')
	end
	print.output("\n")
	
	row_labels.each do |row|
		print.output(row,',')
		column_labels.each do |col|
			unless hash[row][col].exist?
				print.output(hash[row][col], ',')
			else
				print.output(0, ',')
			end
		end
		print.output("\n")
	end
	
end