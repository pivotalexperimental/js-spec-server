module JsSpec
  module Resources
    class SpecFile < File
      include Spec
      
      def spec_files
        [self]
      end
    end
  end
end