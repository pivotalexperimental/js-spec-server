require File.expand_path("#{File.dirname(__FILE__)}/unit_spec_helper")

module JsSpec
  describe Dir do
    attr_reader :dir, :absolute_path, :relative_path

    describe "in core dir" do
      before do
        @absolute_path = core_path
        @relative_path = "/core"
        @dir = JsSpec::Dir.new(absolute_path, relative_path)
      end

      describe "#locate when passed a name of a real file" do
        it "returns a JsSpec::File representing it" do
          file = dir.locate("JSSpec.css")
          file.relative_path.should == "/core/JSSpec.css"
          file.absolute_path.should == "#{core_path}/JSSpec.css"
        end
      end
    end

    describe "in specs dir" do
      before do
        @absolute_path = spec_root_path
        @relative_path = "/specs"
        @dir = JsSpec::Dir.new(absolute_path, relative_path)
      end

      it "has an absolute path" do
        dir.absolute_path.should == absolute_path
      end

      it "has a relative path" do
        dir.relative_path.should == relative_path
      end

      describe "#locate when passed the name with an extension" do
        it "when file exists, returns a JsSpec::File representing it" do
          file = dir.locate("failing_spec.js")
          file.relative_path.should == "/specs/failing_spec.js"
          file.absolute_path.should == "#{spec_root_path}/failing_spec.js"
        end

        it "when file does not exist, raises error" do
          lambda { dir.locate("nonexistent.js") }.should raise_error
        end
      end

      describe "#locate when passed a name without an extension" do
        it "when the name corresponds to a .js file in the directory, returns a SpecFileRunner for the file" do
          file_runner = dir.locate("failing_spec")
          file_runner.should be_an_instance_of(SpecFileRunner)
          file_runner.file.should == spec_file("/failing_spec.js")
        end

        it "when name corresponds to a subdirectory, returns a DirectoryRunner for the directory" do
          subdir = dir.locate("foo")
          subdir.should be_an_instance_of(JsSpec::Dir)
          subdir.should == spec_dir("/foo")
        end

        it "when name does not correspond to a .js file or directory, raises an error" do
          lambda do
            dir.locate("nonexistent")
          end.should raise_error
        end
      end

      describe Dir, "#glob" do
        it "returns an array of matching Files under this directory with the correct relative paths" do
          globbed_files = dir.glob("/**/*_spec.js")

          globbed_files.size.should == 3
          globbed_files.should contain_spec_file_with_correct_paths("/failing_spec.js")
          globbed_files.should contain_spec_file_with_correct_paths("/foo/failing_spec.js")
          globbed_files.should contain_spec_file_with_correct_paths("/foo/passing_spec.js")
        end
      end      
    end
  end
end
