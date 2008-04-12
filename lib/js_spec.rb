require "rubygems"
gem "eventmachine", "0.10.0"
gem "thin", "0.7.1"

require "thin"
require "fileutils"
require "tmpdir"
require "timeout"
require "cgi"
require "net/http"
require "selenium"
require "optparse"

dir = File.dirname(__FILE__)
require "#{dir}/js_spec/guid"
require "#{dir}/js_spec/thin"
require "#{dir}/js_spec/rack"
require "#{dir}/js_spec/resources"

require "#{dir}/js_spec/client"
require "#{dir}/js_spec/server"
require "#{dir}/js_spec/rails_server"

module JsSpec
  DEFAULT_HOST = "127.0.0.1"
  DEFAULT_PORT = 8080  
end
