RSpec.describe HotelPrice do

  it "has a version number" do
    expect(HotelPrice::VERSION).not_to be nil
  end

  describe "Rakuten Travel Review" do
    ## Scraper Test
    # it "Get All Reviews" do
    #   a1 = HotelPrice::RakutenTravel.review "128552"
    #   expect(a1[0][:rakuten_hotel_id]).to eq "128552"
    # end
  end

  describe "Rakuten Travel API" do
    before(:each) do
      @a1 = HotelPrice::RakutenTravel::RakutenAPI.new(
        rakuten_hotel_id: "128552"
      )
    end

    it "Test" do
      expect(@a1.test[:rakuten_hotel_id]).to eq "128552"
    end

    it "Get Hotel Info by rakuten hotel id" do
      expect(@a1.hotel_info[:rakuten_hotel_id].to_s).to eq "128552"
    end
  end


  describe "Rakuten Travel Console" do
    before(:each) do
      @a1 = HotelPrice::RakutenTravel::RakutenConsole.new(
        login_id: "login-id",
        login_pw: "login-pw",
        rakuten_hotel_id: "128552",
        chain: false,
      )
    end

    it "Test" do
      expect(@a1.test[:rakuten_hotel_id]).to eq "128552"
    end
  end

  describe "Jalan Class" do
    before(:each) do
      api_key = "sco16771cc4c29"
      @a1 = HotelPrice::Jalan::JalanAPI.new api_key
    end

  
    it "Test" do
      p @a1.test
      expect(@a1.test[:jalan_hotel_id]).to eq "128552"
    end
  
  end
end
