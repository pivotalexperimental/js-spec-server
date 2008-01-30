require "rubygems"
require "rack"
require "mongrel"
require "fileutils"
require "tmpdir"
require "timeout"
require "uuid"
require "cgi"
require "net/http"


dir = File.dirname(__FILE__)
require "#{dir}/js_spec/resources/runners"
require "#{dir}/js_spec/resources/runners/firefox_runner"

require "#{dir}/js_spec/client"
require "#{dir}/js_spec/server"
require "#{dir}/js_spec/rails_server"
require "#{dir}/js_spec/resources/spec_runner"
require "#{dir}/js_spec/resources/spec_file_runner"
require "#{dir}/js_spec/resources/spec_dir_runner"
require "#{dir}/js_spec/resources/file"
require "#{dir}/js_spec/resources/dir"
require "#{dir}/js_spec/resources/web_root"
require "#{dir}/js_spec/resources/suite"
require "#{dir}/js_spec/resources/suite_finish"

module JsSpec
  DEFAULT_HOST = "127.0.0.1"
  DEFAULT_PORT = 8080  
end