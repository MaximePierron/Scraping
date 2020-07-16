require_relative '../lib/cher_depute'

describe "the deputy_email method" do
    it "does not return a nil " do
        address = Nokogiri::HTML(open("http://www2.assemblee-nationale.fr/deputes/fiche/OMC_PA720334"))
        expect(get_deputy_email(address)).not_to be_nil
    end
end

describe "the townhall_emails method" do
    it "does not return a nil " do
        address = Nokogiri::HTML(open("http://www2.assemblee-nationale.fr/deputes/liste/alphabetique"))
        expect(get_deputies_info(address)).not_to be_nil
    end
    it "must be an array of reasonable size" do
        address = Nokogiri::HTML(open("http://www2.assemblee-nationale.fr/deputes/liste/alphabetique"))
        expect(get_deputies_info(address).length).to be >4
    end
    it "must be an array that contains a city name entry and the email address to be a string" do
        address = Nokogiri::HTML(open("http://www2.assemblee-nationale.fr/deputes/liste/alphabetique"))
        expect(get_deputies_info(address).any? {|h| h["last_name"].include?("Abad") && h["email"].is_a?(String)}).to be true
    end

    it "must return hashes value shapes as email address" do
        address = Nokogiri::HTML(open("http://www2.assemblee-nationale.fr/deputes/liste/alphabetique"))
        expect(get_deputies_info(address).any? {|e| e["email"].include?("@")}).to be true
    end
end