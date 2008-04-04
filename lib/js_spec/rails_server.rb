module JsSpec
  class RailsServer < JsSpecConnection
    class << self
      def run(rails_root, server_options = {})
        server_options[:Host] ||= DEFAULT_HOST
        server_options[:Port] ||= DEFAULT_PORT
        JsSpecConnection.instance = new(rails_root, server_options[:Host], server_options[:Port])
        JsSpecConnection.instance.run server_options
      end
    end

    def initialize(rails_root, host=DEFAULT_HOST, port=DEFAULT_PORT)
      super(
        "#{rails_root}/spec/javascripts",
        "#{rails_root}/public/javascripts",
        "#{rails_root}/public",
        host,
        port
      )
    end
  end
end