require File.expand_path("#{File.dirname(__FILE__)}/../../unit_spec_helper")

module JsSpec
  module Resources
    describe Runners::FirefoxRunner do
    attr_reader :runner
    before do
      @runner = Runners::FirefoxRunner.new
    end

    describe "#post" do
      attr_reader :firefox_profile_path
      before do
        dir = ::File.dirname(__FILE__)
        @firefox_profile_path = ::File.expand_path("#{dir}/../../../../resources/firefox")
        ::File.should be_directory(firefox_profile_path)
      end

      it "returns ''" do
        guid = 'foobar'
        # stub.proxy(UUID).new {|guid| guid = guid}
        stub(runner).system {true}

        post_return_value = nil
        Thread.start do
          post_return_value = runner.post
        end
        wait_for do
          Runners::FirefoxRunner.threads[guid]
        end
        Runners::FirefoxRunner.resume(guid, 'text from the browser')

        wait_for do
          post_return_value == 'text from the browser'
        end
      end

      def wait_for(timeout=5)
        Timeout.timeout(timeout) do
          loop do
            break if yield
          end
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
    end

    describe "#start_browser" do
      it "starts a firefox browser in a thread" do
        runner.command_for(:start_browser).should == "firefox -profile #{runner.profile_dir} http://localhost:8080/specs?guid=#{runner.guid}"
      end
    end
  end
  end
end