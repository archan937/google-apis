module GoogleApis
  class Connection

    def initialize(options)
      options = options.symbolize_keys

      @client = Google::APIClient.new(
        :application_name => "rubygem:google-apis",
        :application_version => GoogleApis::VERSION
      )

      key = Google::APIClient::PKCS12.load_key(
        File.open(options[:private_key], "rb"),
        options[:passphrase] || "notasecret"
      )

      @asserter = Google::APIClient::JWTAsserter.new(
        options[:email_address],
        "",
        key
      )
    end

    def discover_api(name, version = 1)
      @client.discovered_api name, "v#{version}"
    end

    def execute(api, api_method, *params)
      authenticate!(api)

      nested, top_level = params

      if nested
        parameter_keys = (api_method.discovery_document["parameters"] || {}).keys.collect(&:to_sym)
        parameters, body_object = nested.partition{|k, v| parameter_keys.include?(k)}.collect{|x| Hash[x] unless x.empty?}
      end

      options = {:api_method => api_method}
      options[:parameters] = parameters if parameters
      options[:body_object] = body_object if body_object
      options.merge!(top_level) if top_level

      parse! @client.execute(options)
    end

    def inspect
      "#<#{self.class}:#{object_hexid} [#{@asserter.issuer}]>"
    end

  private

    def authenticate!(api)
      if !@asserter.scope.include?(api.auth_scope) || @client.authorization.expired?
        @asserter.scope = (@asserter.scope.split(" ") << api.auth_scope).uniq
        @client.authorization = @asserter.authorize
      end
    end

    def parse!(response)
      unless response.body.to_s.empty?
        JSON.parse(response.body).tap do |data|
          if error = data["error"]
            raise Error, "#{error["code"]} #{error["message"]}"
          end
        end
      end
    end

  end
end
