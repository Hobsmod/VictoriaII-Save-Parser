class Province
	attr_accessor :year, :owner, :controller, :cores, :garrison, :colonial, :rgo_type, :life_rating,
	:last_imigration, :party_loyalty, :id, :date, :state, :name, :constructions, 
	:crime, :employees, :rgo_income, :railroad, :fort, :pop_ids, :infrastructure,
	:rgo
	def initialize(id)
		self.id = id
		self.pop_ids = Array.new
		self.employees = Hash.new{|hash, key| hash[key] = Hash.new}
		self.party_loyalty = Hash.new{}
		self.cores = Array.new
	end
	
	def countRGOWorkers
		count = 0
		unless employees.empty? == true
			employees.each do |key, value|
				count = count + value['count']
			end
		end
		return count
	end
	
	def rgoRevenuePerEmployee
		count = self.countRGOWorkers.to_f
		if count == 0
			return 0
		end
		revpercap = rgo_income/count
		return revpercap
	end
end

class State
	attr_accessor :provinces, :id
	
	def initialize(id)
		self.id = id
	end
end