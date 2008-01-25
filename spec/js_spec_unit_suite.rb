class JsSpecUnitSuite
  def run
    dir = File.dirname(__FILE__)
    Dir["#{dir}/unit/**/*_spec.rb"].each do |file|
      require file
    end
  end
end

JsSpecUnitSuite.new.run