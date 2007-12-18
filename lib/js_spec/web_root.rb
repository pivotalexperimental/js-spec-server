module JsSpec
  class WebRoot
    def locate(name)
      case name
      when 'specs'
        JsSpec::Dir.new(JsSpec::Server.spec_root_path, "/specs")
      when 'core'
        JsSpec::Dir.new(JsSpec::Server.core_path, "/core")
      when 'implementations'
        JsSpec::Dir.new(JsSpec::Server.implementation_root_path, "/implementations")
      when 'results'
        JsSpec::SuiteResult.new
      else
        raise "Invalid path: #{name}"
      end
    end
  end
end