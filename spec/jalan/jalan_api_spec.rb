RSpec.describe HotelPrice::Jalan::JalanAPI, type: :class do
  describe "Jalan API" do
    before(:each) do
      api_key = ENV["JALAN_KEY"]
      @a1 = HotelPrice::Jalan::JalanAPI.new api_key
    end
    it "should get api_key" do
      expect(@a1.instance_variable_get(:@api_key))
    end
  end
end
