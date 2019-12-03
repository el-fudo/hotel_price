require "hotel_price/version"
require "selenium-webdriver"

module HotelPrice
  class Error < StandardError; end
  def self.rakuten_travel
    # firefox_capabilities = Selenium::WebDriver::Remote::Capabilities.firefox
    # @driver = Selenium::WebDriver.for(:remote, url: "http://hub:4444/wd/hub", desired_capabilities: firefox_capabilities)
    options = Selenium::WebDriver::Firefox::Options.new
    options.add_argument("-headless")
    driver = Selenium::WebDriver.for :firefox, options: options
    rakuten_travel_hotel_id = 7770
    driver.get("https://travel.rakuten.co.jp/HOTEL/#{rakuten_travel_hotel_id.to_s}/review.html")
    sleep 2
    comment_area = driver.find_elements(:class_name, "commentReputationBoth")
    data = comment_area.map do |f|
      {
        status: "success",
        date: f.find_element(class_name: "time").text,
        rakuten_hotel_id: 7770,
        comment: f.find_element(class_name: "commentSentence").text
      }
    end
    driver.quit
    data
  end
end
