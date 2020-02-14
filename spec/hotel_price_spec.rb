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
      @a1 = HotelPrice::Rakuten::RakutenAPI.new(
        rakuten_hotel_id: "128552"
      )
    end

    it "Test" do
      expect(@a1.instance_variable_get(:@config)[:rakuten_hotel_id]).to eq "128552"
    end
  end

end
