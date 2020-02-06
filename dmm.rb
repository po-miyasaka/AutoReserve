# frozen_string_literal: true

require "webdrivers"
require "uri"
require "./dmm_lib.rb"

LOGINID =  ARGV[0] || ENV["DMMLOGINID"]
PASSWORD = ARGV[1] || ENV["DMMPASSWORD"]

ENV["TZ"] = "Asia/Tokyo"

now = Time.new
date = "#{now.year}-#{now.month}-#{now.day}"

driver = Selenium::WebDriver.for :chrome
driver.navigate.to "https://accounts.dmm.com/service/login/password"

driver.find_element(:id, "login_id").send_keys(LOGINID)
driver.find_element(:id, "password").send_keys(PASSWORD)
driver.find_element(:class, "btn-login").click # classでの指定

message = catch(:success) do
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
        driver.find_element(:id, "submitBox").click
        throw :success, "OK"
      end
    end
  end
end
