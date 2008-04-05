require File.expand_path("#{File.dirname(__FILE__)}/integration_spec_helper")

describe "JsSpec" do
  it "runs a full passing Suite" do
    mock(JsSpec::Client).puts("SUCCESS")
    JsSpec::Client.run(:spec_url => "#{root_url}/specs/foo/passing_spec")
  end

  it "runs a full failing Suite" do
    mock(JsSpec::Client).puts("FAILURE")
    mock(JsSpec::Client).puts(/A failing spec in foo fails/)
    JsSpec::Client.run(:spec_url => "#{root_url}/specs/foo/failing_spec")
  end
end
