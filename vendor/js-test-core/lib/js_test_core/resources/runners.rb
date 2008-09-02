dir = File.dirname(__FILE__)

module JsTestCore
  module Resources
    class Runners < ThinRest::Resource
      route 'firefox' do |env, name|
        FirefoxRunner.new(env)
<<<<<<< HEAD:vendor/js-test-core/lib/js_test_core/resources/runners.rb
      end
      route 'iexplore' do |env, name|
        IExploreRunner.new(env)
=======
>>>>>>> bdda07f2c71511f181aab95e0472c4e19ffd06e7:vendor/js-test-core/lib/js_test_core/resources/runners.rb
      end
    end
  end
end