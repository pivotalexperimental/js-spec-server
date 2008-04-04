module JsSpec
  module Resources
    class SuiteFinish
      attr_reader :suite
      def initialize(suite)
        @suite = suite
      end

      def post
        guid = JsSpecConnection.request['guid']
        if guid
          Runners::FirefoxRunner.resume(guid, JsSpecConnection.request['text'])
        else
          STDOUT.puts JsSpecConnection.request['text']
        end
        ""
      end
    end
  end
end