module JsTestCore
  module Resources
    class Suite < ThinRest::Resource
      class Collection < ThinRest::Resource
        route ANY do |env, id|
          Suite.new(env.merge(:id => id))
        end
      end

      RUNNING = 'running'
      SUCCESSFUL_COMPLETION = 'success'
      FAILURE_COMPLETION = 'failure'

      property :id

      def get
<<<<<<< HEAD:vendor/js-test-core/lib/js_test_core/resources/suite.rb
        runner = Runners::Runner.find(id)
=======
        runner = Runners::FirefoxRunner.find(id)
>>>>>>> bdda07f2c71511f181aab95e0472c4e19ffd06e7:vendor/js-test-core/lib/js_test_core/resources/suite.rb
        if runner
          connection.send_head
          if runner.running?
            connection.send_body("status=#{RUNNING}")
          else
            if runner.successful?
              connection.send_body("status=#{SUCCESSFUL_COMPLETION}")
            else
              connection.send_body("status=#{FAILURE_COMPLETION}&reason=#{runner.suite_run_result}")
            end
          end
        else
          connection.send_head(404)
          connection.send_body("")
        end
      end

      route 'finish' do |env, name|
        SuiteFinish.new(env.merge(:suite => self))
      end
    end
  end
end