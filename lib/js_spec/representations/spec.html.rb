module JsSpec
  module Representations
    class Spec < JsTestCore::Representations::Spec
      def title_text
        "Screw Unit suite"
      end

      def head_content
        link :rel => "stylesheet", :type => "text/css", :href => "/core/JSSpec.css"
        script :type => "text/javascript", :src => "/core/diff_match_patch.js"
        script :type => "text/javascript", :src => "/core/JSSpec.js"
        script :type => "text/javascript", :src => "/core/JSSpecExtensions.js"

        spec_script_elements
      end

      def body_content
        div :id => "js_spec_content"
      end
    end
  end
end