module HotelPrice::Rakuten
  class RakutenAPI
    def initialize params
      @config = {
        rakuten_hotel_id: params[:rakuten_hotel_id] ||= 0,
        rakuten_api_key: params[:rakuten_api_key] ||= ENV["RT_API_KEY"]
      }
    end

    def get_min_price params
      params[:breakfast] ||= ""
      try = 0
      begin
        base_url = "https://app.rakuten.co.jp/services/api/Travel/VacantHotelSearch/20131024?format=json&sort=%2BroomCharge&searchPattern=1"
        url = [base_url, "&applicationId=", @config[:rakuten_api_key], "&adultNum=", params[:adult_num].to_s, "&checkinDate=", params[:checkin_date].to_s, "&checkoutDate=", (Date.parse(params[:checkin_date]) + 1).strftime("%Y-%m-%d"), "&hotelNo=", @config[:rakuten_hotel_id].to_s, "&squeezeCondition=", params[:breakfast]].join
        json = Net::HTTP.get(URI.parse(url))
        result = JSON.parse(json)
        try = 0
        begin
          data_hash = if result["error"] == "not_found"
                        {
                          date: DateTime.now.strftime("%Y-%m-%d"),
                          checkin_date: params[:checkin_date],
                          rakuten_hotel_id: params[:rakuten_hotel_id],
                          adult_num: params[:adult_num],
                          breakfast: params[:breakfast],
                          plan_num: 0,
                          min_price: 0
                        }
                      elsif result["error"] == "wrong_parameterd"
                        "入力した値が正しくありません。"
                      else
                        {
                          date: DateTime.now.strftime("%Y-%m-%d"),
                          checkin_date: result["hotels"][0]["hotel"][1]["roomInfo"][1]["dailyCharge"]["stayDate"],
                          rakuten_hotel_id: params[:rakuten_hotel_id],
                          hotel_name: result["hotels"][0]["hotel"][0]["hotelBasicInfo"]["hotelName"],
                          adult_num: params[:adult_num],
                          breakfast: params[:breakfast],
                          plan_num: result["pagingInfo"]["recordCount"],
                          room_name: result["hotels"][0]["hotel"][1]["roomInfo"][0]["roomBasicInfo"]["roomName"],
                          plan_name: result["hotels"][0]["hotel"][1]["roomInfo"][0]["roomBasicInfo"]["planName"],
                          min_price: result["hotels"][0]["hotel"][1]["roomInfo"][1]["dailyCharge"]["rakutenCharge"]
                        }
                      end
        rescue StandardError => e
          try += 1
          sleep 2
          puts "エラー発生。リトライします。\n #{e.message}"
          retry if try < 5
        end
      rescue StandardError => e
        try += 1
        sleep 5
        retry if try < 5
      end
      data_hash
    end

    def hotel_info
      uri = URI.parse("https://app.rakuten.co.jp/services/api/Travel/HotelDetailSearch/20131024?hotelNo=" + @config[:rakuten_hotel_id].to_s + "&applicationId=" + @config[:rakuten_api_key].to_s + "&datumType=1&responseType=large")
      json = Net::HTTP.get(uri)
      @result = JSON.parse(json)
      return "ホテル情報がありませんでした。" if @result["error"] == "not_found"
      return @result["error_description"] if @result["error"] == "wrong_parameter"
      @result["hotels"][0].each do |_key, field|
        field[0].each do |_, value|
          @data_hash = {
            rakuten_hotel_id: value["hotelNo"],
            hotel_name: value["hotelName"],
            room_price_min: value["hotelMinCharge"],
            lat: value["latitude"],
            lon: value["longitude"],
            tel: value["telephoneNo"],
            zip_code: value["postalCode"],
            prefecture: value["address1"],
            address1: value["address2"],
            fax: value["faxNo"],
            access: value["access"],
            parking_info: value["parkingInformation"],
            near_station: value["nearestStation"],
            hotel_img_url: value["hotelImageUrl"],
            rakuten_review_count: value["reviewCount"],
            rakuten_review_avg: value["reviewAverage"].to_f
          }
        end
      end
      @result["hotels"][0].each do |_key, field|
        field[1].each do |_, value|
          @data_hash["rakuten_service_review"] = value["serviceAverage"].to_f
          @data_hash["rakuten_location_review"] = value["locationAverage"].to_f
          @data_hash["rakuten_room_review"] = value["roomAverage"].to_f
          @data_hash["rakuten_equipment_review"] = value["equipmentAverage"].to_f
          @data_hash["rakuten_bath_review"] = value["bathAverage"].to_f
          @data_hash["rakuten_meal_review"] = value["mealAverage"].to_f
        end
      end
      @result["hotels"][0].each do |_key, field|
        field[2].each do |_, value|
          @data_hash["middle_class_code"] = value["middleClassCode"].to_s
          @data_hash["small_class_code"] = value["smallClassCode"].to_s
          @data_hash["area_name"] = value["areaName"].to_s
          @data_hash["hotel_class_code"] = value["hotelClassCode"].to_s
          @data_hash["checkin_time"] = value["checkinTime"].to_s
          @data_hash["checkout_time"] = value["checkoutTime"].to_s
          @data_hash["last_checkin_time"] = value["lastCheckinTime"].to_s
        end
      end
      @result["hotels"][0].each do |_key, field|
        field[3].each do |_, value|
          @data_hash["total_room_num"] = value["hotelRoomNum"].to_s
          room_facilities = []
          value["roomFacilities"].each_with_index do |f, i|
            room_facilities[i] = f["item"]
          end
          @data_hash["room_facilities"] = room_facilities
        end
      end
      @result["hotels"][0].each do |_key, field|
        field[4].each do |_, value|
          @data_hash["hotel_policy_note"] = value["note"].to_s
          @data_hash["cancel_policy"] = value["cancelPolicy"].to_s
        end
      end
      @data_hash
    end
  end
end
