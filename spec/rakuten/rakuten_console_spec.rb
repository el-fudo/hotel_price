RSpec.describe HotelPrice::Rakuten::RakutenConsole, type: :class do
  describe "Rakuten Travel Console" do
    before(:each) do
      @rakuten_hotel_id = "68565"
      @a1 = HotelPrice::Rakuten::RakutenConsole.new(
        login_id: ENV["RT_LOGIN"],
        login_pw: ENV["RT_PW"],
        rakuten_hotel_id: @rakuten_hotel_id,
        chain: true
      )
    end

    it "should set Rakuten hotel ID" do
      expect(@a1.instance_variable_get(:@config)[:rakuten_hotel_id]).to eq @rakuten_hotel_id
    end

    it "should return plan number" do
      expect(@a1.get_plan_num).to be_an(Integer)
    end

  end
end
