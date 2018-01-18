=begin
Ce script génère une hash dans lequel sont stockés l'ensemble des monnaies et leurs cours respectifs
Le script est relancé toutes les trois secondes et génère un nouveau hash avec les nouveaux cours
Il est possible de faire tourner la boucle indéfiniement avec un loop mais pour l'exercice j'ai préféré utiliser 10.times et éviter la boucle infinie ;)
=end
require 'rubygems'
require 'nokogiri'
require 'open-uri'

trading_page_url = Nokogiri::HTML(open("https://coinmarketcap.com/all/views/all/"))


#La méthode suivante retourne la liste des cours
def get_list_of_share_prices(trading_page_url)
	list_of_share_prices = []	
	trading_page_url.xpath("//tr/td/a[@class='price']").each do |node|
		share_price = node["data-usd"]
		
		if share_price == nil
		else
			list_of_share_prices.push(share_price)
		end
	end
	return list_of_share_prices
end

#La méthode suivante retourne la liste des monnaies
def get_name_of_each_currency(trading_page_url)
	list_of_currencies = []
	trading_page_url.xpath('//a[@class="currency-name-container"]').each do |node|
		list_of_currencies.push(node.text)
	end
	return list_of_currencies
end


#La boucle suivante tourne 10 fois avec une pause de 3 secondes entre chaque itération
10.times do
list_of_currencies = get_name_of_each_currency(trading_page_url)
list_of_share_prices = get_list_of_share_prices(trading_page_url)

hash_of_currencies_share_prices = Hash.new

compteur = 0
while compteur < list_of_currencies.length
	hash_of_currencies_share_prices[list_of_currencies[compteur]] = list_of_share_prices[compteur]
	compteur += 1
end
print hash_of_currencies_share_prices

sleep(3)
end