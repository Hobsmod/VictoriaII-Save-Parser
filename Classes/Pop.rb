class Pop
	attr_accessor  :id, :prov_id, :size, :money, :con, :mil, :lit, :ideology,
	:life_needs, :every_needs, :lux_needs, :bank, :issues, :religion, :culture, :type,
	:con_factor, :promoted, :demoted, :converted, :date, :days_of_loss, :owner, :rgo_type,
	:artisan_production
		
	def initialize(id)
		self.id = id
		self.ideology = Hash.new
		self.issues = Hash.new
	end
end



class ArtisanProduction
	attr_accessor :type, :stockpile, :need, :last_spending, :current_producing,
	:percent_afforded, :percent_sold_domestic, :percent_sold_export, :leftover, :throttle, :needs_cost,
	:production_income
	
	def initialize(type)
		self.type = type
		self.stockpile = Hash.new
		self.need = Hash.new
	end
	
end