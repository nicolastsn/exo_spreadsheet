require 'bundler'
Bundler.require

require 'rubygems'
require 'nokogiri'
require 'open-uri'
TOWN_URL = "http://annuaire-des-mairies.com/95/vaureal.html"
VAL_DOISE_URL = "http://annuaire-des-mairies.com/val-d-oise.html"


def get_the_email_of_a_townhal_from_its_webpage(url)
	page = Nokogiri::HTML(open(url))
	email = page.xpath('//table/tr[3]/td/table/tr[1]/td[1]/table[4]/tr[2]/td/table/tr[4]/td[2]/p/font')
	#puts email.text
	email.text
end

def get_all_the_urls_of_val_doise_townhalls(url)
	towns_mail_list = Hash.new()
	page = Nokogiri::HTML(open(url))
	page.xpath('//table/tr[2]/td/table/tr/td/p/a').each do |town|
		town_name = town.text.downcase
		proper_town_name = town_name.capitalize
		town_name = town_name.split(' ').join('-')
		url = "http://annuaire-des-mairies.com/95/#{town_name}.html"
		towns_mail_list[proper_town_name.to_sym] = get_the_email_of_a_townhal_from_its_webpage(url)
	end
	towns_mail_list.each do |key, value|
			puts "#{key}: #{value} "


			# Authenticate a session with your Service Account
session = GoogleDrive::Session.from_service_account_key("client_secret.json")

# Get the spreadsheet by its title
spreadsheet = session.spreadsheet_by_title("spreadsheet_mairies")
# Get the first worksheet
worksheet = spreadsheet.worksheets.first
# Print out the first 6 columns of each row
worksheet.rows.each { |row| puts row.first(2).join(" | ") }


worksheet.insert_rows(worksheet.num_rows + 1, [["#{key}", "#{value}"]])
worksheet.save


	end
end
get_all_the_urls_of_val_doise_townhalls("http://annuaire-des-mairies.com/val-d-oise.html")






