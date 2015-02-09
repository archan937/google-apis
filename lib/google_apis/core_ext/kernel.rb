module Kernel

  def object_hexid
    "0x" + (object_id << 1).to_s(16).rjust(14, "0")
  end

end
