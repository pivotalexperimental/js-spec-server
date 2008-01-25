dir = File.dirname(__FILE__)
require File.expand_path("#{dir}/runners/firefox_runner")

module JsSpec
  class Runners
    def locate(name)
      if name == 'firefox'
        FirefoxRunner.new
      else
        raise "Invalid path #{name}"
      end
    end
  end
end