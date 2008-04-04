require "rubygems"
dir = File.dirname(__FILE__)
$LOAD_PATH.unshift "#{dir}/../../../plugins/rspec/lib"
require "spec"

$LOAD_PATH.unshift "#{dir}/../../lib"
require "js_spec"
require "hpricot"

Spec::Runner.configure do |config|
  config.mock_with :rr
end

module Spec::Example::ExampleMethods
  attr_reader :spec_root_path, :implementation_root_path, :public_path
  before(:all) do
    dir = File.dirname(__FILE__)
    @spec_root_path = "#{dir}/../example_specs"
    @public_path = "#{dir}/../example_public"
    @implementation_root_path = "#{public_path}/javascripts"
    unless $js_spec_server_started
      Thread.start do
        JsSpec::JsSpecConnection.run(spec_root_path, implementation_root_path, public_path)
      end
      $js_spec_server_started = true
    end
  end

  def root_url
    "http://#{JsSpec::DEFAULT_HOST}:#{JsSpec::DEFAULT_PORT}"
  end
end
