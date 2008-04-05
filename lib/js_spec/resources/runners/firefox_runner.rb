module JsSpec
  module Resources
    class Runners
      class FirefoxRunner
        class << self
          def create(request, response)
            version = `firefox --version`
            if version =~ /Mozilla Firefox 3/
              Firefox3Runner.new(request, response)
            else
              Firefox1Runner.new(request, response)
            end
          end

          def resume(guid, text)
            runner = instances.delete(guid)
            runner.finalize(text)
          end

          def register_instance(runner)
            instances[runner.guid] = runner
          end

          protected
          def instances
            @instances ||= {}
          end
        end

        include FileUtils
        attr_reader :guid, :profile_dir, :request, :response, :connection

        def initialize(request, response)
          profile_base = "#{::Dir.tmpdir}/js_spec/firefox"
          mkdir_p profile_base
          @profile_dir = "#{profile_base}/#{Time.now.to_i}"
          @guid = UUID.new
          @request = request
          @response = response
          @connection = Server.connection
        end

        def post(request, response)
          FirefoxRunner.register_instance self
          setup_profile
          start_browser
          response.status = nil
        end

        def finalize(text)
          kill_browser
          response.status = 200
          response.body = text
          connection.send_response(*response.finish)
        end

        def command_for(action)
          case action
          when :copy_profile
            src_profile = ::File.expand_path("#{::File.dirname(__FILE__)}/../../../../resources/firefox")
            "cp -R #{src_profile} '#{profile_dir}'"
          when :init_profile
            "firefox -profile '#{profile_dir}' -chrome chrome://killff/content/kill.html"
          when :test_profile
            %Q<if [ -f "#{profile_dir}/xpti.dat" ] && [ "`ps aux | grep '#{profile_dir}' | sed /grep/d`" = '' ]; then exit 0 ; else exit 1 ; fi>
          when :start_browser
            url = (request && request['url']) ? request['url'] : spec_suite_url
            "firefox -profile '#{profile_dir}' #{url}?guid=#{guid}"
          when :kill_browser
            %Q<ps aux | grep '#{profile_dir}' | sed /grep/d | awk '{print $2}' | xargs kill -9>
          else
            raise ArgumentError, "action #{action} is not defined"
          end
        end

        protected

        def spec_suite_url
          "#{Server.root_url}/specs"
        end

        def setup_profile
          copy_profile
          init_profile
          test_profile
        end

        def copy_profile
          system(command_for(:copy_profile)) || raise("Copying Firefox profile failed")
        end

        def init_profile
          system(command_for(:init_profile)) || raise("Initializing profile failed")
        end

        def test_profile
          Timeout.timeout(5) do
            loop do
              if system(command_for(:test_profile))
#                sleep 1
                return
              end
            end
          end
          raise("Testing for profile failed")
        end

        def start_browser
          Thread.start do
            system(command_for(:start_browser)) || raise("Starting Firefox failed")
          end
        end

        def kill_browser
          system(command_for(:kill_browser)) || raise("Killing Firefox failed")
        end
      end
    end
  end
end
