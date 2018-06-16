class State
	attr_accessor :id, :type, :is_colonial, :savings, :interest,
	:buildings, :poprojects, :flashpoint, :crisis, :provinces,
	:owner, :year, :is_slave
	
	def initialize(id)
		self.id = id
		self.buildings = Array.new
	end
end