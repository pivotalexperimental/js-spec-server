require File.expand_path("#{File.dirname(__FILE__)}/../unit_spec_helper")

module JsSpec
  describe RailsJsSpecConnection do
    it "subclasses JsSpecConnection" do
      RailsJsSpecConnection.superclass.should == JsSpecConnection
    end

    describe ".run" do
      attr_reader :rails_root
      before do
        @rails_root = "/rails/root"
        JsSpecConnection.instance = nil
      end

      it "initializes the RailsJsSpecConnection and runs the Thin Handler and sets JsSpecConnection.instance to the RailsJsSpecConnection instance" do
        host = DEFAULT_HOST
        port = DEFAULT_PORT
        server_instance = nil
        mock.proxy(RailsJsSpecConnection).new(
          rails_root,
          host,
          port
        ) do |new_instance|
          server_instance = new_instance
        end

        mock(EventMachine).run.yields
        mock(EventMachine).start_server(host, port, ::Thin::JsSpecConnection)
        RailsJsSpecConnection.run(rails_root)
        JsSpecConnection.instance.should == server_instance
      end
    end

    describe "#initialize" do
      it "sets the server paths based on the passed in rails root" do
        rails_root = "/rails/root"
        server = RailsJsSpecConnection.new(rails_root)
        server.spec_root_path.should == "#{rails_root}/spec/javascripts"
        server.implementation_root_path.should == "#{rails_root}/public/javascripts"
        server.public_path.should == "#{rails_root}/public"
      end
    end
  end
end