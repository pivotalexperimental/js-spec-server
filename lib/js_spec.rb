require "rubygems"
require "thin"
require "fileutils"
require "tmpdir"
require "timeout"
require "uuid"
require "cgi"
require "net/http"
require "selenium"
require "optparse"

dir = File.dirname(__FILE__)
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
