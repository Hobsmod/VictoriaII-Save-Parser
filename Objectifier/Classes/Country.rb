require_relative 'State.rb'
require_relative 'Factory.rb'


class Country
	attr_accessor :year, :tax_base, :tag, :flags, :variables, :capital, :technology, :research,
	:last_election, :date, :ruling_party, :active_parties, :upper_house, :naval_need,
	:land_supply_cost, :naval_supply_cost, :modifiers, :revanchism, :plurality, :rich_tax,
	:middle_tax, :poor_tax, :education_spending, :crime_fighting, :social_spending,
	:military_spending, :overseas_penalty, :leadership, :relations, :active_inventions,
	:illegal_inventions, :primary_culture, :religion, :accepted_cultures, :national_value, 
	:government_flag, :ai, :ai_hard_strategy, :prestige, :schools, :bank, :money, :last_bankrupt,
	:badboy, :tarrifs, :trade_cap_land, :trade_cap_naval, :trade_cap_projects, :max_tarrif,
	:domestic_supply_pool, :domestic_demand_pool, :sold_supply_pool, :actual_sold_domestic,
	:saved_country_supply, :max_bought, :national_focus, :incomes, :expenses, :interesting_countries,
	:suppression, :creditors, :states
	
	def initialize(tag)
		self.tag = tag
		self.variables = Hash.new
		self.flags = Array.new
		self.technology = Hash.new {|h,k| h[k] = Array.new }
		self.research = Hash.new
		self.active_parties = Array.new
		self.upper_house = Hash.new
		self.naval_need = Hash.new
		self.land_supply_cost = Hash.new
		self.naval_supply_cost = Hash.new
		self.modifiers = Hash.new
		self.rich_tax = Hash.new
		self.poor_tax = Hash.new
		self.middle_tax = Hash.new
		self.education_spending = Hash.new
		self.crime_fighting = Hash.new
		self.social_spending = Hash.new
		self.military_spending = Hash.new
		self.relations = Hash.new {|h,k| h[k] = Hash.new }
		self.ai = Hash.new {|h,k| h[k] = Hash.new }
		self.ai_hard_strategy = Hash.new
		self.accepted_cultures = Array.new
		self.bank = Hash.new
		self.domestic_supply_pool = Hash.new
		self.domestic_demand_pool = Hash.new
		self.actual_sold_domestic = Hash.new
		self.sold_supply_pool = Hash.new
		self.saved_country_supply = Hash.new
		self.max_bought = Hash.new
		self.national_focus = Hash.new
		self.creditors = Hash.new {|h,k| h[k] = Hash.new }
		self.states = Hash.new{}
	end
end

