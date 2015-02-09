require_relative "../../../test_helper"

module Unit
  module Api
    module Base
      class TestClassMethods < Minitest::Test

        class ClassApi
          extend GoogleApis::Api::Base::ClassMethods
        end

        describe GoogleApis::Api::Base::ClassMethods do
          describe ".api" do
            describe "as reader" do
              it "returns class instance variable @api" do
                ClassApi.instance_variable_set :@api, "< api >"
                assert_equal "< api >", ClassApi.api
              end
            end
            describe "as writer" do
              it "assigns class instance variable @api" do
                ClassApi.instance_variable_set :@api, "< old api >"
                ClassApi.api "< new api >"
                assert_equal "< new api >", ClassApi.instance_variable_get(:@api)
              end
            end
          end

          describe ".version" do
            describe "as reader" do
              describe "when not set" do
                it "returns 1" do
                  ClassApi.instance_variable_set :@version, nil
                  assert_equal 1, ClassApi.version
                end
              end
              describe "when set" do
                it "returns class instance variable @version" do
                  ClassApi.instance_variable_set :@version, "< version >"
                  assert_equal "< version >", ClassApi.version
                end
              end
            end
            describe "as writer" do
              it "assigns class instance variable @version" do
                ClassApi.instance_variable_set :@version, "< old version >"
                ClassApi.version "< new version >"
                assert_equal "< new version >", ClassApi.instance_variable_get(:@version)
              end
            end
          end

          describe ".auth_scope" do
            describe "as reader" do
              it "returns class instance variable @auth_scope" do
                ClassApi.instance_variable_set :@auth_scope, "< auth_scope >"
                assert_equal "< auth_scope >", ClassApi.auth_scope
              end
            end
            describe "as writer" do
              it "assigns class instance variable @auth_scope" do
                ClassApi.instance_variable_set :@auth_scope, "< old auth_scope >"
                ClassApi.auth_scope "< new auth_scope >"
                assert_equal "< new auth_scope >", ClassApi.instance_variable_get(:@auth_scope)
              end
            end
          end
        end

      end
    end
  end
end
