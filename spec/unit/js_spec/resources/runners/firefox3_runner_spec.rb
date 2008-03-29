require File.expand_path("#{File.dirname(__FILE__)}/../../../unit_spec_helper")

module JsSpec
  module Resources
    describe Runners::Firefox1Runner do
      attr_reader :runner, :request, :response
      describe "#post" do
        attr_reader :firefox_profile_path
        before do
          @request = nil
          @response = nil
          @runner = Runners::Firefox1Runner.new(request, response)
          dir = ::File.dirname(__FILE__)
          @firefox_profile_path = ::File.expand_path("#{dir}/../../../../../resources/firefox")
          ::File.should be_directory(firefox_profile_path)
        end

        it "returns ''" do
          pending "reimplement when using nonblocking IO"
          guid = 'foobar'
          # stub.proxy(UUID).new {|guid| guid = guid}
          stub(runner).system {true}

          post_return_value = nil
          Thread.start do
            post_return_value = runner.post
          end
          wait_for do
            Runners::Firefox1Runner.threads[guid]
          end
          Runners::Firefox1Runner.resume(guid, 'text from the browser')

          wait_for do
            post_return_value == 'text from the browser'
          end
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
          mock(runner).system(runner.command_for(:kill_browser)).ordered {true}
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
          before do
            @request = Rack::MockRequest.new(server)
            @response = nil
            @runner = Runners::Firefox1Runner.new(request, response)
          end

          describe ", and the request url parameter is not set" do
            before do
              mock(request).[]('url') {nil}
            end

            it "starts a firefox browser in a thread" do
              runner.command_for(:start_browser).should == "firefox -profile '#{runner.profile_dir}' #{Server.root_url}/specs?guid=#{runner.guid}"
            end
          end

          describe ", and the request url parameter is set" do
            attr_reader :url
            before do
              @url = 'http://foobar.com/specs/foo/passing_spec'
              mock(request).[]('url') {url}.at_least(1)
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