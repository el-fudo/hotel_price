RSpec.describe HotelPrice::Agoda::AgodaScraper, type: :class do
  describe "Agoda Scraper" do

    it "should get price" do
      a1 = HotelPrice::Agoda::AgodaScraper.get_price(20)
      expect(a1).to eq true
    end
  end
end
