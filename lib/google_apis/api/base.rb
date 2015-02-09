require "google_apis/api/base/class_methods"
require "google_apis/api/base/instance_methods"
require "google_apis/api/base/resource"

module Google
end

module GoogleApis
  class Api
    module Base

      def self.extended(base)
        name = base.to_s.demodulize
        Google.const_set name, base

        base.instance_variable_set :@name, "Google::#{name}"
        base.extend ClassMethods
        base.send :include, InstanceMethods
      end

    end
  end
end
