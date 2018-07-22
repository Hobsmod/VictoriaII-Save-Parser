def addPopRgoType(pops, provs)
	require_relative '..\Classes\Pop.rb'
	require_relative '..\Classes\Province.rb'
	require 'fileutils'
	
	pops.each do |this_pop|
		rgo = provs[this_pop.prov_id].rgo_type
		if this_pop.type == 'labourer' or this_pop.type == 'farmer' or this_pop.type == 'slave'
			this_pop.rgo_type = rgo
		end
	end
	
end	