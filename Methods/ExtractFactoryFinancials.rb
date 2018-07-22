require 'Date'
require 'yaml'
require 'oj'
require_relative '..\Classes\State.rb'
require_relative '..\Classes\Factory.rb'

def ExtractFactoryFinancials(states)

	new_factories = Array.new
	
	
	states.each do |this_state|
		if this_state.buildings.nil? or this_state.buildings.empty? 
			next
		end
		
		
		this_state.buildings.each do |this_building|
			new_factory = Factory.new(this_building.type)
			new_factory.date = this_state.year
			new_factory.level = this_building.level
			new_factory.money = this_building.money
			new_factory.subsidised = this_building.subsidised
			new_factory.setUnsub
			new_factory.level = this_building.level
			new_factory.total_employees = this_building.calcTotalEmployees
			
			unless this_building.profit_history_arr.nil? or this_building.profit_history_arr.empty?
				new_factory.avg_profit = this_building.calcAvgProfit
			end
			
			new_factories.push(new_factory)
		end
	end
	
	return new_factories
end
