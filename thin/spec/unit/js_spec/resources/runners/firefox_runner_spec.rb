require File.expand_path("#{File.dirname(__FILE__)}/../../../unit_spec_helper")

module JsSpec
  module Resources
    describe Runners::FirefoxRunner do
      describe ".create" do
        describe "when firefox on the system path is firefox 1" do
          it "returns a Firefox1Runner" do
            mock(Runners::FirefoxRunner).`("firefox --version") {"Mozilla Firefox 1.0.0.0, Copyright (c) 1998 - 2008 mozilla.org"}
            runner = Runners::FirefoxRunner.create(nil, nil)
            runner.class.should == Runners::Firefox1Runner
          end
        end

        describe "when firefox on the system path is firefox 2" do
          it "returns a Firefox1Runner" do
            mock(Runners::FirefoxRunner).`("firefox --version") {"Mozilla Firefox 2.0.0.0, Copyright (c) 1998 - 2008 mozilla.org"}
            runner = Runners::FirefoxRunner.create(nil, nil)
            runner.class.should == Runners::Firefox1Runner
          end
        end

        describe "when firefox on the system path is firefox 3" do
          it "returns a Firefox3Runner" do
            mock(Runners::FirefoxRunner).`("firefox --version") {"Mozilla Firefox 3.0, Copyright (c) 1998 - 2008 mozilla.org"}
            runner = Runners::FirefoxRunner.create(nil, nil)
            runner.class.should == Runners::Firefox3Runner
          end
        end
      end
    end
  end
end