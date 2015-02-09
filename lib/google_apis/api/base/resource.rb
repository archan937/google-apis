module GoogleApis
  class Api
    module Base
      class Resource

        attr_accessor :api, :discovered_resource

        def initialize(api, discovered_resource)
          @api = api
          @discovered_resource = discovered_resource
        end

        def [](name)
          if method = find(name)
            method.discovery_document
          end
        end

        def inspect
          "#<#{api.class}::Resource:#{object_hexid} #{api.discovered_api.version}:#{discovered_resource.name}:[#{discovered_resource.discovered_methods.collect(&:name).sort.join(",")}]>"
        end

        def method_missing(name, *args)
          if method = find(name)
            api.execute method, *args
          else
            super
          end
        end

      private

        def find(name)
          discovered_resource.discovered_methods.detect{|x| x.name == name.to_s}
        end

      end
    end
  end
end
