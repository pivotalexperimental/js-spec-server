require File.expand_path("#{File.dirname(__FILE__)}/integration_spec_helper")

describe "JsSpec" do
  attr_reader :stdout, :request
  before do
    @stdout = StringIO.new
    JsSpec::Client.const_set(:STDOUT, stdout)
    @request = "http request"
  end

  after do
    JsSpec::Client.__send__(:remove_const, :STDOUT)
  end

  it "runs a full passing Suite" do
    JsSpec::Client.run(:spec_url => "#{root_url}/specs/foo/passing_spec")
    stdout.string.strip.should == "SUCCESS"
  end

  it "runs a full failing Suite" do
    JsSpec::Client.run(:spec_url => "#{root_url}/specs/foo/failing_spec")
    stdout.string.strip.should include("FAILURE")
    stdout.string.strip.should include("A failing spec in foo fails")
  end
end
