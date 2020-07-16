#appelle nokogiri pour le scrapping
require 'nokogiri'
#appelle open uri nativement dans ruby pour ouvrir un URL
require 'open-uri'

def get_deputy_email (deputy_url)
    email_html = deputy_url.xpath('//section[1]/div/article/div[3]/div/dl/dd[4]/ul/li[2]/a').text #l'adresse mail des députés se trouvent sur ce xpath pour chaque url de député et on en prend que le texte
end



def get_deputies_info (name_list_url)
   
    name_list = []
    first_name = []
    last_name = []
    deputy_url = []
    mail_adress = []
    key = []
    deputy_contact_info_hash = []
    i=0
    #récupère tous les liens où on trouve "/deputes/fiche/OMC" dans le href
    name_list_html = name_list_url.xpath('//a[contains(@href, "/deputes/fiche/OMC")]') 
    #récupère la valeur du href dans tous les liens où on trouve "/deputes/fiche/OMC" dans le href = la partie à changer dans les url pour accéder au profil du député
    href_value = name_list_url.xpath('//a[contains(@href, "/deputes/fiche/OMC")]/@href') 

    name_list_html.each do |name|
        name_list << name.text[/(?<=\s).*/] #produit une liste des noms à partir des html en récupérant seulement le texte
    end

    for item in name_list #dans chaque element de la liste des noms textes
        if item[/(\p{L}+\-\p{L}+)(?=\s)/].nil? #si le format de selection "lettres-lettres espace ensuite" ne ressort rien
            first_name << item[/(\p{L}+)(?=\s)/] #c'est que le prénom a un format lettres espace ensuite
        else
            first_name << item[/(\p{L}+\-\p{L}+)(?=\s)/] #ou alors c'est que le prénom a un format "lettres-lettres espace ensuite"
        end
    end

    for item in name_list
        if item[/(?<=\s)(\p{L}+\-\p{L}+)/].nil? && item[/(?<=\s)(\p{L}+\ \p{L}+)/].nil? #si ni le format "espace avant lettres-lettres" ni "espace avant lettres espace lettres" ne donnent qqch
            last_name << item[/(?<=\s)(\p{L}+)/] #le nom de famille a la forme "espace avant lettres"
        elsif item[/(?<=\s)(\p{L}+\-\p{L}+)/].nil? && item[/(?<=\s)(\p{L}+\ \p{L}+)/].nil? == false #si le format "espace avant lettres-lettres" ne donne rien mais "espace avant lettres espace lettres" oui
            last_name << item[/(?<=\s)(\p{L}+\ \p{L}+)/] #le nom de famille a la forme "espace avant lettres espace lettres"
        else            
            last_name << item[/(?<=\s)(\p{L}+\-\p{L}+)/] #sinon le nom de famille a la forme "espace avant lettres-lettres"
        end
    end

    deputy_name_hash = first_name.zip(last_name).map{|k, v| {"first_name" =>k, "last_name" => v}} #on hash prénom nom

    for item in href_value
        deputy_url << "http://www2.assemblee-nationale.fr#{item}" #on récupère les urls des pages de tous les députés en implémentant le href sur la base commune de l'url
    end

    for item in deputy_url.take(5) #pour chaque url de député

        number = deputy_url.length #longueur de la liste
        still_to_go = (number - i) #nombre restant à instant t

        if get_deputy_email(Nokogiri::HTML(open(item))) == "" #si la méthode retourne un string vide
            mail_adress << "no address" #alors on remplace le vide
        else
            mail_adress << get_deputy_email(Nokogiri::HTML(open(item))) #sinon on prend le string
        end

        key << "email" #on remplit un array de valeur email
        puts "Still #{still_to_go} addresses" #on affiche cb d'adresse reste à scraper
        i += 1

    end

    email_hash = key.zip(mail_adress).map{|k, v| {k => v}}.take(5) #on hash array email et adresse email

    for j in 0...5#(deputy_name_hash.size)
        deputy_contact_info_hash << deputy_name_hash[j].merge(email_hash[j]) #on merge les hash des deux arrays de hash et on le stocke dans un array de hash
    end

    return deputy_contact_info_hash

end