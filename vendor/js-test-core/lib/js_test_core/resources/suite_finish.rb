module JsTestCore
  module Resources
    class SuiteFinish < ThinRest::Resource
      property :suite
      
      def post
        if suite.id == 'user'
          STDOUT.puts rack_request['text']
        else
          Runners::FirefoxRunner.finalize(suite.id, rack_request['text'])
        end
        connection.send_head
        connection.send_body("")
      end
    end
  end
end