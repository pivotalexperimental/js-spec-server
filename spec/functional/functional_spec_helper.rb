require "rubygems"
dir = File.dirname(__FILE__)
$LOAD_PATH.unshift "#{dir}/../../../plugins/rspec/lib"
require "spec"

$LOAD_PATH.unshift "#{dir}/../../lib"
require "js_spec"
require "hpricot"

class Spec::ExampleGroup
  attr_reader :spec_root_path
  before(:all) do
    dir = File.dirname(__FILE__)
    @spec_root_path = "#{dir}/../example_specs"
  end
end

#JsSpec::Server.run
