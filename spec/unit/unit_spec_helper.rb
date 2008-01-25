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

module Spec
  module Matchers
    class Exist
      def matches?(actual)
        @actual = actual
        !@actual.nil?
      end
    end
  end
end

module Spec::Example::ExampleMethods
  attr_reader :spec_root_path, :implementation_root_path, :public_path, :server
  before(:all) do
    dir = File.dirname(__FILE__)
    @spec_root_path = File.expand_path("#{dir}/../example_specs")
    @implementation_root_path = File.expand_path("#{dir}/../example_public/javascripts")
    @public_path = File.expand_path("#{dir}/../example_public")
  end

  before(:each) do
    JsSpec::Server.instance = JsSpec::Server.new(spec_root_path, implementation_root_path, public_path)
    @server = JsSpec::Server.instance
  end

  def get(url, params={})
    request(:get, url, params)
  end

  def post(url, params={})
    request(:post, url, params)
  end

  def put(url, params={})
    request(:put, url, params)
  end

  def delete(url, params={})
    request(:delete, url, params)
  end

  def request(method, url, params={})
    @request = Rack::MockRequest.new(server)
    @request.__send__(method, url, params)
  end

  def core_path
    JsSpec::Server.core_path
  end

  def spec_file(relative_path)
    absolute_path = spec_root_path + relative_path
    JsSpec::Resources::File.new(absolute_path, "/specs#{relative_path}")
  end

  def spec_dir(relative_path="")
    absolute_path = spec_root_path + relative_path
    JsSpec::Resources::Dir.new(absolute_path, "/specs#{relative_path}")
  end

  def contain_spec_file_with_correct_paths(path_relative_to_spec_root)
    expected_absolute_path = spec_root_path + path_relative_to_spec_root
    expected_relative_path = "/specs" + path_relative_to_spec_root

    ::Spec::Matchers::SimpleMatcher.new(expected_relative_path) do |globbed_files|
      file = globbed_files.find do |file|
        file.absolute_path == expected_absolute_path
      end
      file && file.relative_path == expected_relative_path
    end
  end
end