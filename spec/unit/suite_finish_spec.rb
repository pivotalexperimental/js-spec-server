require File.expand_path("#{File.dirname(__FILE__)}/unit_spec_helper")

module JsSpec
  describe SuiteFinish do
    attr_reader :stdout, :suite_finish, :suite
    before do
      @stdout = StringIO.new
      SuiteFinish.const_set(:STDOUT, stdout)
      @suite = Suite.new('foobar')
      @suite_finish = SuiteFinish.new(suite)
    end
    
    after do
      SuiteFinish.__send__(:remove_const, :STDOUT)
    end
    
    describe ".post" do
      describe "when the request has no guid" do
        it "writes the body of the request to stdout" do
          body = "The text in the POST body"
          request = Rack::Request.new({'rack.input' => StringIO.new("text=#{body}")})
          request.body.string.should == "text=#{body}"
          stub.proxy(Server).request {request}

          suite_finish.post
          stdout.string.should == "#{body}\n"
        end

        it "returns an empty string" do
          body = "The text in the POST body"
          request = Rack::Request.new({'rack.input' => StringIO.new("text=#{body}")})
          request.body.string.should == "text=#{body}"
          stub.proxy(Server).request {request}

          suite_finish.post.should == ""
        end
      end
    end
  end
end
