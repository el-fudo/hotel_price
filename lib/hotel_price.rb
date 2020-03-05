require "hotel_price/version"
require "hotel_price/rakuten"
require "hotel_price/jalan"
require "hotel_price/agoda"
require "hotel_price/booking"
require "hotel_price/expedia"
require "selenium-webdriver"
require "net/http"
require "active_support/all"

module HotelPrice
  class Error < StandardError; end
  def self.rakuten_travel
    driver = self.get_selenium_driver
    rakuten_travel_hotel_id = 128552
    driver.get("https://travel.rakuten.co.jp/HOTEL/#{rakuten_travel_hotel_id.to_s}/review.html")
    sleep 2
    comment_area = driver.find_elements(:class_name, "commentReputationBoth")
    comment_area.map do |f|
      {
        status: "success",
        date: f.find_element(class_name: "time").text,
        rakuten_hotel_id: rakuten_travel_hotel_id,
        comment: f.find_element(class_name: "commentSentence").text
      }
    end
  end

  private

  def self.get_selenium_driver
    # firefox_capabilities = Selenium::WebDriver::Remote::Capabilities.firefox
    # @driver = Selenium::WebDriver.for(:remote, url: "http://hub:4444/wd/hub", desired_capabilities: firefox_capabilities)

    options = Selenium::WebDriver::Firefox::Options.new
    options.add_argument("-headless")
    Selenium::WebDriver.for :firefox, options: options
  end
end
