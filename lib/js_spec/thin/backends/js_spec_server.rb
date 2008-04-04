module Thin
  module Backends
    class JsSpecServer < TcpServer
      def connect
        @signature = EventMachine.start_server(@host, @port, JsSpecConnection, &method(:initialize_connection))
      end
    end
  end
end