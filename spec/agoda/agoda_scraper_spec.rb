RSpec.describe HotelPrice::Agoda::AgodaScraper, type: :class do
  describe "Agoda Scraper" do

    it "should get price" do
      a1 = HotelPrice::Agoda::AgodaScraper.get_price("hotel-sunroute-new-sapporo/hotel/sapporo-jp", "24-07-2020", 2)
      expect(a1[:min_price]).to be >= 0
    end
  end
end
