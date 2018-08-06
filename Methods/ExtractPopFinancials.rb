require 'Date'
require 'yaml'
require 'oj'
require_relative '..\Classes\Pop.rb'

def ExtractPopFinancials(pops)

### You give this method a Pop.yaml and it just pulls out relevant information
### and returns it as an array of pop objects. 

	new_pops = Array.new
	old_pops =  pops
	
	old_pops.each do |id, old_pop|
		new_pop = Pop.new(old_pop.id)
		new_pop.date = old_pop.date
		new_pop.size = old_pop.size
		new_pop.money = old_pop.money
		if old_pop.bank == nil
			new_pop.bank = 0.0
		else
			new_pop.bank = old_pop.bank
		end
		new_pop.owner = old_pop.owner
		new_pop.type = old_pop.type
		new_pop.prov_id = old_pop.prov_id
		new_pop.life_needs = old_pop.life_needs
		new_pop.every_needs = old_pop.every_needs
		new_pop.lux_needs = old_pop.lux_needs
		if old_pop.type == 'labourers' or old_pop.type == 'farmers' or old_pop.type == 'slaves'
			new_pop.rgo_type = old_pop.rgo_type
		end
		new_pops.push(new_pop)
	end
	
	return new_pops
end
