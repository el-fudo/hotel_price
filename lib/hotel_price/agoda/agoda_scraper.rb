require "date"

module HotelPrice::Agoda
  class AgodaScraper
    def self.get_price(agoda_hotel_id, checkin_date, num_adults)
      date = DateTime.now.strftime("%Y-%m-%d")

      query_string = make_query_string(checkin_date, num_adults)
      url = "https://www.agoda.com/ja-jp/#{agoda_hotel_id}.html?#{query_string}"
      driver = self.get_selenium_driver
      driver.get(url)
      sleep 2

      data = driver.find_elements(:xpath, "//strong[@data-ppapi='room-price']")
      return { date: date, min_price: 0 } if data.empty?
      price = data.first.text.delete("^0-9").to_i

      hotel_name = driver.find_elements(:xpath, "//h1[@data-selenium='hotel-header-name']").first.text
      room_name = driver.find_elements(:xpath, "//span[@data-selenium='masterroom-title-name']").first.text

      { date: date, min_price: price, hotel_name: hotel_name, room_name: room_name }
    end

    def self.make_query_string(checkin_date, num_adults)
      cd_args = make_date_args checkin_date
      na_args = make_num_adults_arg num_adults
      "#{cd_args}&#{na_args}&rooms=1&travellerType=-1"
    end

    def self.make_date_args checkin_date
      Date.parse checkin_date rescue return ""
      t = Date.parse(checkin_date)
      checkin_arg = t.strftime("checkIn=%Y-%m-%d")
      "#{checkin_arg}&los=2"
    end

    def self.make_num_adults_arg num_adults
      return "" if num_adults.to_i <= 1
      "adults=#{num_adults}"
    end

    def self.get_selenium_driver
      options = Selenium::WebDriver::Firefox::Options.new
      options.add_argument("-headless")
      Selenium::WebDriver.for :firefox, options: options
    end
  end
end