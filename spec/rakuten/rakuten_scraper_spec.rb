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
      expect(a1).to be_an(Integer)
    end

    it "should return dayuse plans number" do
      a1 = HotelPrice::Rakuten::RakutenScraper.get_dayuse_plan_num 147780
      expect(a1).to be_an(Integer)
    end

    it "should return detail class code" do
      a1 = HotelPrice::Rakuten::RakutenScraper.get_detail_class_code 173011
      expect(a1[:status]).to eq("found") | eq("not_found")
    end

    it "should return min price" do
      a1 = HotelPrice::Rakuten::RakutenScraper.get_price("173011", (Date.today + 45.day).to_s, 1)
      expect(a1[:min_price]).to be_a Integer
    end

  end
end
