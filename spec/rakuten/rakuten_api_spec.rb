RSpec.describe HotelPrice::Rakuten::RakutenAPI, type: :class do
  describe "Rakuten API" do
    before(:each) do
      @a1 = HotelPrice::Rakuten::RakutenAPI.new(
        rakuten_hotel_id: "172261",
        rakuten_api_key: ENV["RT_API_KEY"]
      )
    end

    it "should set Rakuten hotel ID" do
      expect(@a1.instance_variable_get(:@config)[:rakuten_hotel_id]).to eq "19908"
    end

    it "should get hotel info" do
      expect(@a1.hotel_info[:rakuten_hotel_id]).to eq 19908
    end

    it "should get min price" do
      ## Change date or rakuten_hotel_id if there is no data.
      rakuten_hotel_id = "147780"
      checkin_date = (DateTime.now + 30).strftime("%Y-%m-%d")
      num_adults = 2
      result = @a1.get_price(rakuten_hotel_id, checkin_date, num_adults)
      expect(result[:checkin_date]).to eq checkin_date
    end

    it "should get page ranking" do
      page_num = 1
      result = @a1.search_ranking page_num
      expect(result[:status]).to eq("found") | eq("not_found")
    end

    it "should get page num" do
      result = @a1.get_page_num
      expect(result[:page_num]).to be >= 0
    end

    it "should return area rank" do
      result = @a1.get_area_rank
      expect(result[:status]).to eq("found") | eq("not_found")
    end
  end
end
