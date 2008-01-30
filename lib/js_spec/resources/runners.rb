dir = File.dirname(__FILE__)
require File.expand_path("#{dir}/runners/firefox_runner")

module JsSpec
  module Resources
    class Runners
      def locate(name)
        if name == 'firefox'
          FirefoxRunner.new(Server.request, Server.response)
        else
          raise "Invalid path #{name}"
        end
      end
    end
  end
end