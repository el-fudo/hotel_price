RSpec.describe HotelPrice do

  it "has a version number" do
    expect(HotelPrice::VERSION).not_to be nil
  end

  describe "Rakuten Travel API" do
    before(:each) do
      @config = {
        rakuten_hotel_id: "7770"
      }
      @a1 = HotelPrice::RakutenTravel::RakutenAPI.new @config
    end

    it "Test" do
      expect(@a1.test).to eq @config
    end

    it "Get Hotel Info by rakuten hotel id" do
      expect(@a1.hotel_info[:rakuten_hotel_id].to_s).to eq @config[:rakuten_hotel_id].to_s
    end
  end

  describe "Rakuten Travel Console" do
    before(:each) do
      @config = {
        login_id: "login-id",
        login_pw: "login-pw",
        chain: true,
        rakuten_hotel_id: "7770"
      }
      @a1 = HotelPrice::RakutenTravel::RakutenConsole.new @config
    end

    it "Test" do
      expect(@a1.test).to eq @config
    end
  end

  describe "Jalan Class" do
    before(:each) do
      @config = {
        login_id: "login-xx",
        login_pw: "pass-yy",
        chain: true,
        jalan_hotel_id: "7770"
      }
      @a1 = HotelPrice::Jalan::JalanConsole.new @config
    end

  
    it "Test" do
      expect(@a1.test).to eq @config
    end
  
  end
end
