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
      attr_reader :profile_dir

      def initialize
        profile_base = "#{::Dir.tmpdir}/js_spec/firefox"
        mkdir_p profile_base
        @profile_dir = "#{profile_base}/#{Time.now.to_i}"
      end

      def post
        copy_profile_files
        create_profile
        wait_for_full_profile_to_be_created

        guid = UUID.new
        start_browser guid
        thread = Thread.start {sleep}
        self.class.threads[guid] = thread
        thread.join

        self.class.response_value guid
      end

      protected
      def copy_profile_files
        dir = ::File.dirname(__FILE__)
        firefox_profile_path = ::File.expand_path("#{dir}/../../../../resources/firefox")
        system("cp -R #{firefox_profile_path} #{profile_dir}") || raise("Copying Firefox profile failed")
      end

      def create_profile
        system("firefox -profile #{profile_dir} -chrome chrome://killff/content/kill.html") || raise("Initializing profile failed")
      end

      def wait_for_full_profile_to_be_created
        Timeout.timeout(5) do
          wait_for_file_lock_to_go_away
        end
      end

      def start_browser(guid)
        Thread.start do
          system("firefox -profile #{profile_dir} http://localhost:8080/specs?guid=#{guid}") || raise("Starting Firefox failed")
        end
      end

      def wait_for_file_lock_to_go_away
        loop do
          return if lock_is_gone? && lock_remains_gone?
        end
      end

      def lock_is_gone?
        !::File.exists?("#{profile_dir}/parent.lock")
      end

      def lock_remains_gone?
        sleep 0.5
        lock_is_gone?
      end
    end
  end
  end
end