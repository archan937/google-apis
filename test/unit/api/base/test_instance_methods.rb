require_relative "../../../test_helper"

module Unit
  module Api
    module Base
      class TestInstanceMethods < Minitest::Test

        class InstanceApi
          extend GoogleApis::Api::Base
        end

        describe GoogleApis::Api::Base::InstanceMethods do
          describe "#initialize" do
            describe "when not having GoogleApis.connection defined" do
              before do
                GoogleApis.instance_variable_set :@connection, nil
              end
              describe "when passing connection options" do
                it "instantiates its own connection" do
                  connection = "< connection >"
                  connection.expects(:discover_api)
                  options = {
                    :email_address => "< email_address >",
                    :private_key => "< private_key >"
                  }
                  GoogleApis::Connection.expects(:new).with(options).returns(connection)
                  assert_equal connection, InstanceApi.new(options).instance_variable_get(:@connection)
                end
              end
              describe "when not passing connection options" do
                it "raises an error" do
                  assert_raises GoogleApis::Error do
                    InstanceApi.new
                  end
                end
              end
            end
            describe "when not having GoogleApis.connection defined" do
              before do
                GoogleApis.instance_variable_set :@connection, "< google-apis connection >"
              end
              describe "when passing connection options" do
                it "instantiates its own connection" do
                  connection = "< connection >"
                  connection.expects(:discover_api)
                  options = {
                    :email_address => "< email_address >",
                    :private_key => "< private_key >"
                  }
                  GoogleApis::Connection.expects(:new).with(options).returns(connection)
                  assert_equal connection, InstanceApi.new(options).instance_variable_get(:@connection)
                end
              end
              describe "when not passing connection options" do
                it "uses GoogleApis.connection for its connection" do
                  GoogleApis.connection.expects(:discover_api)
                  assert_equal "< google-apis connection >", InstanceApi.new.instance_variable_get(:@connection)
                end
              end
            end
          end
        end

      end
    end
  end
end
