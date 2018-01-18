require 'rubygems'
require 'nokogiri'
require 'open-uri'

page_of_all_towns = Nokogiri::HTML(open("http://annuaire-des-mairies.com/val-d-oise.html"))

#La méthode qui suit renvoie l'adresse mail d'une municapalité a partir de l'url
def get_the_email_of_a_townhal_from_its_webpage(page)
	email = page.css("td.style27")[5]
	email2 = email.css("p")
	email3 = email2.text
	return email3
end

#La méthode qui suit renvoie l'adresse url de chaque ville sous la forme d'un array
def get_page_of_all_towns_url(page_of_all_towns)
	
	list_of_towns_url = []	
	page_of_all_towns.xpath("//td/p/a").each do |node|
	town_link = node["href"]
	town_link.slice!(0)
	town_link = "http://annuaire-des-mairies.com" + town_link
	list_of_towns_url.push(town_link)
	end
	return list_of_towns_url
end

#La méthode qui suit renvoie l'ensemble des noms des municipalités sous la forme d'un array
def get_page_of_all_towns_names(page_of_all_towns)
	list_of_towns_names = []	
	page_of_all_towns.xpath("//td/p/a").each do |node|
	list_of_towns_names.push(node.text.downcase!)
	end
	return list_of_towns_names
end



list_of_towns_url = get_page_of_all_towns_url(page_of_all_towns) #appel de la fonction get_page_of_all_towns_url et stockage des adresses url dans la variable list_of_towns_url
list_of_towns_names = get_page_of_all_towns_names(page_of_all_towns) #appel de la fonction get_page_of_all_towns_names et stockage des noms des villes dans la variable list_of_towns_names
list_of_towns_mails = []




town_hash = Hash.new
compteur = 0

#La boucle suivante crée le hash avec l'adresse 
while compteur < list_of_towns_names.length
	
	page_adress = list_of_towns_url[compteur]
	page_adress = page_adress.to_s
	page1 = Nokogiri::HTML(open(page_adress))
	town_hash[list_of_towns_names[compteur]] = get_the_email_of_a_townhal_from_its_webpage(page1)
	list_of_towns_mails.push(get_the_email_of_a_townhal_from_its_webpage(page1))
	compteur += 1
end

puts "\n\nCe script affiche l'adresse email des municipalités du Val d'Oise.\nVoici la liste des noms des municipalités :"
puts "Appuyez sur entrer pour continuer\n"
input_user = gets

compteur = 0
while compteur < list_of_towns_names.length
	puts (" #{compteur+1} - " + list_of_towns_names[compteur].capitalize!)
	compteur += 1
end

loop do #La boucle relance le choix d'une ville jusqu'à ce que l'utilisateur entre h ou q
print "Veuillez entrer le numéro d'une municipalité : "
user_choice = gets
user_choice = user_choice.to_i - 1
break if user_choice == -1
puts "L'adresse email de la ville de #{list_of_towns_names[user_choice]} est : #{list_of_towns_mails[user_choice]}"
puts "Appuyer sur '200' pour afficher la totalité du hash des noms et des emails des villes"
puts "Appuyer sur '0' pour quitter"
puts town_hash if user_choice == 199
end
