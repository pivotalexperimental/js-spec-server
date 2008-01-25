dir = File.dirname(__FILE__)
raise "Failure" unless system(%Q|ruby #{dir}/js_spec_unit_suite.rb|)
raise "Failure" unless system(%Q|ruby #{dir}/js_spec_functional_suite.rb|)
