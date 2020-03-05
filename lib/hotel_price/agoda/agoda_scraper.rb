module HotelPrice::Agoda
  class AgodaScraper
    def self.get_price(day)
      datetime = DateTime.now
      retr_datetime = datetime + day
      date = retr_datetime.day
      date_tmrw = (retr_datetime + 1).day
      url = "https://www.agoda.com/ja-jp/hotel-sunroute-new-sapporo/hotel/sapporo-jp.html"
      driver = self.get_selenium_driver
      driver.get(url)
      sleep 2

      added_months = (retr_datetime.year - datetime.year) * 12 + (retr_datetime.month - datetime.month)

      if added_months.positive?
        (1..added_months).each do |_n|
          driver.find_element(:class_name, "DayPicker-NavButton--next").click
          sleep 1
        end
      end

      today = retr_datetime.strftime("%a %b %d %Y")
      tomorrow = (retr_datetime + 1).strftime("%a %b %d %Y")

      driver.find_elements(:xpath, "//div[@aria-label=\"#{today}\"]")[0].click
      driver.find_elements(:xpath, "//div[@aria-label=\"#{tomorrow}\"]")[0].click
      driver.find_element(:xpath, "/html/body/div[14]/div/div[1]/div/div/div[5]/div/div/div/div/div/div[1]/div[1]").click
      driver.find_element(:class_name, "Searchbox__searchButton__text").click
      sleep 5
      begin
        room_name = driver.find_element(:xpath, "/html/body/div[14]/div/div[4]/div/div[2]/div/div[4]/div/div[2]/div[3]/div[1]/div[1]/div[1]/a/div/div/span").text
      rescue StandardError => e
        room_name = ""
      end
      begin
        min_price = driver.find_element(:class_name, "PriceRibbon__Price").text.gsub(",", "").to_i
      rescue StandardError
        min_price = 0
      end
      sleep 3
      data = {
        checkin_date: datetime.year.to_s + datetime.month.to_s + date.to_i.to_s,
        agoda_min_price: min_price,
        agoda_min_room_name: room_name
      }
      puts data
      driver.quit
    end

    def self.get_selenium_driver
      options = Selenium::WebDriver::Firefox::Options.new
      options.add_argument("-headless")
      Selenium::WebDriver.for :firefox#, options: options
    end
  end
end
