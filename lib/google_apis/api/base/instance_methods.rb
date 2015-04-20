module GoogleApis
  class Api
    module Base
      module InstanceMethods

        attr_accessor :connection, :discovered_api

        def initialize(options = {})
          config, params = options.symbolize_keys.partition{|(k, v)| [:email_address, :private_key].include?(k)}.collect{|x| Hash[x]}

          @connection = config.empty? ? GoogleApis.connection : GoogleApis::Connection.new(config)
          raise Error, "Please ensure a Google API connection" unless @connection

          params = GoogleApis.config.merge(params).inject({}){|h, (k, v)| h[k.to_s.gsub(/_(.)/){$1.upcase}.to_sym] = v if v; h}

          @discovered_api = connection.discover_api self.class.api, self.class.version
          @default_params = params.select{|k, v| self.class.default_parameters.include?(k)}
        end

        def execute(api_method, *params)
          params[0] = (params[0] || {}).symbolize_keys
          params[0].reverse_merge!(default_params)
          connection.execute self.class, api_method, *params
        end

        def download(uri, to = nil)
          connection.download self.class, uri, to
        end

        def inspect
          "#<#{self.class}:#{object_hexid} #{discovered_api.version}:[#{discovered_api.discovered_resources.collect(&:name).sort.join(",")}] {#{default_params.collect{|k, v| "#{k}:#{v.inspect}"}.join(",")}}>"
        end

        def method_missing(name, *args)
          if resource = find(name)
            Resource.new self, resource
          else
            super
          end
        end

      private

        def default_params
          @default_params
        end

        def find(name)
          discovered_api.discovered_resources.detect{|x| x.name == name.to_s}
        end

      end
    end
  end
end
