class ProductionTypeWIP
	attr_accessor :type, :output, :out_value, :inputs, :name, 
		:workforce, :template, :efficiency, :owner, :bonuses
	
	def initialize(name)
		self.inputs = Hash.new
		self.name = name
		self.owner = Hash.new
		self.bonuses = Hash.new
	end
	

end

class ProductionTemplate
	attr_accessor :name, :efficiency, :owner, :employees, :workforce, :type

	def initialize(name)
		self.name = name
		self.efficiency = Hash.new{}
		self.owner = Hash.new{}
		self.employees = Hash.new{|hash, key| hash[key] = Hash.new}
	end
end
		