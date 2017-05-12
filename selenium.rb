require 'headless'
require 'selenium-webdriver'

headless = Headless.new

headless.start

driver = Selenium::WebDriver.for :firefox
driver.navigate.to 'http://dashboard/petclinic'
puts "Page title: #{driver.title}"
headless.destroy
