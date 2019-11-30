require "hotel_price/version"
require "selenium-webdriver"

module RakutenTravelReview
  class Error < StandardError; end
  def self.rakuten_travel
    # firefox_capabilities = Selenium::WebDriver::Remote::Capabilities.firefox
    # @driver = Selenium::WebDriver.for(:remote, url: "http://hub:4444/wd/hub", desired_capabilities: firefox_capabilities)
    driver = Selenium::WebDriver.for :firefox
    driver.get('https://travel.rakuten.co.jp/')
    sleep 2
    title = driver.find_element(:tag_name, "p").text
    driver.quit
    title
  end
end
