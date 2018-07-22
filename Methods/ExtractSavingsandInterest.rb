require 'Date'
require 'yaml'

require_relative '..\Classes\Country.rb'
require_relative '..\Classes\Pop.rb'
require_relative '..\Classes\State.rb'
require_relative '..\Classes\Province.rb'
save_dir = 'C:\Users\sdras\Documents\Paradox Interactive\Victoria II\save games\madagascar'

start = Time.now
savings_n_interest = Hash.new{|hash, key| hash[key] = Hash.new}

(1837..1935).each do |year|
	this_dir = save_dir + '\\' + year.to_s + '-Objectified'
	prov_owners = Hash.new
	total_savings = 0
	total_interest = 0
	### Calculate Factory money
	state_arry = YAML.load(File.read(this_dir + '\\' + 'States.yml'))
	puts "loaded states"
	puts Time.now - start
	
	state_arry.each do |this_state|
		total_interest = this_state.interest + total_interest
		total_savings = this_state.savings + total_savings
	end	
	
	savings_n_interest[year]['savings'] = total_savings
	savings_n_interest[year]['interest'] = total_interest

end
	
	
savings_n_interest.each do |year, value|
	this_line = year.to_s + ','
	value.each do |k, v|
		this_line = this_line + v.to_s + ','
	end
	puts this_line
end