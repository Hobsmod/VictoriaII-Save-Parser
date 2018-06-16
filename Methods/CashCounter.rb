require 'Date'
require 'yaml'
require_relative '..\Classes\Pop.rb'
require_relative '..\Classes\Province.rb'


save_dir = 'C:\Users\sdras\Documents\Paradox Interactive\Victoria II\save games\madagascar'
time = Time.now

pop_money = Hash.new{}
pop_bank = Hash.new{}
factory_money = Hash.new{}
country_money = Hash.new{}
country_bank = Hash.new{}
country_lent = Hash.new{}

		
Dir.foreach(save_dir) do |savefile|
	puts "started file"
	date = 0
	pops = true
	countries = false
	factory = false
	open_count = 0
	
	
	if savefile.to_s.length < 3
		next
	end
	
	
	
	### Get the Date!	

	File.open(save_dir + "\\" + savefile).each do |line|
		if line =~ /date/
			line.gsub! /\n/, ''
			splitline = line.split('=')
			date = splitline[1].gsub!(/\A"|"\Z/, '')
		end
			
		break unless date == 0
	end
	
	puts date	
	
	#### Begin Counting that sweet cash
	File.open(save_dir + "\\" + savefile).each do |line|
		
		#### Until the first instance of the string 'tax_base' we are assumed to be parsing pops
		unless pops == false
			if line =~ /tax_base/
				pops = false
				countries = true
				next
			end
		end
		
		
		
		if pops == true
			#### if we have money=d add that to the pop_instance
			if line =~ /\A\t\tmoney=\d{1,}/
				split_line = line.split('=')
				if pop_money.key?(date)
					pop_money[date] = pop_money[date].to_f + split_line[1].to_f
				else
					pop_money[date] = split_line[1].to_f
				end
				next
			end
			
			#### if we have bank=d add that to the pop_instance
			if line =~ /\A\t\tbank=\d{1,}/
				split_line = line.split('=')
				if pop_bank.key?(date)
					pop_bank[date] = pop_bank[date].to_f + split_line[1].to_f
				else
					pop_bank[date] = split_line[1].to_f
				end
				next
			end
		end
		
		### While we are parsing factories we have to count open parens
		if countries == true
			if factory == true
				if line =~ /\{/
					open_count = open_count + 1
					next
				end
				
				if line =~ /\}/
					open_count = open_count - 1
					
					if open_count == 0
						factory = false
					end
					next
				end
			end
			
			### If we see the line state_buildings we are parsing factories
			if line =~ /\A\t\tstate_buildings=/
				factory = true
				open_count = 0
				next
			end
			
			if line =~ /money\=/ && factory == false
				split_line = line.split('=')
				if country_money.key?(date)
					country_money[date] = country_money[date].to_f + split_line[1].to_f
				else
					country_money[date] = split_line[1].to_f
				end
			end
			
			if line =~ /money_lent\=/ && factory == false
				split_line = line.split('=')
				if country_money.key?(date)
					country_lent[date] = country_lent[date].to_f + split_line[1].to_f
				else
					country_lent[date] = split_line[1].to_f
				end
			end
			
			
			if line =~ /bank\=/ && factory == false
				split_line = line.split('=')
				if country_bank.key?(date)
					country_bank[date] = country_bank[date].to_f + split_line[1].to_f
				else
					country_bank[date] = split_line[1].to_f
				end
			end
			
			
			if line =~ /money\=/ && factory == true
				split_line = line.split('=')
				if country_bank.key?(date)
					country_bank[date] = country_bank[date].to_f + split_line[1].to_f
				else
					country_bank[date] = split_line[1].to_f
				end
			end
		end
			
			

	end
	
	puts "finished file"
end

File.write('FactoryCash.yml', factory_money.to_yaml)
File.write('PopCash.yml', pop_money.to_yaml)
File.write('CountryCash.yml', country_money.to_yaml)
File.write('PopBank.yml', pop_bank.to_yaml)
File.write('Country_Bank.yml', country_bank.to_yaml)
