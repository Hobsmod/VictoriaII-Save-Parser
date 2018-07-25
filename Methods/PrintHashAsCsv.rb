#### A method that takes a 2d hash and prints it as a csv





def print_hash_as_csv(hash, out_file, flip = false)
	column_labels = Array.new
	row_labels = Array.new
	hash.each do |key, value|
		row_labels.push(key)
		value.each do |k,v|
			column_labels.push(k)
		end
	end
	
	column_labels = column_labels.uniq
	output = File.new(out_file, 'w')
	
	##### Print the header values
	output.print(',')
	column_labels.each do |label|
		output.print(label, ',')
	end
	output.print("\n")
	
	row_labels.each do |row|
		output.print(row,',')
		column_labels.each do |col|
			unless hash[row][col].nil?
				output.print(hash[row][col], ',')
			else
				output.print(0, ',')
			end
		end
		output.print("\n")
	end
	
end