dir = File.dirname(__FILE__)
raise "Failure" unless system(%Q|ruby #{dir}/unit_spec_suite.rb|)
raise "Failure" unless system(%Q|ruby #{dir}/functional_spec_suite.rb|)
