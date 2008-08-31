require File.expand_path("#{File.dirname(__FILE__)}/../../unit_spec_helper")

module JsTestCore
  module Resources
    module Specs
      describe SpecFile do
        describe "GET /specs/failing_spec" do
          attr_reader :html, :doc
          before do
            mock(connection).send_head
            mock(connection).send_body(anything) do |@html|
              # do nothing
            end

            connection.receive_data("GET /specs/failing_spec HTTP/1.1\r\nHost: _\r\n\r\n")
            @doc = Hpricot(html)
          end

          it "returns script tags for the test javascript file" do
            doc.at("script[@src='/specs/failing_spec.js']").should exist
          end

          it "returns the screw unit template" do
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
