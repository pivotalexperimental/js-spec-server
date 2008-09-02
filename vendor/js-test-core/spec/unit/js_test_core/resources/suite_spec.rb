require File.expand_path("#{File.dirname(__FILE__)}/../../unit_spec_helper")

module JsTestCore
  module Resources
    describe Suite do
      describe "GET /suites/:suite_id" do
<<<<<<< HEAD:vendor/js-test-core/spec/unit/js_test_core/resources/suite_spec.rb
        attr_reader :driver, :suite_id
=======
        attr_reader :driver, :suite_id, :suite_runner
>>>>>>> bdda07f2c71511f181aab95e0472c4e19ffd06e7:vendor/js-test-core/spec/unit/js_test_core/resources/suite_spec.rb

        context "when there is no Runner with the :suite_id" do
          it "responds with a 404" do
            suite_id = "invalid_suite_id"
<<<<<<< HEAD:vendor/js-test-core/spec/unit/js_test_core/resources/suite_spec.rb
            Runners::Runner.find(suite_id).should be_nil
=======
            Runners::FirefoxRunner.find(suite_id).should be_nil
>>>>>>> bdda07f2c71511f181aab95e0472c4e19ffd06e7:vendor/js-test-core/spec/unit/js_test_core/resources/suite_spec.rb

            mock(connection).send_head(404)
            mock(connection).send_body("")

            connection.receive_data("GET /suites/#{suite_id} HTTP/1.1\r\nHost: _\r\n\r\n")
          end
        end

<<<<<<< HEAD:vendor/js-test-core/spec/unit/js_test_core/resources/suite_spec.rb
        context "when there is a Runner with the :suite_id" do
          attr_reader :suite_runner
=======
        context "when a Runner with the :suite_id is running" do
>>>>>>> bdda07f2c71511f181aab95e0472c4e19ffd06e7:vendor/js-test-core/spec/unit/js_test_core/resources/suite_spec.rb
          before do
            @driver = "Selenium Driver"
            @suite_id = "DEADBEEF"
            stub(Selenium::SeleniumDriver).new('localhost', 4444, '*firefox', 'http://0.0.0.0:8080') do
              driver
            end

<<<<<<< HEAD:vendor/js-test-core/spec/unit/js_test_core/resources/suite_spec.rb
            stub(driver).start
=======
            @suite_runner = Runners::FirefoxRunner.new
            stub(suite_runner).driver {driver}
>>>>>>> bdda07f2c71511f181aab95e0472c4e19ffd06e7:vendor/js-test-core/spec/unit/js_test_core/resources/suite_spec.rb
            stub(driver).session_id {suite_id}
<<<<<<< HEAD:vendor/js-test-core/spec/unit/js_test_core/resources/suite_spec.rb
            connection_that_starts_firefox = create_connection
            stub(connection_that_starts_firefox).send_head
            stub(connection_that_starts_firefox).send_body
            connection_that_starts_firefox.receive_data("POST /runners/firefox HTTP/1.1\r\nHost: _\r\nContent-Length: 0\r\n\r\n")
            @suite_runner = Runners::Runner.find(suite_id)
=======
            Runners::FirefoxRunner.register(suite_runner)
>>>>>>> bdda07f2c71511f181aab95e0472c4e19ffd06e7:vendor/js-test-core/spec/unit/js_test_core/resources/suite_spec.rb
            suite_runner.should be_running
          end

<<<<<<< HEAD:vendor/js-test-core/spec/unit/js_test_core/resources/suite_spec.rb
          context "when a Runner with the :suite_id is running" do
            it "responds with a 200 and status=running" do
              mock(connection).send_head
              mock(connection).send_body("status=#{Resources::Suite::RUNNING}")
=======
          it "responds with a 200 and status=running" do
            mock(connection).send_head
            mock(connection).send_body("status=#{Resources::Suite::RUNNING}")
>>>>>>> bdda07f2c71511f181aab95e0472c4e19ffd06e7:vendor/js-test-core/spec/unit/js_test_core/resources/suite_spec.rb

<<<<<<< HEAD:vendor/js-test-core/spec/unit/js_test_core/resources/suite_spec.rb
              connection.receive_data("GET /suites/#{suite_id} HTTP/1.1\r\nHost: _\r\n\r\n")
            end
=======
            connection.receive_data("GET /suites/#{suite_id} HTTP/1.1\r\nHost: _\r\n\r\n")
>>>>>>> bdda07f2c71511f181aab95e0472c4e19ffd06e7:vendor/js-test-core/spec/unit/js_test_core/resources/suite_spec.rb
          end
<<<<<<< HEAD:vendor/js-test-core/spec/unit/js_test_core/resources/suite_spec.rb
=======
        end
>>>>>>> bdda07f2c71511f181aab95e0472c4e19ffd06e7:vendor/js-test-core/spec/unit/js_test_core/resources/suite_spec.rb

<<<<<<< HEAD:vendor/js-test-core/spec/unit/js_test_core/resources/suite_spec.rb
          context "when a Runner with the :suite_id has completed" do
            context "when the suite has a status of 'success'" do
              before do
                stub(driver).stop
                suite_runner.finalize("")
                suite_runner.should be_successful
              end
=======
        context "when a Runner with the :suite_id has completed" do
          before do
            @driver = "Selenium Driver"
            @suite_id = "DEADBEEF"
            stub(Selenium::SeleniumDriver).new('localhost', 4444, '*firefox', 'http://0.0.0.0:8080') do
              driver
            end
>>>>>>> bdda07f2c71511f181aab95e0472c4e19ffd06e7:vendor/js-test-core/spec/unit/js_test_core/resources/suite_spec.rb

<<<<<<< HEAD:vendor/js-test-core/spec/unit/js_test_core/resources/suite_spec.rb
              it "responds with a 200 and status=success" do
                mock(connection).send_head
                mock(connection).send_body("status=#{Resources::Suite::SUCCESSFUL_COMPLETION}")
=======
            @suite_runner = Runners::FirefoxRunner.new
            stub(suite_runner).driver {driver}
            stub(driver).session_id {suite_id}
            stub(driver).stop
            Runners::FirefoxRunner.register(suite_runner)
            suite_runner.should be_running
          end
          
          context "when the suite has a status of 'success'" do
            before do
              suite_runner.finalize("")
              suite_runner.should be_successful
            end
>>>>>>> bdda07f2c71511f181aab95e0472c4e19ffd06e7:vendor/js-test-core/spec/unit/js_test_core/resources/suite_spec.rb

<<<<<<< HEAD:vendor/js-test-core/spec/unit/js_test_core/resources/suite_spec.rb
                connection.receive_data("GET /suites/#{suite_id} HTTP/1.1\r\nHost: _\r\n\r\n")
              end
=======
            it "responds with a 200 and status=success" do
              mock(connection).send_head
              mock(connection).send_body("status=#{Resources::Suite::SUCCESSFUL_COMPLETION}")

              connection.receive_data("GET /suites/#{suite_id} HTTP/1.1\r\nHost: _\r\n\r\n")
>>>>>>> bdda07f2c71511f181aab95e0472c4e19ffd06e7:vendor/js-test-core/spec/unit/js_test_core/resources/suite_spec.rb
            end
<<<<<<< HEAD:vendor/js-test-core/spec/unit/js_test_core/resources/suite_spec.rb
=======
          end
>>>>>>> bdda07f2c71511f181aab95e0472c4e19ffd06e7:vendor/js-test-core/spec/unit/js_test_core/resources/suite_spec.rb

<<<<<<< HEAD:vendor/js-test-core/spec/unit/js_test_core/resources/suite_spec.rb
            context "when the suite has a status of 'failure'" do
              attr_reader :reason
              before do
                stub(driver).stop
                @reason = "Failure stuff"
                suite_runner.finalize(reason)
                suite_runner.should be_failed
              end
=======
          context "when the suite has a status of 'failure'" do
            attr_reader :reason
            before do
              @reason = "Failure stuff"
              suite_runner.finalize(reason)
              suite_runner.should be_failed
            end
>>>>>>> bdda07f2c71511f181aab95e0472c4e19ffd06e7:vendor/js-test-core/spec/unit/js_test_core/resources/suite_spec.rb

<<<<<<< HEAD:vendor/js-test-core/spec/unit/js_test_core/resources/suite_spec.rb
              it "responds with a 200 and status=failure and reason" do
                mock(connection).send_head
                mock(connection).send_body("status=#{Resources::Suite::FAILURE_COMPLETION}&reason=#{reason}")
=======
            it "responds with a 200 and status=failure and reason" do
              mock(connection).send_head
              mock(connection).send_body("status=#{Resources::Suite::FAILURE_COMPLETION}&reason=#{reason}")
>>>>>>> bdda07f2c71511f181aab95e0472c4e19ffd06e7:vendor/js-test-core/spec/unit/js_test_core/resources/suite_spec.rb

<<<<<<< HEAD:vendor/js-test-core/spec/unit/js_test_core/resources/suite_spec.rb
                connection.receive_data("GET /suites/#{suite_id} HTTP/1.1\r\nHost: _\r\n\r\n")
              end
=======
              connection.receive_data("GET /suites/#{suite_id} HTTP/1.1\r\nHost: _\r\n\r\n")
>>>>>>> bdda07f2c71511f181aab95e0472c4e19ffd06e7:vendor/js-test-core/spec/unit/js_test_core/resources/suite_spec.rb
            end
          end
        end
      end
    end
  end
end
