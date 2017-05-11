require ‘headless’
require ‘selenium-webdriver’

headless = Headless.new

headless.start

driver = Selenium::WebDriver.for :firefox
driver.navigate.to 'http://google.com'
headless.destroy
