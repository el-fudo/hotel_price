RSpec.describe HotelPrice::Jalan::JalanAPI, type: :class do
  describe "Jalan API" do
    before(:each) do
      api_key = "sco16771cc4c29"
      @a1 = HotelPrice::Jalan::JalanAPI.new api_key
    end
    it "should get api_key" do
      expect(@a1.instance_variable_get(:@api_key))
    end
  end
end
