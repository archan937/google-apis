unless Hash.method_defined?(:symbolize_keys)
  class Hash
    def symbolize_keys
      inject({}){|h, (k, v)| h[k.to_sym] = v; h}
    end
  end
end

unless Hash.method_defined?(:reverse_merge!)
  class Hash
    def reverse_merge!(other)
      replace other.merge(self)
    end
  end
end
