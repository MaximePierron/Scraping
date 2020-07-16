#appelle nokogiri pour le scrapping
require 'nokogiri'
#appelle open uri nativement dans ruby pour ouvrir un URL
require 'open-uri'
#page stock l'URL que nokogiri doit scrapper ouvert par open uri

def crypto_scrapper

    page = Nokogiri::HTML(open("https://coinmarketcap.com/all/views/all/"))
    all_crypto = page.xpath('//td[@class="cmc-table__cell cmc-table__cell--sortable cmc-table__cell--left cmc-table__cell--sort-by__symbol"]/div[@class=""]')
    all_crypto_value = page.xpath('//td[@class="cmc-table__cell cmc-table__cell--sortable cmc-table__cell--right cmc-table__cell--sort-by__price"]/a[contains(@href, "markets")]')

    crypto_curr = []
    crypto_curr_value = []

    all_crypto.each do |crypto|
        crypto_curr << crypto.text #stock le text de l'html des symboles de crypto (donc le symbole de crypto) dans un tableau 
    end

    all_crypto_value.each do |value|
        crypto_curr_value << value.text[1..-1].to_f #stock le text de l'html des prix de vente des crypto (donc le prix de vente des crypto) dans un tableau 
    end

    crypto_array_of_hash = crypto_curr.zip(crypto_curr_value).map{|k, v| {k => v}} #réunit ces tableaux en tableau de hash avec en clé la monnaie et en valeur le prix de vente

    puts crypto_array_of_hash.sample(5)
    return crypto_array_of_hash

end