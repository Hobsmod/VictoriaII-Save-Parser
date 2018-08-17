class Poptype
	attr_accessor  :name, :everyday_needs, :life_needs, :luxury_needs,
		:rebel
	def initialize(name)
		self.name = name
		self.everyday_needs = Hash.new
		self.life_needs = Hash.new
		self.luxury_needs = Hash.new
		self.rebel = Hash.new
	end
end