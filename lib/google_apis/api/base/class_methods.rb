module GoogleApis
  class Api
    module Base
      module ClassMethods

        def api(value = nil)
          if value
            @api = value
          else
            @api
          end
        end

        def version(value = nil)
          if value
            @version = value
          else
            @version || 1
          end
        end

        def auth_scope(value = nil)
          if value
            @auth_scope = value
          else
            @auth_scope
          end
        end

        def connect(options = {})
          @connection = new(options)
        end

        def connection
          @connection
        end

        def name
          @name
        end

        def inspect
          name
        end

        def to_s
          name
        end

        def method_missing(name, *args)
          if connection && (connection.class.instance_methods(false).include?(name) || connection.send(:find, name))
            connection.send(name, *args)
          else
            super
          end
        end

      end
    end
  end
end
