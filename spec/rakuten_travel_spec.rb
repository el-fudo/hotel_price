RSpec.describe RakutenTravel do
  it "get hotel info" do
    a1 = RakutenTravel.hotel_info 7770
    expect(a1).not_to eq nil
  end
end
