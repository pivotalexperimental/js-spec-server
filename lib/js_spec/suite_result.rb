module JsSpec
  class SuiteResult
    def passed?
      false
    end

    def post
      STDOUT.puts Server.request['text']
    end
  end
end