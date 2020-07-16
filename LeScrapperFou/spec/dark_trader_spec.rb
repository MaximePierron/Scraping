require_relative '../lib/dark_trader'

describe "the crypto scrapper method" do
    it "does not return a nil " do
        expect(crypto_scrapper).not_to be_nil
    end
    it "must be an array of reasonable size" do
        expect(crypto_scrapper.length).to be >50
    end
    it "must be an array that contains Bitcoin entry" do
        expect(crypto_scrapper.any? {|h| h[0] == "BTC" && h[1].is_a?(Float) }).to be true
    end
end