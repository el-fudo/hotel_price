RSpec.describe HotelPrice::Booking::BookingScraper, type: :class do
  describe "Booking Scraper" do

    it "should return integer" do
      a1 = HotelPrice::Booking::BookingScraper.get_price("sunroute-sapporo", "24-07-2020", 2)
      p a1
      expect(a1[:min_price]).to be >= 0
    end
  end
end
