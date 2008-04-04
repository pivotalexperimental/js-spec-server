require File.expand_path("#{File.dirname(__FILE__)}/../../../unit_spec_helper")

module JsSpec
  module Resources
    describe Runners::Firefox1Runner do
      attr_reader :runner, :request, :response
      describe "#post" do
        attr_reader :firefox_profile_path
        before do
          @request = Rack::Request.new( Rack::MockRequest.env_for('/runners/firefox') )
          @response = Rack::Response.new
          @runner = Runners::Firefox1Runner.new(request, response)
          dir = ::File.dirname(__FILE__)
          @firefox_profile_path = ::File.expand_path("#{dir}/../../../../../resources/firefox")
          ::File.should be_directory(firefox_profile_path)
        end

        it "returns ''" do
          guid = 'foobar'
          stub(runner).system {true}

          runner.post
          Runners::Firefox1Runner.resume(guid, 'text from the browser')

          response.body.should == 'text from the browser'
        end

        it "copies the firefox profile files to a tmp directory " <<
          "and initializes a profile " <<
          "and tests that the profile is created " <<
          "and starts firefox" <<
          "and kills firefox" do
          stub(runner).sleep

          mock(runner).system(runner.command_for(:copy_profile)).ordered {true}
          mock(runner).system(runner.command_for(:init_profile)).ordered {true}
          mock(runner).system(runner.command_for(:test_profile)).ordered {true}
          mock(runner).system(runner.command_for(:start_browser)).ordered {true}
          runner.post
        end

        def wait_for(timeout=5)
          Timeout.timeout(timeout) do
            loop do
              break if yield
            end
          end
        end
      end

      describe "#finalize" do
        before do
          @request = Rack::Request.new( Rack::MockRequest.env_for('/runners/firefox') )
          @response = Rack::Response.new
          @runner = Runners::Firefox1Runner.new(request, response)
        end

        it "kills the browser and sets the response body" do
          mock(runner).system(runner.command_for(:kill_browser)).ordered {true}
          runner.finalize("The text")
        end
      end

      describe "#start_browser" do
        describe "when there is no current request" do
          before do
            @request = nil
            @response = nil
            @runner = Runners::Firefox1Runner.new(request, response)
          end
          
          it "starts a firefox browser in a thread" do
            runner.command_for(:start_browser).should == "firefox -profile '#{runner.profile_dir}' #{Server.root_url}/specs?guid=#{runner.guid}"
          end
        end

        describe "when there is a current request" do
          describe ", and the request url parameter is not set" do
            before do
              @request = Rack::Request.new(Rack::MockRequest.env_for('/runners/firefox'))
              @response = nil
              @runner = Runners::Firefox1Runner.new(request, response)
              request['url'].should be_nil
            end

            it "starts a firefox browser in a thread" do
              runner.command_for(:start_browser).should == "firefox -profile '#{runner.profile_dir}' #{Server.root_url}/specs?guid=#{runner.guid}"
            end
          end

          describe ", and the request url parameter is set" do
            attr_reader :url
            before do
              @url = 'http://example.org/specs/foo/passing_spec'
              @request = Rack::Request.new(Rack::MockRequest.env_for("/runners/firefox?url=#{url}"))
              @response = nil
              @runner = Runners::Firefox1Runner.new(request, response)
              request['url'].should == url
            end
            
            it "runs the Firefox Browser for the passed in url" do
              runner.command_for(:start_browser).should == "firefox -profile '#{runner.profile_dir}' #{url}?guid=#{runner.guid}"
            end
          end
        end
      end
    end
  end
end
