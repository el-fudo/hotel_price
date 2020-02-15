RSpec.describe HotelPrice::Agoda::AgodaAPI, type: :class do
  describe "Agoda API" do
    before(:each) do
      api_key = ENV["AGODA_KEY"]
      @a1 = HotelPrice::Agoda::AgodaAPI.new api_key
    end

    it "should get api_key" do
      expect(@a1.instance_variable_get(:@api_key)).to eq ENV["AGODA_KEY"]
    end
  end
end
