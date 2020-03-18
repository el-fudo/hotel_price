RSpec.describe HotelPrice::Rakuten::RakutenScraper, type: :class do
  describe "Rakuten Scraper" do
    it "should return review" do
      a1 = HotelPrice::Rakuten::RakutenScraper.review 147780
      expect(a1[0][:comment]).not_to eq nil
    end
  end
end
