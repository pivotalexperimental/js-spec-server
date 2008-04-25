module JsSpec
  module Resources
    class SpecDir < Spec
      attr_reader :dir

      def initialize(dir)
        @dir = dir
      end

      def spec_files
        dir.glob("/**/*_spec.js")
      end
    end
  end
end