require "webdrivers"
require "uri"

LOGINID = "#{ARGV[0]}"
PASSWORD = "#{ARGV[1]}"

ALLOWTIMES = ["22:00", "22:30", "23:00", "23:30", "24:00", "24:30"]

type = "&data[tab1]"

ENV["TZ"] = "Asia/Tokyo"
t = Time.new
date =  "#{t.year}-#{t.month}-#{t.day}"
sort = 6
native = 1
favorite = "on"

driver = Selenium::WebDriver.for :chrome
driver.navigate.to "https://accounts.dmm.com/service/login/password"

driver.find_element(:id, "login_id").send_keys("#{LOGINID}")
driver.find_element(:id, "password").send_keys("#{PASSWORD}")
driver.find_element(:class, "btn-login").click() # classでの指定

message = catch(:success) do
    [true, false].each do |isFavorite|
        puts isFavorite
        ALLOWTIMES.each do |time|
            puts time

            url_string = [
                "https://eikaiwa.dmm.com/",
                "list/?",
                type,
                "[start_time]=",
                time,
                type,
                "[end_time]=",
                time,
                type,
                "[native]=",
                native,
                type,
                "[favorite]=",
                favorite,
                "&date=",
                date,
                "&sort=",
                sort,
            ].join

            puts url_string

            # Note:
            # This API was obsolete.
            # https://docs.ruby-lang.org/ja/latest/method/URI/s/encode.html
            url = URI.encode(url_string)

            driver.navigate().to url
            buttons = driver.find_elements(:class, "bt-open").select(&:displayed?)

            buttons.each do |button|
                button.click()
                sleep(3)
                driver.find_element(:id, "submitBox").click()
                throw :success, "OK"
            end
        end
    end
end
