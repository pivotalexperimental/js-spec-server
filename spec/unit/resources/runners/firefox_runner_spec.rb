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
        guid = nil
        stub.proxy(UUID).new {|guid| guid = guid}
        stub(runner).system {true}
        stub(runner).sleep(0.5)
        stub(runner).sleep {Kernel.sleep}

        post_return_value = nil
        Thread.start do
          post_return_value = runner.post
        end
        wait_for do
          Runners::FirefoxRunner.threads[guid]
        end
        Runners::FirefoxRunner.resume(guid, 'foobar')

        wait_for do
          post_return_value == 'foobar'
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
        "and creates a profile " <<
        "and waits for profile to be created " <<
        "and starts firefox" do
        stub(runner).sleep

        mock(runner).system("cp -R #{firefox_profile_path} #{runner.profile_dir}").ordered {true}
        mock(runner).system("firefox -profile #{runner.profile_dir} -chrome chrome://killff/content/kill.html").ordered {true}
        mock(::File).exists?("#{runner.profile_dir}/parent.lock").ordered {false}
        mock(runner).sleep(0.5).ordered
        mock(::File).exists?("#{runner.profile_dir}/parent.lock").ordered {false}
        mock(runner).system(Regexp.new("firefox -profile #{runner.profile_dir} http://localhost:8080/specs")).ordered {true}
        stub(runner).callcc
        runner.post
      end

      it "calls #copy_profile_files, #create_profile, #wait_for_full_profile_to_be_created, and #start_browser" do
        stub(runner).system {true}
        stub(runner).sleep
        stub(runner).callcc

        mock.proxy(runner).copy_profile_files.ordered
        mock.proxy(runner).create_profile.ordered
        mock.proxy(runner).wait_for_full_profile_to_be_created.ordered
        mock.proxy(runner).start_browser(is_a(String)).ordered

        runner.post
      end
    end

    describe "#start_browser" do
      it "starts a firefox browser in a thread" do
        mock(Thread).start.yields
        mock(runner).system("firefox -profile #{runner.profile_dir} http://localhost:8080/specs?guid=foobar").ordered {true}
        runner.__send__(:start_browser, "foobar")
      end
    end
  end
  end
end