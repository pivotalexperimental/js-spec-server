require "rubygems"
require "rack"
require "mongrel"

dir = File.dirname(__FILE__)
require "#{dir}/js_spec/server"
require "#{dir}/js_spec/spec_runner"
require "#{dir}/js_spec/spec_file_runner"
require "#{dir}/js_spec/spec_dir_runner"
require "#{dir}/js_spec/file"
require "#{dir}/js_spec/dir"
require "#{dir}/js_spec/web_root"
require "#{dir}/js_spec/suite_result"
