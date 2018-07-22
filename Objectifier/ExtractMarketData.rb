require 'Date'
require 'yaml'
require 'csv'
require_relative 'Classes\Country.rb'
require_relative 'Classes\Pop.rb'
require_relative 'Classes\State.rb'
require_relative 'Classes\Province.rb'
save_dir = 'C:\Users\sdras\Documents\Paradox Interactive\Victoria II\save games\madagascar'

start = Time.now
world_output = Hash.new{}



(1837..1935).each do |year|
	this_dir = save_dir + '\\' + year.to_s + '-Objectified'
	market_data = YAML.load(File.read(this_dir + '\\' + 'MarketData.yml'))
    total_world_output = 0
	
	market_data['actual_sold'].each do |good, value|
		good_output_value = value * market_data['price_history'][good] 
		total_world_output = total_world_output + good_output_value
	end
	
	world_output[year] = total_world_output
end
	

File.write('Output.JSON', world_output.dump_object)	