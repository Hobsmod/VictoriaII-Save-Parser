require 'descriptive_statistics'

class GlobalMarketData
	attr_accessor :year, :worldmarket_supply, :supply, :discovered, :sold, 
		:real_demand, :demand, :price_history, :avg_price, :worldmarket_sold
	
	def initialize(year)
		self.year = year
		self.worldmarket_supply = Hash.new
		self.supply = Hash.new
		self.discovered = Hash.new
		self.sold = Hash.new
		self.real_demand = Hash.new
		self.demand = Hash.new
		self.worldmarket_sold = Hash.new
		self.price_history = Hash.new{|hash, key| hash[key] = Hash.new}
	end
	
	
	def calcPriceAvgs()
		price_hash = Hash.new{|hash, key| hash[key] = Array.new}
		self.price_history.each do |year, prices|
			prices.each do |good, value|
				price_hash[good].push(value)
			end
		end
		self.avg_price = Hash.new
		price_hash.each do |key, array|
			avg_price[key] = array.mean
		end
	end
	
	##### Get the prices on the day the save was made, or on any of the previous 14 days
	##### You could just type the dates into price history but this is probably easier. 
	def current_prices(days = 0)
		temp_date = Date.new(2000,1,1) + days
		temp_year = nil
		if temp_date.year == 2000
			temp_year = year.split('.')[0]
		else
			temp_year = year.split('.')[0].to_i - 1
		end
		
		hist_date = temp_year.to_s + '-' + temp_date.mon.to_s + '-' + temp_date.mday.to_s
		return price_history[hist_date]
	end
	
	
	#### Return the Cash Value of all world output using average or current prices
	def getWorldOutput(avg_prices = false)
		world_output = 0
		prices = nil
		
		if avg_prices == true
			prices = self.avg_price
		else
			prices = self.current_prices
		end
		
		self.supply.each do |good, output|
			good_value = self.supply[good] * prices[good]
			world_output = world_output + good_value
		end
		
		return world_output
	end
	
	def getWorldSales(avg_prices = false)
		world_sales = 0
		prices = nil
		
		if avg_prices == true
			prices = self.avg_price
		else
			prices = self.current_prices
		end
		
		self.sold.each do |good, output|
			sales_value = self.sold[good] * prices[good]
			world_sales = world_sales + sales_value
		end
		
		return world_sales
	end
		
		
	def getPrctOutputSold(avg_prices = false)
		prct_sold = self.getWorldSales / self.getWorldOutput
		return prct_sold
	end
		
end

