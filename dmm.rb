require "webdrivers"
require "uri"

LOGINID = ""
PASSWORD = ""

ALLOWTIMES = ["22:00", "22:30", "23:00", "23:30", "24:00", "24:30"]

host = "https://eikaiwa.dmm.com/"
path = "list/?"
type = "&data[tab1]"
start_time_key = "[start_time]="
end_time_key = "[end_time]="
date_key = "&date="
sort_key = "&sort="
native_key = "[native]="
favorite_key = "[favorite]="

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
    [true, false].each { |isFavorite|
        puts isFavorite
        ALLOWTIMES.each { |time|
            puts time
            tmp = "#{host}#{path}#{type}#{start_time_key}#{time}#{type}#{end_time_key}#{time}#{type}#{native_key}#{native}#{type}#{favorite_key}#{favorite}#{date_key}#{date}#{sort_key}#{sort}"
            puts tmp
            url = URI.encode("#{tmp}")
            driver.navigate().to url
            buttons = driver.find_elements(:class, "bt-open").select{ |element| element.displayed? }
            
            buttons.each { |button| 
                button.click()
                sleep(3)
                driver.find_element(:id, "submitBox").click()
                throw :success, "OK"
            }
        }
    }
end