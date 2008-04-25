require File.expand_path("#{File.dirname(__FILE__)}/../../unit_spec_helper")

module JsSpec
  module Resources
    describe SpecFile, "#spec_files" do
      attr_reader :absolute_path, :relative_path, :file

      before do
        @absolute_path = "#{spec_root_path}/failing_spec.js"
        @relative_path = "/specs/failing_spec.js"
        @file = SpecFile.new(absolute_path, relative_path)
      end

      it "returns the single File to run in an Array" do
        file.spec_files.should == [file]
      end
    end
  end
end