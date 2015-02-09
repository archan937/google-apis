require_relative "../../test_helper"

module Unit
  module Api
    class TestBigQuery < Minitest::Test

      class BaseApi
        extend GoogleApis::Api::Base
        def self.metaclass
          class << self; self; end
        end
      end

      describe GoogleApis::Api::Base do
        describe ".extended" do
          it "extends base with GoogleApis::Api::Base::ClassMethods" do
            assert_equal true, BaseApi.metaclass.included_modules.include?(GoogleApis::Api::Base::ClassMethods)
          end
          it "includes base with GoogleApis::Api::Base::InstanceMethods" do
            assert_equal true, BaseApi.included_modules.include?(GoogleApis::Api::Base::InstanceMethods)
          end
          it "registers base in the Google namespace" do
            assert_equal true, Google.constants.include?(:BaseApi)
            assert_equal BaseApi, Google::BaseApi
          end
        end
        describe ".name" do
          it "returns its actual name demodulized within the Google namespace" do
            assert_equal "Google::BaseApi", BaseApi.name
          end
        end
        describe ".inspect" do
          it "returns its name" do
            BaseApi.expects(:name).returns("< inspect >")
            assert_equal "< inspect >", BaseApi.inspect
          end
        end
        describe ".to_s" do
          it "returns its name" do
            BaseApi.expects(:name).returns("< to_s >")
            assert_equal "< to_s >", BaseApi.to_s
          end
        end
      end

    end
  end
end
