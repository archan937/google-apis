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
          @instance = new(options)
        end

        def instance
          @instance
        end

        def connection
          instance
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
          if instance && (instance.class.instance_methods(false).include?(name) || instance.send(:find, name))
            instance.send(name, *args)
          else
            super
          end
        end

      end
    end
  end
end
