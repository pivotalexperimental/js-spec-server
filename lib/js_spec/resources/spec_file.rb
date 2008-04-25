module JsSpec
  module Resources
    class SpecFile < Spec
      attr_reader :file

      def initialize(file)
        @file = file
      end

      def spec_files
        [file]
      end
    end
  end
end