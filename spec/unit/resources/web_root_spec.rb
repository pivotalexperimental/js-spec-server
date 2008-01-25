require File.expand_path("#{File.dirname(__FILE__)}/../unit_spec_helper")

module JsSpec
  module Resources
    describe WebRoot do
      attr_reader :web_root
      before(:each) do
        @web_root = WebRoot.new(public_path)
      end

      describe "#locate" do
        it "when passed 'specs', returns a SpecDirRunner representing the specs" do
          runner = web_root.locate('specs')
          runner.should == spec_dir
        end

        it "when passed 'core', returns a Dir representing the JsSpec core directory" do
          runner = web_root.locate('core')
          runner.should == Resources::Dir.new(JsSpec::Server.core_path, '/core')
        end

        it "when passed 'implementations', returns a Dir representing the javascript implementations directory" do
          runner = web_root.locate('implementations')
          runner.should == Resources::Dir.new(JsSpec::Server.implementation_root_path, '/implementations')
        end

        it "when passed 'results', returns a Suite" do
          runner = web_root.locate('suites')
          runner.should == Resources::Suite
        end

        it "when passed 'runners', returns a Runner" do
          runner = web_root.locate('runners')
          runner.should be_instance_of(Resources::Runners)
        end

        it "when passed a directory that is in the public_path, returns a Dir representing that directory" do
          runner = web_root.locate('stylesheets')
          runner.should == Resources::Dir.new("#{JsSpec::Server.public_path}/stylesheets", '/stylesheets')
        end

        it "when passed a file that is in the public_path, returns a File representing that file" do
          runner = web_root.locate('robots.txt')
          runner.should == Resources::File.new("#{JsSpec::Server.public_path}/robots.txt", '/robots.txt')
        end

        it "when not passed 'core' or 'specs', raises an error" do
          lambda do
            web_root.locate('invalid')
          end.should raise_error
        end
      end
    end
  end
end
