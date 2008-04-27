require File.expand_path("#{File.dirname(__FILE__)}/../../unit_spec_helper")

module JsTestCore
  module Resources
    module Specs
      describe SpecDir do
        attr_reader :dir

        before do
          stub(EventMachine).send_data
          stub(EventMachine).close_connection
          @dir = SpecDir.new(spec_root_path, '/specs')
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
            doc.at("script[@src='/specs/foo/failing_spec.js']").should exist
            doc.at("script[@src='/specs/foo/passing_spec.js']").should exist
          end

          it "returns the js specs template" do
            doc.at("link[@href='/core/JSSpec.css']").should exist
            doc.at("script[@src='/core/JSSpec.js']").should exist
            doc.at("script[@src='/core/JSSpecExtensions.js']").should exist
            doc.at("body/#js_spec_content").should_not be_nil
          end
        end
      end
    end
  end
end