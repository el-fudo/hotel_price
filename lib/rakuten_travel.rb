module RakutenTravel
  require "net/http"
  class Error < StandardError; end
    def self.hotel_info rakuten_hotel_id
      uri2 = URI.parse("https://app.rakuten.co.jp/services/api/Travel/HotelDetailSearch/20131024?hotelNo=" + rakuten_hotel_id.to_s + "&applicationId=" + ENV["RT_API_KEY"].to_s + "&datumType=1&responseType=large")
      json2 = Net::HTTP.get(uri2)
      @result2 = JSON.parse(json2)
      @hotel_hash = {}
      if @result2["error"] == "not_found"
        puts "#{@int_num}:ホテル情報がありませんでした。"
      else
        @result2["hotels"][0].each do |_key, value|
          value[0].each do |_key, value|
            @data_hash = {
              "rakuten_hotel_id" => value["hotelNo"],
              "hotel_name" => value["hotelName"],
              "room_price_min" => value["hotelMinCharge"],
              "lat" => value["latitude"],
              "lon" => value["longitude"],
              "tel" => value["telephoneNo"],
              "zip_code" => value["postalCode"],
              "address1" => value["address1"],
              "address2" => value["address2"],
              "fax" => value["faxNo"],
              "access" => value["access"],
              "parking_info" => value["parkingInformation"],
              "near_station" => value["nearestStation"],
              "hotel_img_url" => value["hotelImageUrl"],
              "rakuten_review_count" => value["reviewCount"],
              "rakuten_review_avg" => value["reviewAverage"].to_f
            }
          end
        end
        @result2["hotels"][0].each do |_key, value|
          value[1].each do |_key, value|
            @data_hash["rakuten_service_review"] = value["serviceAverage"].to_f
            @data_hash["rakuten_location_review"] = value["locationAverage"].to_f
            @data_hash["rakuten_room_review"] = value["roomAverage"].to_f
            @data_hash["rakuten_equipment_review"] = value["equipmentAverage"].to_f
            @data_hash["rakuten_bath_review"] = value["bathAverage"].to_f
            @data_hash["rakuten_meal_review"] = value["mealAverage"].to_f
          end
        end
        @result2["hotels"][0].each do |_key, value|
          value[2].each do |_key, value|
            @data_hash["middleClassCode"] = value["middleClassCode"].to_s
            @data_hash["smallClassCode"] = value["smallClassCode"].to_s
            @data_hash["areaName"] = value["areaName"].to_s
            @data_hash["hotelClassCode"] = value["hotelClassCode"].to_s
            @data_hash["checkinTime"] = value["checkinTime"].to_s
            @data_hash["checkoutTime"] = value["checkoutTime"].to_s
            @data_hash["lastCheckinTime"] = value["lastCheckinTime"].to_s
          end
        end
        @result2["hotels"][0].each do |_key, value|
          value[3].each do |_key, value|
            @data_hash["total_room_num"] = value["hotelRoomNum"].to_s
            room_facilities = []
            value["roomFacilities"].each_with_index do |f, i|
              room_facilities[i] = f["item"]
            end
            @data_hash["roomFacilities"] = room_facilities
          end
        end
        @result2["hotels"][0].each do |_key, value|
          value[4].each do |_key, value|
            @data_hash["hotel_policy_note"] = value["note"].to_s
            @data_hash["cancelPolicy"] = value["cancelPolicy"].to_s
          end
        end

      end
      @data_hash
    end

    def get_rakuten_min_price params
      breakfast = if params[:breakfast] == 1
                    "breakfast"
                  else
                    ""
                  end
      @user_info = {
        hotel_id: params[:hotel_id],
        rakuten_hotel_id: params[:rakuten_hotel_id],
        adult_num: params[:adult_num],
        breakfast: breakfast,
        checkindate: params[:checkindate],
        checkoutdate: (Date.parse(params[:checkindate]) + 1).strftime("%Y-%m-%d")
      }
      try = 0
      begin
        # app_id = '1045253226123708550'
        uri = URI.parse("https://app.rakuten.co.jp/services/api/Travel/VacantHotelSearch/20131024?format=json&sort=%2BroomCharge&searchPattern=1&adultNum=" + @user_info[:adult_num].to_s + "&checkinDate=" + @user_info[:checkindate].to_s + "&checkoutDate=" + @user_info[:checkoutdate].to_s + "&hotelNo=" + @user_info[:rakuten_hotel_id].to_s + "&applicationId=" + app_id.to_s + "&squeezeCondition=" + @user_info[:breakfast])
        puts uri
        json = Net::HTTP.get(uri)
        @result = JSON.parse(json)
        try = 0
        begin
          @data_hash = if @result["error"].blank?
                         {
                           "date" => DateTime.now.strftime("%Y-%m-%d"),
                           "checkindate" => @result["hotels"][0]["hotel"][1]["roomInfo"][1]["dailyCharge"]["stayDate"],
                           "rakuten_hotel_id" => @user_info[:rakuten_hotel_id],
                           "hotel_name" => @result["hotels"][0]["hotel"][0]["hotelBasicInfo"]["hotelName"],
                           "adult_num" => @user_info[:adult_num],
                           "breakfast" => @user_info[:breakfast],
                           "plan_num" => @result["pagingInfo"]["recordCount"],
                           "room_name" => @result["hotels"][0]["hotel"][1]["roomInfo"][0]["roomBasicInfo"]["roomName"],
                           "plan_name" => @result["hotels"][0]["hotel"][1]["roomInfo"][0]["roomBasicInfo"]["planName"],
                           "min_price" => @result["hotels"][0]["hotel"][1]["roomInfo"][1]["dailyCharge"]["rakutenCharge"]
                         }
                       elsif @result["error"] == "not_found"
                         {
                           "date" => DateTime.now.strftime("%Y-%m-%d"),
                           "checkindate" => @user_info[:checkindate],
                           "rakuten_hotel_id" => @user_info[:rakuten_hotel_id],
                           "hotel_name" => Hotel.find(@user_info[:hotel_id]).hotel_name,
                           "adult_num" => @user_info[:adult_num],
                           "breakfast" => @user_info[:breakfast],
                           "plan_num" => 0,
                           "min_price" => 0
                         }
                       elsif @result["error"] == "wrong_parameterd"
                         "入力した値が正しくありません。"
                       else
                         "何か起きました。"
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
      @data_hash
    end

    def search_now body = {}
      base_url = "https://app.rakuten.co.jp/services/api/Travel/VacantHotelSearch/20170426?"
      app_key02 = "1094576189112221722"
      checkinDate = DateTime.now.strftime("%Y-%m-%d")
      checkoutDate = (Date.parse(checkinDate) + 1).strftime("%Y-%m-%d")
      latitude = body["lat"].to_s
      longitude = body["lon"].to_s
      searchRadius = "1"
      url = [base_url, "&applicationId=", app_key02, "&formatVersion=2", "&checkinDate=", checkinDate, "&checkoutDate=", checkoutDate, "&latitude=", latitude, "&longitude=", longitude, "&searchRadius=", searchRadius].join
      uri = URI.parse(url)
      json = Net::HTTP.get(uri)
      @result = JSON.parse(json)
      @result["hotels"]
    end

    # def rakuten_min_price
    #   Branch.where(chain_id: 5).each do |f|
    #     (0..365).each do |i|
    #       break if f.rakuten_hotel_id == 0

    #       body = {
    #         checkindate: (DateTime.now + i).strftime("%Y-%m-%d"),
    #         branch_id: f.id,
    #         rakuten_hotel_id: f.rakuten_hotel_id,
    #         adult_num: 1,
    #         hotel_id: f.hotel_id
    #       }
    #       price = RakutenAPI.new
    #       data = price.get_rakuten_min_price body
    #       scraper_price = {
    #         hotel_id: f.hotel_id,
    #         chain_id: f.chain_id,
    #         breakfast: false,
    #         dinner: false,
    #         run_date: DateTime.now.strftime("%F"),
    #         branch_id: f.id,
    #         checkindate: body[:checkindate],
    #         rakuten_min_price: data["min_price"],
    #         rakuten_min_plan_name: data["plan_name"],
    #         rakuten_min_room_name: data["room_name"]
    #       }
    #       puts scraper_price.to_s if HotelPrice.create(scraper_price).valid?
    #     end
    #   end
    #   { status: "success", response: "Done 365 days price data!" }
    # end
end
