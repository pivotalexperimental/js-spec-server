require "rubygems"
gem "thin", "0.8.1"

require "thin"
require "fileutils"
require "tmpdir"
require "timeout"
require "cgi"
require "net/http"
require "selenium"
require "optparse"
require "guid"

dir = File.dirname(__FILE__)
require "#{dir}/js_test_core/thin"
require "#{dir}/js_test_core/rack"
require "#{dir}/js_test_core/resources"

require "#{dir}/js_test_core/client"
require "#{dir}/js_test_core/server"
require "#{dir}/js_test_core/rails_server"

module JsTestCore
  DEFAULT_HOST = "0.0.0.0"
  DEFAULT_PORT = 8080

  class << self
    attr_accessor :core_path
  end
end
