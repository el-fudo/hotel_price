module HotelPrice::Rakuten
  class RakutenScraper
    def self.review rakuten_hotel_id
      driver = self.get_selenium_driver
      driver.get("https://travel.rakuten.co.jp/HOTEL/#{rakuten_hotel_id.to_s}/review.html")
      sleep 2
      comment_area = driver.find_elements(:class_name, "commentBox")
      data = comment_area.map do |f|
        if f.find_element(class_name: "user").text.include?("投稿者さん")
          username = f.find_element(class_name: "user").text
          generation = 0
          gender = ""
        else
          username = f.find_element(class_name: "user").text.match(/(^.+ )/).to_s.strip 
          generation = f.find_element(class_name: "user").text.match(/\[.+代/).to_s.gsub("[","").gsub("代", "")
          gender = f.find_element(class_name: "user").text.match(/\/../).to_s.gsub("/", "")
        end
        {
          date: f.find_element(class_name: "time").text.gsub("年","").gsub("月", "").gsub("日", ""),
          rate: f.find_element(class_name: "rate").text,
          username: username,
          generation: generation,
          gender: gender,
          rakuten_hotel_id: rakuten_hotel_id,
          comment: f.find_element(class_name: "commentSentence").text
        }
      end
      driver.quit
      data
    end

    def self.get_photo_num rakuten_hotel_id
      driver = self.get_selenium_driver
      driver.get "https://hotel.travel.rakuten.co.jp/hinfo/#{rakuten_hotel_id}/"
      sleep 2
      num = driver.find_element(:id, "navPht").text.gsub("写真・動画(", "").gsub(")", "").to_i
      driver.quit
      num
    end

    def self.get_bf_plan_num rakuten_hotel_id
      driver = self.get_selenium_driver
      driver.get "https://hotel.travel.rakuten.co.jp/hotelinfo/plan/#{rakuten_hotel_id}"
      driver.find_element(:id, "focus1").click
      driver.find_element(:id, "dh-squeezes-submit").click
      sleep 30
      plan_num = driver.find_elements(:class, "planThumb")
      driver.quit
      plan_num.size
    end

    def self.get_selenium_driver
      # firefox_capabilities = Selenium::WebDriver::Remote::Capabilities.firefox
      # @driver = Selenium::WebDriver.for(:remote, url: "http://hub:4444/wd/hub", desired_capabilities: firefox_capabilities)
  
      options = Selenium::WebDriver::Firefox::Options.new
      options.add_argument("-headless")
      Selenium::WebDriver.for :firefox#, options: options
    end
    
  end
end