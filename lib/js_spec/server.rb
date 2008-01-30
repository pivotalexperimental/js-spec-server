module JsSpec
  class Server
    class << self
      attr_accessor :instance

      def run(spec_root_path, implementation_root_path, public_path, server_options = {})
        server_options[:Host] ||= DEFAULT_HOST
        server_options[:Port] ||= DEFAULT_PORT
        @instance = new(spec_root_path, implementation_root_path, public_path, server_options[:Host], server_options[:Port])
        Rack::Handler::Mongrel.run(instance, server_options)
      end

      def spec_root_path; instance.spec_root_path; end
      def implementation_root_path; instance.implementation_root_path; end
      def public_path; instance.public_path; end
      def core_path; instance.core_path; end
      def request; instance.request; end
      def response; instance.response; end
    end

    attr_reader :host, :port, :spec_root_path, :implementation_root_path, :core_path, :public_path

    def initialize(spec_root_path, implementation_root_path, public_path, host=DEFAULT_HOST, port=DEFAULT_PORT)
      dir = ::File.dirname(__FILE__)
      @core_path = ::File.expand_path("#{dir}/../../core")
      @spec_root_path = ::File.expand_path(spec_root_path)
      @implementation_root_path = ::File.expand_path(implementation_root_path)
      @public_path = ::File.expand_path(public_path)
      @host = host
      @port = port
    end
    
    def call(env)
      self.request = Rack::Request.new(env)
      self.response = Rack::Response.new
      method = request.request_method.downcase.to_sym
      response.body = get_resource.send(method)
      response.finish
    ensure
      self.request = nil
      self.response = nil
    end
    
    def run(path)
      system(%{firefox "http://#{host}:#{port}/#{path}"})
      Suite.new
    end

    def request
      Thread.current[:request]
    end

    def response
      Thread.current[:response]
    end
    
    protected
    def request=(request)
      Thread.current[:request] = request
    end

    def response=(response)
      Thread.current[:response] = response
    end

    def path_parts
      request.path_info.split('/').reject { |part| part == "" }
    end

    def get_resource
      path_parts.inject(Resources::WebRoot.new(public_path)) do |resource, child_resource_name|
        resource.locate(child_resource_name)
      end
    rescue Exception => e
      detailed_exception = Exception.new("Error handling path #{request.path_info}\n#{e.message}")
      detailed_exception.set_backtrace(e.backtrace)
      raise detailed_exception
    end
  end
end