require File.expand_path("#{File.dirname(__FILE__)}/../unit_spec_helper")

module Thin
  describe JsSpecConnection do
    describe "#process" do
      attr_reader :connection
      before do
        stub(EventMachine).get_peername {['0.0.0.0']}
        stub(EventMachine).send_data
        @connection = JsSpecConnection.new('signature')
        mock(app = Object.new).call(is_a(Hash)) do
          ['200', {}, '']
        end
        connection.app = app
        connection.post_init
      end

      describe "with a request to /servers" do
        it "keeps the response and connection open after finishing" do
          dont_allow(connection.response).close
          dont_allow(EventMachine).close_connection
          connection.receive_data "GET /servers HTTP/1.1\r\nHost: _\r\n\r\n"
        end
      end

      describe "with a request not to /servers" do
        it "closes the response and connection after finishing" do
          mock.proxy(connection.response).close
          mock(EventMachine).close_connection('signature', true)
          connection.receive_data "GET /specs HTTP/1.1\r\nHost: _\r\n\r\n"
        end
      end
    end
  end
end