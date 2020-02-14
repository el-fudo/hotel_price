module HotelPrice::AgodaAPI
  class Agoda
    def test
      @api = ENV["AGODA_KEY"]
      endpoint_url = "http://affiliateapi7643.agoda.com/affiliateservice/lt_v1"
      # 検索条件の指定
      # cityId, checkInDate, checkOutDate は必須、ソレ以外はオプション。
      params = {
        "criteria": {
          "additional": {
            "currency": "JPY",
            "dailyRate": {
              "maximum": 100000,
              "minimum": 1000
            },
            "discountOnly": false,
            "language": "ja-jp",
            "maxResult": 10,
            "minimumReviewScore": 0,
            "minimumStarRating": 0,
            "occupancy": {
              "numberOfAdult": 1,
              "numberOfChildren": 0
            },
            "sortBy": "PriceAsc"
          },
          "discountOnly": true,
          "checkInDate": "2019-10-02",
          "checkOutDate": "2019-10-03",
          "cityId": 5235
        }
      }

      url = URI.parse(endpoint_url)
      req = Net::HTTP::Post.new(url.path)
      req["Authorization"] = @api
      req["Content-Type"]  = "application/json"
      req.body = params.to_json
      res = Net::HTTP.new(url.host, url.port).start do |http|
        http.request(req)
      end

      puts res.body
    end
  end
end
