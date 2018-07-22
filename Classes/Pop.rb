class Pop
	attr_accessor  :id, :prov_id, :size, :money, :con, :mil, :lit, :ideology,
	:life_needs, :every_needs, :lux_needs, :bank, :issues, :religion, :culture, :type,
	:con_factor, :promoted, :demoted, :converted, :last_spending, :current_producing, :percent_afforded,
	:percent_sold_domestic, :percent_sold_export, :leftover, :throttle, :needs_cost,
	:production_income, :date, :days_of_loss, :owner, :rgo_type
		
	def initialize(id)
		self.id = id
		self.ideology = Hash.new
		self.issues = Hash.new
	end
	
	
end