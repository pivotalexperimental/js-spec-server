module JsSpec
  module Resources
    class Runners
      class FirefoxRunner
        class << self
          def resume(guid, text)
            responses[guid] = text
            threads[guid].kill
          end

          def threads
            @threads ||= {}
          end

          def response_value(guid)
            responses[guid]
          ensure
            responses.delete guid
          end

          protected
          
          def responses
            @responses ||= {}
          end
        end

        include FileUtils
        attr_reader :guid, :profile_dir

        def initialize
          profile_base = "#{::Dir.tmpdir}/js_spec/firefox"
          mkdir_p profile_base
          @profile_dir = "#{profile_base}/#{Time.now.to_i}"
          @guid = 'foobar'
        end

        def post
          setup_profile

          browser_thread = start_browser
          locking_thread = Thread.start {sleep}
          self.class.threads[guid] = locking_thread
          locking_thread.join
          kill_browser

          self.class.response_value guid
        end
      
        def command_for(action)
          case action
          when :copy_profile
            src_profile = ::File.expand_path("#{::File.dirname(__FILE__)}/../../../../resources/firefox")
            "cp -R #{src_profile} #{profile_dir}"
          when :init_profile
            "firefox -profile #{profile_dir} -chrome chrome://killff/content/kill.html"
          when :test_profile
            "if [ -f \"#{profile_dir}/xpti.dat\" ] && [ \"`ps aux | grep #{profile_dir} | sed /grep/d`\" == '' ]; then exit 0 ; else exit 1 ; fi"
          when :start_browser
            url = (Server.request && Server.request['url']) ? Server.request['url'] : spec_suite_url
            "firefox -profile #{profile_dir} #{url}?guid=#{guid}"
          when :kill_browser
            %Q<ps aux | grep "#{profile_dir}" | sed /grep/d | awk '{print $2}' | xargs kill -9>
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
              return if system(command_for(:test_profile))
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