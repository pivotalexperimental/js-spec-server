require File.expand_path("#{File.dirname(__FILE__)}/../unit_spec_helper")

module JsTestCore
  describe Server do
    attr_reader :result
    
    before do
      @result = ""
      stub(EventMachine).send_data do |signature, data, data_length|
        @result << data
      end
      stub(EventMachine).close_connection
    end

    describe "HTTP GET" do
      specify "'/core/JsTestCore.js', returns the contents of the file" do
        response = get("/core/JsTestCore.js")
        response.body.should == ::File.read("#{Server.core_path}/JsTestCore.js")
      end

      specify "'/stylesheets/example.css', returns the contents of the file" do
        response = get("/stylesheets/example.css")
        response.body.should == ::File.read("#{Server.public_path}/stylesheets/example.css")
      end

      specify "'/invalid/path', shows the full invalid path in the error message" do
        lambda do
          get("/invalid/path")
        end.should raise_error(Exception, Regexp.new("/invalid/path"))
      end
    end

    describe ".run" do
      attr_reader :server_instance
      before do
        @server_instance = Server.instance
        Server.instance = nil
      end

      it "instantiates an instance of Server and starts a Rack Thin handler" do
        host = DEFAULT_HOST
        port = DEFAULT_PORT

        mock(EventMachine).run.yields
        mock(EventMachine).start_server(host, port, ::Thin::JsTestCoreConnection)

        Server.run(spec_root_path, implementation_root_path, public_path)
      end

      it "when passed a custom host and port, sets the host and port to the passed in value" do
        host = 'foobar.com'
        port = 80

        mock(EventMachine).run.yields
        mock(EventMachine).start_server(host, port, ::Thin::JsTestCoreConnection)

        Server.run(spec_root_path, implementation_root_path, public_path, {:Host => host, :Port => port})
      end
    end

    describe ".spec_root" do
      it "returns the Dir " do
        Server.spec_root_path.should == spec_root_path
      end
    end

    describe ".spec_root_path" do
      it "returns the absolute path of the specs root directory" do
        Server.spec_root_path.should == spec_root_path
      end
    end

    describe ".public_path" do
      it "returns the expanded path of the public path" do
        Server.public_path.should == public_path
      end
    end

    describe ".core_path" do
      it "returns the expanded path to the JsTestCore core directory" do
        Server.core_path.should == core_path
      end
    end

    describe ".implementation_root_path" do
      it "returns the expanded path to the JsTestCore implementations directory" do
        dir = ::File.dirname(__FILE__)
        Server.implementation_root_path.should == implementation_root_path
      end
    end

    describe "#call" do
      describe "when there is an error" do
        attr_reader :top_line_of_backtrace
        before do
          @top_line_of_backtrace = __LINE__ + 2
          stub.instance_of(Resources::WebRoot).locate('somedir') do
            raise "Foobar"
          end
        end

        it "shows the full request path in the error message" do
          lambda do
            get('/somedir')
          end.should raise_error(Exception, Regexp.new("/somedir"))
        end

        it "uses the backtrace from where the original error was raised" do
          no_error = true
          begin
            get('/somedir')
          rescue Exception => e
            no_error = false
            top_of_backtrace = e.backtrace.first.split(":")
            backtrace_file = ::File.expand_path(top_of_backtrace[0])
            backtrace_line = Integer(top_of_backtrace[1])
            backtrace_file.should == __FILE__
            backtrace_line.should == top_line_of_backtrace
          end
          raise "There should have been an error" if no_error
        end
      end
    end

    describe "#root_url" do
      it "returns the url of the site's root" do
        server.root_url.should == "http://#{server.host}:#{server.port}"
      end
    end
  end
end