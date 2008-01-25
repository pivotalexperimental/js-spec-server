module JsSpec
  class RailsServer < Server
    class << self
      def run(rails_root, server_options = {})
        server_options[:Host] ||= Server::DEFAULT_HOST
        server_options[:Port] ||= Server::DEFAULT_PORT
        Server.instance = new(rails_root, server_options[:Host], server_options[:Port])
        Rack::Handler::Mongrel.run(Server.instance, server_options)
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