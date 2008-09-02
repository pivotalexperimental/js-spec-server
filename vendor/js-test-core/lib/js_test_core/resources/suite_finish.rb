module JsTestCore
  module Resources
    class SuiteFinish < ThinRest::Resource
      property :suite
      
      def post
        if suite.id == 'user'
          STDOUT.puts rack_request['text']
        else
<<<<<<< HEAD:vendor/js-test-core/lib/js_test_core/resources/suite_finish.rb
          Runners::Runner.finalize(suite.id, rack_request['text'])
=======
          Runners::FirefoxRunner.finalize(suite.id, rack_request['text'])
>>>>>>> bdda07f2c71511f181aab95e0472c4e19ffd06e7:vendor/js-test-core/lib/js_test_core/resources/suite_finish.rb
        end
        connection.send_head
        connection.send_body("")
      end
    end
  end
end