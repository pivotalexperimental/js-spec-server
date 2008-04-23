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
require "#{dir}/js_spec/thin"
require "#{dir}/js_spec/rack"
require "#{dir}/js_spec/resources"

require "#{dir}/js_spec/client"
require "#{dir}/js_spec/server"
require "#{dir}/js_spec/rails_server"

module JsSpec
  DEFAULT_HOST = "0.0.0.0"
  DEFAULT_PORT = 8080  
end
