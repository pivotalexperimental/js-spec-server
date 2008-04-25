require File.expand_path("#{File.dirname(__FILE__)}/../../unit_spec_helper")

module JsSpec
  module Resources
    describe SpecDir do
      attr_reader :dir

      before do
        stub(EventMachine).send_data
        stub(EventMachine).close_connection
        @dir = SpecDir.new(spec_root_path, '/specs')
      end

      describe "#spec_files" do
        it "returns a File for each *_spec.js file in the directory" do
          spec_files = dir.spec_files

          spec_files.should contain_spec_file_with_correct_paths("/failing_spec.js")
          spec_files.should contain_spec_file_with_correct_paths("/foo/failing_spec.js")
          spec_files.should contain_spec_file_with_correct_paths("/foo/passing_spec.js")
        end
      end

      describe "#get" do
        attr_reader :html, :doc
        before do
          request = request('get', '/specs')
          response = Rack::Response.new
          dir.get(request, response)
          @html = response.body
          @doc = Hpricot(html)
        end

        it "returns script tags for each test javascript file" do
          doc.at("script[@src='/specs/failing_spec.js']").should exist
        end

        it "returns the js specs template" do
          doc.at("link[@href='/core/JSSpec.css']").should exist
          doc.at("script[@src='/core/JSSpec.js']").should exist
          doc.at("script[@src='/core/JSSpecExtensions.js']").should exist
          doc.at("body/#js_spec_content").should_not be_nil
        end
      end

      describe "#locate when passed a name without an extension" do
        it "when the name corresponds to a .js file in the directory, returns a SpecFile for the file" do
          spec_file = dir.locate("failing_spec")
          spec_file.should be_an_instance_of(SpecFile)
          spec_file.relative_path.should == "/specs/failing_spec.js"
        end

        it "when name corresponds to a subdirectory, returns a DirectoryRunner for the directory" do
          subdir = dir.locate("foo")
          subdir.should be_an_instance_of(Resources::SpecDir)
          subdir.should == JsSpec::Resources::SpecDir.new("#{spec_root_path}/foo", "/specs/foo")
        end

        it "when name does not correspond to a .js file or directory, raises an error" do
          lambda do
            dir.locate("nonexistent")
          end.should raise_error
        end
      end
    end
  end
end