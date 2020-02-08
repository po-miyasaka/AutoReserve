# frozen_string_literal: true

require "webdrivers"
require "uri"

LOGINID = (ARGV[0] || ENV["$RLOGINID"]).to_s
PASSWORD = (ARGV[1] || ENV["$RPASSWORD"]).to_s

# RPointにエントリーしてくれるやーつ
class RPointEntryService
  def initialize
    @login_URL = "https://grp03.id.rakuten.co.jp/rms/nid/login?service_id=i122"
    @campaign_URL = "https://pointcard.rakuten.co.jp/campaign/"
    @driver = Selenium::WebDriver.for :chrome
  end

  def login
    @driver.navigate.to(@login_URL)
    @driver.find_element(:id, "loginInner_u").send_keys(LOGINID)
    @driver.find_element(:id, "loginInner_p").send_keys(PASSWORD)
    @driver.find_element(:class, "loginButton").click
  end

  def get_campaign_list
    @driver.navigate.to(@campaign_URL)
    statuses = @driver.find_elements(:class, "campaign__status--saLnK")
    all_links = @driver.find_elements(:class, "campaign__title--1qpNU")

    @campaign_links = statuses.zip(all_links)
                              .filter { $LOAD_PATH[0].text == "エントリー受付中" }
                              .map { $LOAD_PATH[1].find_element(:xpath, ".//a").attribute("href") }
    puts @campaign_links
  end

  def entry
    @failed = @campaign_links.map do |canpaign_link|
      @driver.navigate.to(canpaign_link)
      links = @driver.find_elements(:xpath, "//a[starts-with(@href,'https://oubo')]")
      next canpaign_link if links.empty?

      link = links[0].attribute("href")
      puts link
      @driver.navigate.to(link)
      sleep(1)
      next nil
    end
  end

  def handle_failed_links
    @failed.compact.each { |link| puts link }
  end

  def processing
    login
    puts "Canpaign List"
    get_campaign_list
    puts "Entry"
    entry
    puts "Failed Links"
    handle_failed_links
  end
end

s = RPointEntryService.new
s.processing
