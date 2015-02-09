require_relative "../../test_helper"

module Unit
  module Api
    class TestBigQuery < Minitest::Test

      describe GoogleApis::Api::BigQuery do
        describe ".api" do
          it "returns the default API name" do
            assert_equal "bigquery", GoogleApis::Api::BigQuery.api
          end
        end

        describe ".version" do
          it "returns the default API version" do
            assert_equal 2, GoogleApis::Api::BigQuery.version
          end
        end

        describe ".auth_scope" do
          it "returns the default API authentication scope" do
            assert_equal "https://www.googleapis.com/auth/bigquery", GoogleApis::Api::BigQuery.auth_scope
          end
        end
      end

    end
  end
end
