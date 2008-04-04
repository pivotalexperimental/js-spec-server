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
    end
  end
end