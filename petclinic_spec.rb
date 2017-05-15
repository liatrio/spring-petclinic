require 'headless'
require 'selenium-webdriver'
require 'minitest/spec'
require 'minitest/autorun'

describe 'Petlinic' do
  before do
    @headless = Headless.new
    @headless.start

    @driver = Selenium::WebDriver.for :firefox
    @driver.navigate.to 'http://tomcat:8080/petclinic'
    @wait = Selenium::WebDriver::Wait.new(:timeout => 3)
    @driver.manage.timeouts.implicit_wait = 30
  end

  after do
    @headless.destroy
  end

  describe 'when homepage is available' do
    it 'I should see page title containing PetClinic' do
      assert @driver.title == "PetClinic :: a Spring Framework demonstration"
    end
  end


  describe 'when homepage is available' do
    it 'click the find owners button' do
        @driver.find_element(:class, "icon-search").click
        h2 = @driver.find_element(:tag_name, "h2")
        assert h2.text == "Find Owners"
    end
  end

  describe 'when homepage is available' do
      it 'search for the veternarian named Helen' do
          @driver.find_element(:class, "icon-th-list").click
          sleep 2
          h2 = @driver.find_element(:tag_name, "h2")
          assert h2.text == "Veterinarians"
      end
  end

end
