require_relative "../../test_helper"

module Unit
  module CoreExt
    class TestHash < Minitest::Test

      describe Hash do
        describe "#symbolize_keys" do
          before do
            @hash = {"a" => 1, "b" => 2, "c" => 3}
            @result = @hash.symbolize_keys
          end
          it "returns new hash" do
            assert_equal true, @result.is_a?(Hash)
            assert_equal true, @hash.object_id != @result.object_id
          end
          it "returns a hash with symbols as keys" do
            assert_equal [:a, :b, :c], @result.keys
          end
        end
        describe "#reverse_merge!" do
          before do
            @hash = {"a" => 1, "b" => 2, "c" => 3}
            @hash.reverse_merge!("a" => 0, "d" => 4)
          end
          it "reverse merges another destructively" do
            assert_equal({"a" => 1, "b" => 2, "c" => 3, "d" => 4}, @hash)
          end
        end
      end

    end
  end
end
