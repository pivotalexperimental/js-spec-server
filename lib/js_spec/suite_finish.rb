module JsSpec
  class SuiteFinish
    attr_reader :suite
    def initialize(suite)
      @suite = suite
    end

    def post
      guid = Server.request['guid']
      if guid
        Runners::FirefoxRunner.resume(guid, Server.request['text'])
      else
        STDOUT.puts Server.request['text']
      end
      ""
    end
  end
end