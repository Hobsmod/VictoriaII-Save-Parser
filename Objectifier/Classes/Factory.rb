class Factory
	attr_accessor :type, :level, :stockpile, :employees, :money,
	:last_spending, :last_income, :pops_paychecks, :last_investment,
	:unprofitable_days, :leftover, :injected_money, :injected_days,
	:produces, :profit_history_days, :profit_history_current, 
	:profit_history_entry, :construction_time_left, :employee_prov_id,
	:subsidised, :profit_history_arr
	
	
	def initialize(type)
		self.type = type
		self.stockpile = Hash.new
		self.employees = Array.new
	end
end

class Employees
	attr_accessor :type, :index, :province, :count
	
	def initialize(province, index)
		self.province = province
		self.index = index
	end
end