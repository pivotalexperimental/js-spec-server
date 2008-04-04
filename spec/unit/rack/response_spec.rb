require File.expand_path("#{File.dirname(__FILE__)}/../unit_spec_helper")

module Rack
  describe Response do
    describe "#ready?" do
      attr_reader :response
      describe "when there is a status" do
        before do
          @response = Response.new
          @response.status.should_not be_nil
        end

        it "returns true" do
          response.should be_ready
        end
      end

      describe "when there is no status" do
        before do
          @response = Response.new
          response.status = nil
        end

        it "returns true" do
          response.should_not be_ready
        end
      end
    end
  end
end