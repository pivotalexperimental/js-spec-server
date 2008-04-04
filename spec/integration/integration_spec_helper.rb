require "rubygems"
dir = File.dirname(__FILE__)
$LOAD_PATH.unshift "#{dir}/../../../plugins/rspec/lib"
require "spec"

$LOAD_PATH.unshift "#{dir}/../../lib"
require "js_spec"
require "hpricot"
require "lsof"

Spec::Runner.configure do |config|
  config.mock_with :rr
end

Thin::Logging.silent = false
Thin::Logging.debug = true

module WaitFor
  extend self
  def wait_for(time=5)
    Timeout.timeout(time) do
      loop do
        value = yield
        return value if value
      end
    end
  end
end

module Spec::Example::ExampleMethods
  include WaitFor
  attr_reader :spec_root_path, :implementation_root_path, :public_path
  before(:all) do
    dir = File.dirname(__FILE__)
    @spec_root_path = "#{dir}/../example_specs"
    @public_path = "#{dir}/../example_public"
    @implementation_root_path = "#{public_path}/javascripts"
    unless $js_spec_server_started
      Thread.start do
        JsSpec::Server.run(spec_root_path, implementation_root_path, public_path)
      end
      $js_spec_server_started = true
    end
    wait_for do
      Lsof.running?(8080)
    end
  end

  def root_url
    "http://#{JsSpec::DEFAULT_HOST}:#{JsSpec::DEFAULT_PORT}"
  end
end
