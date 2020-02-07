# frozen_string_literal: true

require "webdrivers"
require "uri"

LOGINID = "#{ ARGV[0] || ENV["$RLOGINID"]}"
PASSWORD    = "#{ ARGV[1] || ENV["$RPASSWORD"]}"
LOGINURL    = "#{ ARGV[2] || ENV["$RLOGINURL"]}"
CAMPAIGNURL = "#{ ARGV[3] || ENV["$RCAMPAIGNURL"]}"

driver = Selenium::WebDriver.for :chrome
driver.navigate.to(LOGINURL)

driver.find_element(:id, "loginInner_u").send_keys(LOGINID)
driver.find_element(:id, "loginInner_p").send_keys(PASSWORD)
driver.find_element(:class, "loginButton").click
driver.navigate.to(CAMPAIGNURL)
statuses = driver.find_elements(:class, "campaign__status--saLnK")
all_links = driver.find_elements(:class, "campaign__title--1qpNU")

campaign_links = statuses.zip(all_links)
                         .filter { |e| e[0].text == "エントリー受付中" }
                         .map { |e| e[1].find_element(:xpath, ".//a").attribute("href") }

puts "Canpaign List"
puts campaign_links
failed = campaign_links.map do |canpaign_link|
  driver.navigate.to(canpaign_link)
  links = driver.find_elements(:xpath, "//a[starts-with(@href,'https://oubo')]")
  next canpaign_link if links.empty?

  link = links[0].attribute("href")
  puts link
  driver.navigate.to(link)
  sleep(1)
  driver.navigate.to(CAMPAIGNURL)
  return nil
end

failed.compact.each do |link|
  puts "Failed Links"
  puts link
  # TODO: 失敗したURLを送る
end
