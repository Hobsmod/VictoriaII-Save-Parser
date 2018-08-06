require 'descriptive_statistics'


class RGO
	attr_accessor :type, :employees, :income, :total_employees, :output,
	:prov_id, :prov_name, :owner, :unemployment
	
	
	def initialize()
		self.employees = Hash.new{|hash, key| hash[key] = Hash.new}
	end
	
	def calcTotalEmp()
		total = 0
		self.employees.each do |key, value|
			total = total + value['count']
		end
		self.total_employees = total
		return total
	end
	
	def calcUnemp(prov_hash, pop_hash)
			elligible_pops = 0.0
			pop_ids = prov_hash[self.prov_id].pop_ids
			pop_ids.each do |pop|
				if pop_hash[pop].type =~ /farmers/ or pop_hash[pop].type =~ /labourers/
					elligible_pops = elligible_pops + pop_hash[pop].size.to_f
				end
			end
		unless self.total_employees == nil
			self.unemployment = selftotal_employees / elligible_pops
		else
			self.calcTotalEmp
			self.unemployment = self.total_employees / elligible_pops
		end
		
		return self.unemployment
	end

	def calcOutput(global_market_data)
		self.output = self.income / global_market_data.current_prices[self.type]
		return self.output
	end	

end



