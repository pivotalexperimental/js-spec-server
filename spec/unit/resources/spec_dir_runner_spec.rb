require File.expand_path("#{File.dirname(__FILE__)}/../unit_spec_helper")

module JsSpec
  module Resources
    describe SpecDirRunner do
      attr_reader :dir, :runner

      before do
        @dir = Dir.new(spec_root_path, '/specs')
        @runner = SpecDirRunner.new(dir)
      end

      describe "#spec_files" do
        it "returns a File for each *_spec.js file in the directory" do
          spec_files = runner.spec_files

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
          runner.get(request, response)
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
          doc.at("body").inner_html.should be_empty
        end
      end
    end
  end
end