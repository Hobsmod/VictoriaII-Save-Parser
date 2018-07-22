def addPopOwners(pops, provs)
	require_relative '..\Classes\Pop.rb'
	require_relative '..\Classes\Province.rb'
	require 'fileutils'
	

	pops.each do |this_pop|
		owner = provs[this_pop.prov_id].owner
		this_pop.owner = owner
	end
	
end	