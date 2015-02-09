module GoogleApis
  class Api
    module Base
      module InstanceMethods

        attr_accessor :connection, :discovered_api

        def initialize(options = {})
          options = options.symbolize_keys

          config, default_params = options.partition{|(k, v)| [:email_address, :private_key].include?(k)}.collect{|x| Hash[x] unless x.empty?}
          @connection = config ? GoogleApis::Connection.new(config) : GoogleApis.connection
          raise Error, "Please ensure a Google API connection" unless @connection

          @discovered_api = connection.discover_api self.class.api, self.class.version
          @default_params = default_params || {}
        end

        def execute(api_method, *params)
          params[0] = (params[0] || {}).symbolize_keys
          params[0].reverse_merge!(@default_params)
          connection.execute self.class, api_method, *params
        end

        def inspect
          "#<#{self.class}:#{object_hexid} #{discovered_api.version}:[#{discovered_api.discovered_resources.collect(&:name).sort.join(",")}] {#{@default_params.collect{|k, v| "#{k}:#{v.inspect}"}.join(",")}}>"
        end

        def method_missing(name, *args)
          if resource = find(name)
            Resource.new self, resource
          else
            super
          end
        end

      private

        def find(name)
          discovered_api.discovered_resources.detect{|x| x.name == name.to_s}
        end

      end
    end
  end
end
