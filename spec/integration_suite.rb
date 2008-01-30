class IntegrationSuite
  def run
    dir = File.dirname(__FILE__)
    Dir["#{dir}/integration/**/*_spec.rb"].each do |file|
      require file
    end
  end
end

IntegrationSuite.new.run