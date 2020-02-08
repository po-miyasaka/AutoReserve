# frozen_string_literal: true

require "webdrivers"
require "uri"

LOGINID = "#{ ARGV[0] || ENV["$RLOGINID"]}"
PASSWORD    = "#{ ARGV[1] || ENV["$RPASSWORD"]}"

class RPointEntryService
  
  def initialize()
    @loginURL = "https://grp03.id.rakuten.co.jp/rms/nid/login?service_id=i122"
    @campaignURL = "https://pointcard.rakuten.co.jp/campaign/"
    @driver = Selenium::WebDriver.for :chrome
    @campaign_links
    @failedLinks
  end
  

  
  def login()
    @driver.navigate.to(@loginURL)
    @driver.find_element(:id, "loginInner_u").send_keys(LOGINID)
    @driver.find_element(:id, "loginInner_p").send_keys(PASSWORD)
    @driver.find_element(:class, "loginButton").click
  end
  
  
  def getCampaignList()
    @driver.navigate.to(@campaignURL)
    statuses = @driver.find_elements(:class, "campaign__status--saLnK")
    all_links = @driver.find_elements(:class, "campaign__title--1qpNU")
    
    @campaign_links = statuses.zip(all_links)
    .filter { |e| e[0].text == "エントリー受付中" }
    .map { |e| e[1].find_element(:xpath, ".//a").attribute("href") }
    
    puts "Canpaign List"
    puts @campaign_links
  end
  
  def entry()
    puts "Entry\n"
    @failed = @campaign_links.map do |canpaign_link|
      @driver.navigate.to(canpaign_link)
      links = @driver.find_elements(:xpath, "//a[starts-with(@href,'https://oubo')]")
      next canpaign_link if links.empty?
      
      link = links[0].attribute("href")
      puts link
      @driver.navigate.to(link)
      sleep(1)
      @driver.navigate.to(@campaignURL)
      next nil
    end
  end
  
  
  def handleFailedLinks() 
    puts "Failed Links"
    @failed.compact.each { |link| puts link }
  end
  
  def processing()
    login()
    getCampaignList()
    entry()
    handleFailedLinks()
  end
end

s = RPointEntryService.new
s.processing()