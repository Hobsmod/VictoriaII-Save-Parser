


class Province
	attr_accesor :id, :owner, :controller, :core, :garrison, :colonial, :rgo, :life_rating,
	:last_immigration, :party_loyalty, :factories
	
	initialize(id, owner)
		self.id = location
		self.owner = owner
	end
end