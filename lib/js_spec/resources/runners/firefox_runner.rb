module JsSpec
  module Resources
    class Runners
      class FirefoxRunner
        class << self
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
        attr_reader :guid, :profile_dir, :request, :response, :connection, :driver

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
          @driver = Selenium::SeleniumDriver.new('localhost', 4444, '*firefox', 'http://localhost:8080')
          driver.start
          Thread.start do
            url = (request && request['spec_url']) ? request['spec_url'] : spec_suite_url
            url << "?guid=#{guid}"
            driver.open(url)
          end
          response.status = nil
        end

        def finalize(text)
          driver.stop
          response.status = 200
          response.body = text
          connection.send_response(*response.finish)
        end

        protected

        def spec_suite_url
          "#{Server.root_url}/specs"
        end
      end
    end
  end
end
