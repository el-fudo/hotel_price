RSpec.describe HotelPrice::Jalan::JalanScraper, type: :class do
  describe "Jalan Scraper" do
    it "should return min price" do
      a1 = HotelPrice::Jalan::JalanScraper.get_price("366371", (Date.today + 45.day).to_s, 1)
      expect(a1[:min_price]).to be_a Integer
    end
  end
end
