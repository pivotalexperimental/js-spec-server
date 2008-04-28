require File.expand_path("#{File.dirname(__FILE__)}/integration_spec_helper")

describe "JsSpec" do
  it "writes the guid" do
    driver = Selenium::SeleniumDriver.new("localhost", 4444,
          "*firefox", root_url, 15000)

    class << driver
      attr_reader :session_id
    end

    begin
      driver.start
      driver.open("#{root_url}/specs/foo/passing_spec")

      driver.get_eval("selenium.browserbot.getCurrentWindow().JSSpec.guid").should == driver.session_id
    ensure
      driver.stop
    end
  end

  it "runs a full passing Suite" do
    mock(JsSpec::Client).puts("SUCCESS")
    JsSpec::Client.run(:spec_url => "#{root_url}/specs/foo/passing_spec")
  end

  it "runs a full failing Suite" do
    mock(JsSpec::Client).puts("FAILURE")
    mock(JsSpec::Client).puts(/A failing spec in foo fails/)
    JsSpec::Client.run(:spec_url => "#{root_url}/specs/foo/failing_spec")
  end
end
