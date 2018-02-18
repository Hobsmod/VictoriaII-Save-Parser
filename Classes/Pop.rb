class Pop
	attr_accessor :location, :type, :culture, :religion, :id, :instances
	
	def initialize(id)
		self.id = id
		self.instances = Array.new()
	end
	
	def addPopInstance(inst)
		instances.push(inst)
	end
end

class PopInstance
	attr_accessor  :year, :owner, :colonial, :size, :money, :con, :mil, :lit, :ideologies,
	:life_needs, :erry_needs, :lux_needs, :bank, :issues
		
	def initialize(year)
		self.year = year
		self.issues = Hash.new{}
		self.ideologies = Hash.new{}
	end
	
	
end