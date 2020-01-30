module HotelPrice::Rakuten
  class RakutenScraper
    def self.review rakuten_hotel_id
      driver = self.get_selenium_driver
      driver.get("https://travel.rakuten.co.jp/HOTEL/#{rakuten_hotel_id.to_s}/review.html")
      sleep 2
      comment_area = driver.find_elements(:class_name, "commentBox")
      data = comment_area.map do |f|
        {
          date: f.find_element(class_name: "time").text,
          rakuten_hotel_id: rakuten_hotel_id,
          comment: f.find_element(class_name: "commentSentence").text
        }
      end
      driver.quit
      data
    end

    def self.get_selenium_driver
      # firefox_capabilities = Selenium::WebDriver::Remote::Capabilities.firefox
      # @driver = Selenium::WebDriver.for(:remote, url: "http://hub:4444/wd/hub", desired_capabilities: firefox_capabilities)
  
      options = Selenium::WebDriver::Firefox::Options.new
      options.add_argument("-headless")
      Selenium::WebDriver.for :firefox, options: options
    end
    
  end
end