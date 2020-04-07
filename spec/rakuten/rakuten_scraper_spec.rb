RSpec.describe HotelPrice::Rakuten::RakutenScraper, type: :class do
  describe "Rakuten Scraper" do
    it "should return review" do
      a1 = HotelPrice::Rakuten::RakutenScraper.review 147780
      expect(a1[0][:comment]).not_to eq nil
    end

    it "should return photos number" do
      a1 = HotelPrice::Rakuten::RakutenScraper.get_photo_num 147780
      expect(a1).to be_an(Integer)
    end

    it "should return breakfast plans number" do
      a1 = HotelPrice::Rakuten::RakutenScraper.get_bf_plan_num 147780
      p a1
      expect(a1).to be_an(Integer)
    end
  end
end
