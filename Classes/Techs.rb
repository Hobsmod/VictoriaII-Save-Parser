require 'descriptive_statistics'


class Tech
	attr_accessor :area, :year, :cost, :effects, :name, :unciv_mil
	
	def initialize(name)
		self.name = name
		self.effects = Hash.new{|hash, key| hash[key] = Hash.new}
	end
	
end



