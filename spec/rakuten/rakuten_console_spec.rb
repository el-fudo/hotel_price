RSpec.describe HotelPrice::Rakuten::RakutenConsole, type: :class do
  describe "Rakuten Travel Console" do
    before(:each) do
      @a1 = HotelPrice::Rakuten::RakutenConsole.new(
        login_id: "login-id",
        login_pw: "login-pw",
        rakuten_hotel_id: "128552",
        chain: false,
      )
    end

    it "should set Rakuten hotel ID" do
      expect(@a1.instance_variable_get(:@config)[:rakuten_hotel_id]).to eq "128552"
    end
  end
end
