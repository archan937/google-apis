require_relative "../../test_helper"

module Unit
  module CoreExt
    class TestKernel < Minitest::Test

      describe Kernel do
        describe "#object_hexid" do
          it "returns the hexadecimal representation of its object_id" do
            object = Struct.new(:object_id).new(70232270636660)
            assert_equal "0x007fc073160ce8", object.object_hexid
          end
        end
      end

    end
  end
end
