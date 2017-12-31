require "uri"
require "fileutils"

module GoogleApis
  class Connection

    def initialize(options)
      options = options.symbolize_keys

      @client = Google::APIClient.new(
        :application_name => "rubygem:google-apis",
        :application_version => GoogleApis::VERSION
      )

      @client.authorization = Google::Auth::ServiceAccountCredentials.make_creds(
        json_key_io: File.open(options[:private_key], "rb"),
        scope: []
      )
    end

    def discover_api(name, version = 1)
      @client.discovered_api name, "v#{version}"
    end

    def execute(api, api_method, *params)
      options, headers = params

      if options
        parameter_keys = (api_method.discovery_document["parameters"] || {}).keys.collect(&:to_sym)
        media = options.delete(:media)
        parameters, body_object = options.partition{|k, v| parameter_keys.include?(k)}.collect{|x| Hash[x]}
      end

      if media && media.is_a?(String)
        parameters[:uploadType] = "resumable"
        parameters[:name] ||= File.basename(media)
        if directory = body_object.delete(:directory)
          parameters[:name] = File.join(directory, parameters[:name])
        end
        content_type = options[:contentType] || options[:mimeType] if options
        content_type ||= `file --mime -b #{media}`.split(";")[0]
        media = Google::APIClient::UploadIO.new media, content_type
      end

      options = {:api_method => api_method}
      options[:parameters] = parameters unless parameters.empty?
      options[:body_object] = body_object unless body_object.empty?
      options[:media] = media if media
      options.merge!(headers) if headers

      parse! execute!(api, options)
    end

    def download(api, uri, to = nil)
      options = Google::APIClient::Request.new(:uri => uri)

      if to.nil? || File.directory?(to) || to.match(/\/$/)
        to = File.join *[to, File.basename(CGI.unescape(URI.parse(uri).path))].compact
      end

      save! execute!(api, options), to
    end

    def inspect
      "#<#{self.class}:#{object_hexid} [#{@asserter.issuer}]>"
    end

  private

    def execute!(api, options)
      authenticate!(api)
      @client.execute(options)
    end

    def authenticate!(api)
      if !@client.authorization.scope.include?(api.auth_scope) || @client.authorization.expired?
        @client.authorization.scope.push(api.auth_scope).uniq!
        @client.authorization.fetch_access_token!
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

    def save!(response, to)
      FileUtils.mkdir_p File.dirname(to)
      File.open(to, "wb") do |file|
        file.write(response.body)
      end
    end

  end
end
