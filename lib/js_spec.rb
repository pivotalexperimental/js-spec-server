require "rubygems"

dir = File.dirname(__FILE__)
$:.unshift(File.expand_path("#{dir}/../vendor/js-test-core/lib"))
require "js_test_core"
JsTestCore::Resources::WebRoot.dispatch_specs

require "#{dir}/js_spec/representations"

module JsSpec
  DEFAULT_HOST = JsTestCore::DEFAULT_HOST
  DEFAULT_PORT = JsTestCore::DEFAULT_PORT

  Server = JsTestCore::Server
  RailsServer = JsTestCore::RailsServer
  Client = JsTestCore::Client
end
JsTestCore.core_path = File.expand_path("#{dir}/../core")
JsTestCore::Resources::Specs::Spec.spec_representation_class = JsSpec::Representations::Spec
