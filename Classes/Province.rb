


class Province
	attr_accessor :id, :instances
		
	def initialize(id)
		self.id = id
		self.instances = Hash.new{}
	end
	
	def addInstance(province_instance)
		year = province_instance.year
		instances[year] = province_instance
	end
		
end

class ProvinceInstance
	attr_accessor :year, :owner, :controller, :core, :garrison, :colonial, :rgo, :life_rating,
	:last_immigration, :party_loyalty, :factories
	


end