def addPopRgoType(pops, provs)
	require_relative '..\Classes\Pop.rb'
	require_relative '..\Classes\Province.rb'
	require 'fileutils'
	
	pops.each do |this_pop|
		rgo = provs[this_pop.prov_id].rgo_type
		if this_pop.type == 'labourers' or this_pop.type == 'farmers' or this_pop.type == 'slaves'
			this_pop.rgo_type = rgo
		end
	end
	
end	