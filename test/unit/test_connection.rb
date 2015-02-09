require_relative "../test_helper"

module Unit
  class TestConnection < Minitest::Test

    describe GoogleApis::Connection do
      describe "#initialize" do
        it "instantiates a Google::APIClient and Google::APIClient::JWTAsserter" do
          Google::APIClient.expects(:new).with({
            :application_name => "rubygem:google-apis",
            :application_version => GoogleApis::VERSION
          }).returns("< client >")

          File.expects(:open).with("< private_key >", "rb").returns("< file >")
          Google::APIClient::PKCS12.expects(:load_key).with("< file >", "notasecret").returns("< key >")
          Google::APIClient::JWTAsserter.expects(:new).with("< email_address >", nil, "< key >").returns("< asserter >")

          connection = GoogleApis::Connection.new(
            :email_address => "< email_address >",
            :private_key => "< private_key >"
          )

          assert_equal "< client >", connection.instance_variable_get(:@client)
          assert_equal "< asserter >", connection.instance_variable_get(:@asserter)
        end
      end
    end

  end
end
