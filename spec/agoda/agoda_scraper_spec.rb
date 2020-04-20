RSpec.describe HotelPrice::Agoda::AgodaScraper, type: :class do
  describe "Agoda Scraper" do

    it "should get price" do
      a1 = HotelPrice::Agoda::AgodaScraper.get_price("hotel-sunroute-new-sapporo/hotel/sapporo-jp", "17-04-2020", 1, 0)
      puts a1
      expect(a1).to be >= 0
    end
  end
end
