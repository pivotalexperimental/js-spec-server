require File.expand_path("#{File.dirname(__FILE__)}/unit_spec_helper")

module JsSpec
  describe WebRoot do
    attr_reader :root_dir
    before(:each) do
      @root_dir = WebRoot.new
    end

    describe "#locate" do
      it "when passed 'specs', returns a SpecDirRunner representing the specs" do
        runner = root_dir.locate('specs')
        runner.should == spec_dir
      end

      it "when passed 'core', returns a Dir representing the JsSpec core directory" do
        runner = root_dir.locate('core')
        runner.should == JsSpec::Dir.new(JsSpec::Server.core_path, '/core')
      end
      
      it "when passed 'implementations', returns a Dir representing the javascript implementations directory" do
        runner = root_dir.locate('implementations')
        runner.should == JsSpec::Dir.new(JsSpec::Server.implementation_root_path, '/implementations')
      end

      it "when passed 'results', returns a SuiteResult" do
        runner = root_dir.locate('results')
        runner.should be_instance_of(JsSpec::SuiteResult)
      end

      it "when not passed 'core' or 'specs', raises an error" do
        lambda do
          root_dir.locate('invalid')
        end.should raise_error
      end
    end
  end

end
