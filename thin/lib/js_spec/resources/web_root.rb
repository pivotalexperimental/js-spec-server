module JsSpec
  module Resources
    class WebRoot
      attr_reader :public_path
      def initialize(public_path)
        @public_path = ::File.expand_path(public_path)
      end

      def locate(name)
        case name
        when 'specs'
          Resources::Dir.new(JsSpec::Server.spec_root_path, "/specs")
        when 'core'
          Resources::Dir.new(JsSpec::Server.core_path, "/core")
        when 'implementations'
          Resources::Dir.new(JsSpec::Server.implementation_root_path, "/implementations")
        when 'suites'
          Resources::Suite
        when 'runners'
          Resources::Runners.new
        else
          potential_file_in_public_path = "#{public_path}/#{name}"
          if ::File.directory?(potential_file_in_public_path)
            Resources::Dir.new(potential_file_in_public_path, "/#{name}")
          elsif ::File.exists?(potential_file_in_public_path)
            Resources::File.new(potential_file_in_public_path, "/#{name}")
          else
            raise "Invalid path: #{name}"
          end
        end
      end
    end
  end
end