# frozen_string_literal: true

require "webdrivers"
require "uri"

# ENVのキーに$はつけない
LOGINID = (ARGV[0] || ENV["RLOGINID"]).to_s
PASSWORD = (ARGV[1] || ENV["RPASSWORD"]).to_s
LOGINURL    = (ARGV[2] || ENV["RLOGINURL"]).to_s
CAMPAIGNURL = (ARGV[3] || ENV["RCAMPAIGNURL"]).to_s.to_s

# RPointにエントリーしてくれるやーつ
class RPointEntryService
  def initialize
    @login_url = LOGINURL
    @campaign_url = CAMPAIGNURL
    @driver = Selenium::WebDriver.for :chrome
  end

  def login
    @driver.navigate.to(@login_url)
    @driver.find_element(:id, "loginInner_u").send_keys(LOGINID)
    @driver.find_element(:id, "loginInner_p").send_keys(PASSWORD)
    @driver.find_element(:class, "loginButton").click
  end

  def get_campaign_list
    @driver.navigate.to(@campaign_url)
    statuses = @driver.find_elements(:class, "campaign__status--saLnK")
    all_links = @driver.find_elements(:class, "campaign__title--1qpNU")

    @campaign_links = statuses.zip(all_links)
                              .filter { |e| e[0].text == "エントリー受付中" }
                              .map { |e| e[1].find_element(:xpath, ".//a").attribute("href") }
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
