RSpec.describe HotelPrice::Rakuten::RakutenAPI, type: :class do
  describe "Rakuten API" do
    before(:each) do
      @a1 = HotelPrice::Rakuten::RakutenAPI.new(
        rakuten_hotel_id: "19908",
        rakuten_api_key: ENV["RT_API_KEY"]
      )
    end

    it "should set Rakuten hotel ID" do
      expect(@a1.instance_variable_get(:@config)[:rakuten_hotel_id]).to eq "147780"
    end

    it "should get hotel info" do
      expect(@a1.hotel_info[:rakuten_hotel_id]).to eq 147780
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
      params = {
        middle_class_code: "nagasaki",
        small_class_code: "nagasaki",
        detail_class_code: "",
        page_num: 1
      }
      result = @a1.search_ranking(params)
      expect(result[:status]).to eq("found") | eq("not_found")
    end
  end
end
