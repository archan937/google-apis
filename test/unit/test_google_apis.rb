require_relative "../test_helper"

module Unit
  class TestGoogleApis < MiniTest::Test

    describe GoogleApis do
      it "has the current version" do
        version = File.read(project_file("VERSION")).strip
        assert_equal version, GoogleApis::VERSION
        assert File.read(project_file("CHANGELOG.rdoc")).include?("Version #{version} ")
      end

      describe ".connect" do
        before do
          @options = {
            :email_address => "< email_address >",
            :private_key => "< private_key >"
          }
        end

        it "instantiates a connection" do
          GoogleApis::Connection.expects(:new).with(@options)
          assert_equal true, GoogleApis.connect(@options)
        end

        it "memoizes the connection" do
          connection = "< connection >"
          GoogleApis::Connection.expects(:new).with(@options).returns(connection)
          GoogleApis.connect(@options)
          assert_equal connection, GoogleApis.instance_variable_get(:@connection)
        end
      end

      describe ".connection" do
        it "returns instance variable @connection" do
          GoogleApis.instance_variable_set :@connection, "< connection >"
          assert_equal "< connection >", GoogleApis.connection
        end
      end
    end

  end
end
