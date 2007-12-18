require File.expand_path("#{File.dirname(__FILE__)}/unit_spec_helper")

module JsSpec
  describe Server do
    describe "HTTP GET" do
      specify "'/specs' returns an HTML test runner including all specs files" do
        result = get("/specs").body
        result.should include('<script type="text/javascript" src="/specs/failing_spec.js"></script>')
        result.should include('<script type="text/javascript" src="/specs/foo/failing_spec.js"></script>')
        result.should include('<script type="text/javascript" src="/specs/foo/passing_spec.js"></script>')
      end

      specify "'/specs/failing_spec', returns an HTML test runner including it" do
        result = get("/specs/failing_spec").body
        result.should include('<script type="text/javascript" src="/specs/failing_spec.js"></script>')
      end

      specify "'/specs/foo', returns an HTML test runner including all specs below foo" do
        result = get("/specs/foo").body
        result.should include('<script type="text/javascript" src="/specs/foo/failing_spec.js"></script>')
        result.should include('<script type="text/javascript" src="/specs/foo/passing_spec.js"></script>')
      end

      specify "'/specs/nonexistent', raises an error" do
        lambda { get("/specs/nonexistent") }.should raise_error
      end

      specify "'/core/JSSpec.js', returns the contents of the file" do
        result = get("/core/JSSpec.js").body
        result.should == ::File.read("#{Server.core_path}/JSSpec.js")
      end
    end

    describe ".run" do
      attr_reader :server_instance
      before do
        @server_instance = Server.instance
        Server.instance = nil
      end

      it "instantiates an instance of Server and starts a Rack Mongrel handler" do
        host = Server::DEFAULT_HOST
        port = Server::DEFAULT_PORT

        mock.proxy(Server).new(spec_root_path, implementation_root_path, host, port) do
          server_instance
        end
        mock(Rack::Handler::Mongrel).run(server_instance, {:Host => host, :Port => port})

        Server.run(spec_root_path, implementation_root_path)
      end

      it "when passed a custom host and port, sets the host and port to the passed in value" do
        host = 'foobar.com'
        port = 80

        mock.proxy(Server).new(spec_root_path, implementation_root_path, host, port) do
          server_instance
        end
        mock(Rack::Handler::Mongrel).run(server_instance, {:Host => host, :Port => port})

        Server.run(spec_root_path, implementation_root_path, {:Host => host, :Port => port})
      end
    end

    describe ".spec_root" do
      it "returns the Dir " do
        Server.spec_root_path.should == ::File.expand_path(spec_root_path)
      end
    end

    describe ".spec_root_path" do
      it "returns the absolute path of the specs root directory" do
        Server.spec_root_path.should == ::File.expand_path(spec_root_path)
      end
    end

    describe ".core_path" do
      it "returns the expanded path to the JsSpec core directory" do
        dir = ::File.dirname(__FILE__)
        Server.core_path.should == ::File.expand_path("#{dir}/../../core")
      end
    end

    describe ".implementation_root_path" do
      it "returns the expanded path to the JsSpec implementations directory" do
        dir = ::File.dirname(__FILE__)
        Server.implementation_root_path.should == ::File.expand_path(implementation_root_path)
      end
    end

    describe ".request" do
      it "returns request in progress for the thread" do
        the_request = nil
        stub.instance_of(WebRoot).locate('somedir') do
          the_request = JsSpec::Server.request
          Thread.current[:request].should == the_request
          thread2 = Thread.new do
            Thread.current[:request].should be_nil
          end
          thread2.join

          mock_resource = Object.new
          stub(mock_resource).get.returns("")
          mock_resource
        end

        get('/somedir')

        the_request.path_info.should == '/somedir'
      end

      it "resets to nil when the request is finished" do
        get('/core')

        JsSpec::Server.request.should be_nil
      end
    end

    describe ".response" do
      it "returns response in progress" do
        the_response = nil
        stub.instance_of(WebRoot).locate('somedir') do
          the_response = JsSpec::Server.response
          Thread.current[:response].should == the_response
          thread2 = Thread.new do
            Thread.current[:response].should be_nil
          end
          thread2.join

          mock_resource = Object.new
          stub(mock_resource).get {"The text"}
          mock_resource
        end

        get('/somedir')

        the_response.body.should == 'The text'
      end

      it "resets to nil when the response is finished" do
        get('/core')

        JsSpec::Server.response.should be_nil
      end
    end

    describe "#initialize" do
      it "expands relative paths for #spec_root_path and #implementation_root_path" do
        server = Server.new("foo", "bar")
        server.spec_root_path.should == ::File.expand_path("foo")
        server.implementation_root_path.should == ::File.expand_path("bar")
      end
    end
  end
end