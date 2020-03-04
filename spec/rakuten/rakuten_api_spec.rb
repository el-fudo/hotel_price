RSpec.describe HotelPrice::Rakuten::RakutenAPI, type: :class do
  describe "Rakuten API" do
    before(:each) do
      @a1 = HotelPrice::Rakuten::RakutenAPI.new(
        rakuten_hotel_id: "147780",
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
      params = {
        checkin_date: (DateTime.now + 45).strftime("%Y-%m-%d"),
        breakfast: "",
        adult_num: 1
      }
      result = @a1.get_min_price(params)
      expect(result[:checkin_date]).to eq params[:checkin_date]
    end
  end
end
