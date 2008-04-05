require 'rbconfig'

# This generator bootstraps a Rails project for use with RSpec
class JsSpecGenerator < Rails::Generator::Base
  DEFAULT_SHEBANG = File.join(Config::CONFIG['bindir'],
                              Config::CONFIG['ruby_install_name'])

  def initialize(runtime_args, runtime_options = {})
    super
  end

  def manifest
    record do |m|
      script_options     = { :chmod => 0755, :shebang => options[:shebang] == DEFAULT_SHEBANG ? nil : options[:shebang] }

      m.directory 'spec'
      m.directory 'javascripts'
      m.template  'spec_helper.js',                 'spec/javascripts/spec_helper.js'
      m.file      'script/js_spec_server',          'script/js_spec_server', script_options
      m.file      'script/js_spec',                 'script/js_spec',        script_options
    end
  end

protected

  def banner
    "Usage: #{$0} js_spec"
  end

end
