# frozen_string_literal: true

require "webdrivers"
require "uri"
require "./dmm_lib.rb"

class DMM
  def self.run(id, password)
    ENV["TZ"] = "Asia/Tokyo"
    
    now = Time.new
    date = "#{now.year}-#{now.month}-#{now.day}"
    
    driver = Selenium::WebDriver.for :chrome
    driver.navigate.to "https://accounts.dmm.com/service/login/password"
    
    driver.find_element(:id, "login_id").send_keys(id)
    driver.find_element(:id, "password").send_keys(password)
    driver.find_element(:class, "btn-login").click # classでの指定
    
    message = catch(:result) do
      [true, false].each do |is_favorite|
        puts is_favorite
        
        ALLOWTIMES.each do |time|
          puts time
          url_string = generate_url_string(date, time, is_favorite)
          
          puts url_string
          # Note:
          # This API was obsolete.
          # https://docs.ruby-lang.org/ja/latest/method/URI/s/encode.html
          url = URI.encode(url_string)
          driver.navigate.to url
          buttons = driver.find_elements(:class, "bt-open").select(&:displayed?)
          
          buttons.each do |button|
            button.click
            sleep(3)
            button = driver.find_elements(:id, "submitBox")
            throw :result, "予約済みの可能性あり" if button.empty?
            button[0].click
            throw :result, "予約Done"
          end
        end
      end
      puts message
    end
  end
end


