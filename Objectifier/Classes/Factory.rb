class Factory
	attr_accessor :type, :level, :stockpile, :employees, :money,
	:last_spending, :last_income, :pops_paychecks, :last_investment,
	:unprofitable_days, :leftover, :injected_money, :injected_days,
	:produces, :profit_history_days, :profit_history_current, 
	:profit_history_entry, :construction_time_left
	
	def initialize(type)
		self.type = type
		self.stockpile = Hash.new
		#self.employees = Hash.new
		#self.profit_history_entry = Array.new()
	end
end