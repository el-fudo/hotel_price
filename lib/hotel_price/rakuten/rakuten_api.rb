module HotelPrice::Rakuten
  class RakutenAPI
    def initialize params
      @config = {
          rakuten_hotel_id: params[:rakuten_hotel_id] ||= 0,
          rakuten_api_key: params[:rakuten_api_key] ||= ENV["RT_API_KEY"]
      }
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