require File.expand_path("#{File.dirname(__FILE__)}/integration_spec_helper")

describe "JsSpec" do
  it "runs a full passing Suite" do
    JsSpec::Client.run
  end
end