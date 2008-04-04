dir = File.dirname(__FILE__)

module JsSpec
  module Resources
    class Runners
      def locate(name)
        if name == 'firefox'
          FirefoxRunner.create(Server.request, Server.response)
        else
          raise "Invalid path #{name}"
        end
      end
    end
  end
end
