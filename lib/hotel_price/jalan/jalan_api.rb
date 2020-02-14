module HotelPrice::Jalan
  class JalanAPI
    def initialize api_key
      @api_key = api_key
    end

    def test
      @api_key
    end

    def get_price jalan_hotel_id, checkin_date, adult_num
      url = "http://jws.jalan.net/APIAdvance/StockSearch/V1/?key=#{@api_key}&h_id=#{jalan_hotel_id}&stay_date=#{checkin_date}&stay_count=1&adult_num=#{adult_num}&count=1"
      puts url
      doc = Nokogiri::XML(open(url))
      if doc.css("NumberOfResults").text == "0"
        {
          date: DateTime.now.strftime("%Y-%m-%d"),
          plan_num: 0,
          min_price: 0
        }
      else
        {
          date: DateTime.now.strftime("%Y-%m-%d"),
          hotel_name: doc.css("Plan").css("Hotel HotelName").text,
          room_name: doc.css("Plan").css("RoomName").text,
          plan_name: doc.css("Plan").css("PlanName").text,
          plan_num: doc.css("NumberOfResults").text,
          min_price: doc.css("Plan").css("Stay Rate").text
        }
      end
    end
  end
end