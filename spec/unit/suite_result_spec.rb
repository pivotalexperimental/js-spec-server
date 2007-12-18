require File.expand_path("#{File.dirname(__FILE__)}/unit_spec_helper")

module JsSpec
  describe SuiteResult do
    attr_reader :result
    before do
      @result = SuiteResult.new
    end

    describe "#post" do
      attr_reader :stdout
      before do
        @stdout = StringIO.new
        SuiteResult.const_set(:STDOUT, stdout)
      end
      after do
        SuiteResult.__send__(:remove_const, :STDOUT)
      end

      it "writes the body of the request to stdout" do
        body = "The text in the POST body"
        request = Rack::Request.new({'rack.input' => StringIO.new("text=#{body}")})
        request.body.string.should == "text=#{body}"
        stub.proxy(Server).request {request}

        result.post
        stdout.string.should == "#{body}\n"
      end
    end
  end
end
