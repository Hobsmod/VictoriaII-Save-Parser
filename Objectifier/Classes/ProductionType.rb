class ProductionType
	attr_accessor :type, :output, :out_value, :inputs, :name, 
		:workforce, :template, :efficiency
	
	def initialize(type, output)
		self.type = type
		self.output = output
		self.name = output.to_s + '_' + type.to_s
	end
	
	def getProfit(prices)
		revenue = out_value * prices[output]
		costs = 0.0
		inputs.each do |key, value|
			this_cost = prices[key] * value
			costs = costs + this_cost
		end
		
		unless efficiency == nil
			efficiency.each do |key, value|
				this_cost = prices[key] * value
				costs = costs + this_cost
			end
		end
		
		profit = revenue - costs
		
		return profit
	end

end

class FactoryTemplate
	attr_accessor :name, :efficiency, :owner, :employees, :workforce

	def initialize(name)
		self.name = name
		self.efficiency = Hash.new{}
		self.owner = Hash.new{}
		self.employees = Hash.new{}
	end
end
		