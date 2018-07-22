require 'descriptive_statistics'


class Factory
	attr_accessor :type, :level, :stockpile, :employees, :money,
	:last_spending, :last_income, :pops_paychecks, :last_investment,
	:unprofitable_days, :leftover, :injected_money, :injected_days,
	:produces, :profit_history_days, :profit_history_current, 
	:profit_history_entry, :construction_time_left, :employee_prov_id,
	:subsidised, :profit_history_arr, :date, :avg_profit, :total_employees
	
	
	def initialize(type)
		self.type = type
		self.stockpile = Hash.new
		self.employees = Array.new
	end
	
	def calcAvgProfit()
		self.avg_profit = profit_history_arr.mean
		return profit_history_arr.mean
	end
	
	def calcTotalEmployees
		total_emp = 0
		self.employees.each do |this_emp|
			total_emp = total_emp + this_emp.count
		end
		self.total_employees = total_emp
		return total_emp
	end
	
	def setUnsub
		unless self.subsidised == true
			self.subsidised = false
		end
	end
end

class Employees
	attr_accessor :type, :index, :province, :count
	
	def initialize(province, index)
		self.province = province
		self.index = index
	end
end