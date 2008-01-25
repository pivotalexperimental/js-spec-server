module JsSpec
  class SpecDirRunner < SpecRunner
    attr_reader :dir
    
    def initialize(dir)
      @dir = dir
    end
    
    def spec_files
      dir.glob("/**/*_spec.js")
    end
  end
end