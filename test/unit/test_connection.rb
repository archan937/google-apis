require_relative "../test_helper"

module Unit
  class TestConnection < Minitest::Test

    describe GoogleApis::Connection do
      describe "#initialize" do
        it "instantiates a Google::APIClient and Google::APIClient::JWTAsserter" do
          client = mock()
          client.expects(:authorization=).with("< authorization >")

          Google::APIClient.expects(:new).with({
            :application_name => "rubygem:google-apis",
            :application_version => GoogleApis::VERSION
          }).returns(client)

          File.expects(:open).with("< private_key >", "rb").returns("< file >")
          Google::Auth::ServiceAccountCredentials.expects(:make_creds).returns("< authorization >")

          connection = GoogleApis::Connection.new(
            :email_address => "< email_address >",
            :private_key => "< private_key >"
          )

          assert_equal client, connection.instance_variable_get(:@client)
        end
      end
    end

  end
end
