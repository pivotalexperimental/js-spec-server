require File.expand_path("#{File.dirname(__FILE__)}/integration_spec_helper")

describe "JsSpec" do
  it "runs a full passing Suite" do
    mock(JsSpec::Client).puts("SUCCESS")
    JsSpec::Client.run("#{root_url}/specs/foo/passing_spec")
  end
end