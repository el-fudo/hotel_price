module HotelPrice::Jalan
  class JalanAPI
    def initialize api_key
      @api_key = api_key
    end

    def test
      @api_key
    end

    def get_price
      if @doc.css("NumberOfResults").text == "0"
        {
          date: DateTime.now.strftime("%Y-%m-%d"),
          branch_id: @user_info[:branch_id],
          stay_date: @user_info[:checkindate],
          adult_num: @user_info[:adult_num],
          jalan_hotel_id: @user_info[:jalan_hotel_id],
          plan_num: 0,
          min_price: 0
        }
      else
        {
          date: DateTime.now.strftime("%Y-%m-%d"),
          branch_id: @user_info[:branch_id],
          channel: "jalan",
          stay_date: @user_info[:checkindate],
          adult_num: @user_info[:adult_num],
          jalan_hotel_id: @user_info[:jalan_hotel_id],
          hotel_name: @doc.css("Plan").css("Hotel HotelName").text,
          room_name: @doc.css("Plan").css("RoomName").text,
          plan_name: @doc.css("Plan").css("PlanName").text,
          plan_num: @doc.css("NumberOfResults").text,
          min_price: @doc.css("Plan").css("Stay Rate").text
        }
      end
    end
  end
end