# frozen_string_literal: true

require "webdrivers"
require "uri"

LOGINID =  ARGV[0] || ENV["$RAKUTENLOGINID"]
PASSWORD = ARGV[1] || ENV["$RAKUTENPASSWORD"]
ENV["TZ"] = "Asia/Tokyo"

driver = Selenium::WebDriver.for :chrome
driver.navigate.to "https://grp03.id.rakuten.co.jp/rms/nid/login?service_id=i122"

driver.find_element(:id, "loginInner_u").send_keys(LOGINID)
driver.find_element(:id, "loginInner_p").send_keys(PASSWORD)
driver.find_element(:class, "loginButton").click

def doSomething(driver)
  driver.navigate.to "https://pointcard.rakuten.co.jp/campaign/"
  statuss = driver.find_elements(:class, "campaign__status--saLnK")
  links = driver.find_elements(:class, "campaign__title--1qpNU")

  tuples = statuss.zip(links)

  tuples.each do |canpaign|
    puts "yyyyyyyyyyyyyyyy"
    if canpaign[0].text == "エントリー受付中"
      canpaign[1].click
      button_elements = driver.find_elements(:class, "entry-Btn")
      puts("aa")
      puts button_elements.count
      if button_elements.count == 0
        button_elements = driver.find_elements(:class, "entryBtn")
      end
      puts button_elements.count
      button_elements.each do |button_element|
        puts "ccccccccccccc"
        link = button_element.attribute("href")
        puts "ddddddddddd"
        unless link.nil?
          driver.navigate.to link
          throw :next
        end
      end
    end
    throw :next
  end
end

20.times do
  catch (:next) do
    puts "bbbb"
    doSomething(driver)
  end
end
puts "aaaa"
