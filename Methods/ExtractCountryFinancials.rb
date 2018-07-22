require 'Date'
require 'yaml'
require 'oj'
require_relative '..\Classes\Country.rb'

def ExtractCountryFinancials(old_countries)

### You give this method a Country.JSON and it just pulls out relevant information
### and returns it as an array of country objects. 

	new_countries = Array.new
	
	
	old_countries.each do |tag, old_country|
			if old_country.states.empty?
				next
			end
			
			new_country = Country.new(tag)
			new_country.money = old_country.money
			new_country.year = old_country.year
			new_country.tax_base = old_country.tax_base
			new_country.bank = old_country.bank
			new_country.naval_need = old_country.naval_need
			new_country.land_supply_cost = old_country.land_supply_cost
			new_country.naval_supply_cost = old_country.naval_supply_cost
			new_country.rich_tax = old_country.rich_tax
			new_country.poor_tax = old_country.poor_tax
			new_country.middle_tax = old_country.middle_tax
			new_country.education_spending = old_country.education_spending
			new_country.crime_fighting = old_country.crime_fighting		
			new_country.social_spending = old_country.social_spending	
			new_country.military_spending = old_country.military_spending	
			new_countries.push(new_country)
	end
	
	return new_countries
end
