require File.expand_path("#{File.dirname(__FILE__)}/../../../unit_spec_helper")

module JsSpec
  module Resources
    describe Runners::FirefoxRunner do
      attr_reader :runner, :request, :response, :driver

      before do
        Thread.current[:connection] = connection
        @driver = "Selenium Driver"
        stub(Selenium::SeleniumDriver).new('localhost', 4444, '*firefox', 'http://localhost:8080') do
          driver
        end
      end

      describe "#post" do
        attr_reader :firefox_profile_path
        before do
          @request = Rack::Request.new( Rack::MockRequest.env_for('/runners/firefox') )
          @response = Rack::Response.new
          @runner = Runners::FirefoxRunner.new(request, response)
          stub(Thread).start.yields
        end

        it "keeps the connection open" do
          stub(driver).start
          stub(driver).open
          dont_allow(EventMachine).send_data
          dont_allow(EventMachine).close_connection
          runner.post(request, response)

          response.should_not be_ready
        end

        describe "when a spec_url is passed into the request" do
          before do
            request['spec_url'] = "http://127.0.0.1:8080/specs/subdir"
          end

          it "uses Selenium to run the specified spec suite in Firefox" do
            mock(driver).start
            mock(driver).open("http://127.0.0.1:8080/specs/subdir?guid=#{runner.guid}")

            runner.post(request, response)
          end
        end

        describe "when a spec_url is not passed into the request" do
          before do
            request['spec_url'].should be_nil
          end

          it "uses Selenium to run the entire spec suite in Firefox" do
            mock(driver).start
            mock(driver).open("http://127.0.0.1:8080/specs?guid=#{runner.guid}")

            runner.post(request, response)
          end
        end
      end

      describe "#finalize" do
        before do
          @request = Rack::Request.new( Rack::MockRequest.env_for('/runners/firefox') )
          @response = Rack::Response.new
          @runner = Runners::FirefoxRunner.new(request, response)
          stub(driver).start
          stub(driver).open
          runner.post(request, response)
        end

        it "kills the browser, sends the response body, and close the connection" do
          mock(driver).stop
          data = ""
          stub(EventMachine).send_data do |signature, data, data_length|
            data << data
          end
          mock(connection).close_connection_after_writing

          runner.finalize("The text")
          data.should include("The text")
        end
      end
    end
  end
end
