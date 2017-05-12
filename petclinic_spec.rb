require 'headless'
require 'selenium-webdriver'
require 'minitest/spec'
require 'minitest/autorun'

describe 'Petlinic' do
  before do
    @headless = Headless.new
    @headless.start

    @driver = Selenium::WebDriver.for :firefox
    @driver.navigate.to 'http://dashboard:8080/petclinic'
  end

  after do
    @headless.destroy
  end

  describe 'when homepage is available' do
    it 'I should see Page title' do
      puts "Title is: #{@driver.title}"
      assert @driver.title == "PetClinic :: a Spring Framework demonstration"
    end
  end

  # describe 'when homepage is available' do
  #   it "I should see Home button" do
  #     home_button = driver.find_elements(:class_name, 'icon-home')
  #     puts "Element home:  #{home_button.text}"
  #   end
  # end
end
