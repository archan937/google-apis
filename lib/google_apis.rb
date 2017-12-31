require "google/api_client"
require "googleauth"

require "google_apis/core_ext"
require "google_apis/connection"
require "google_apis/api"
require "google_apis/version"

module GoogleApis

  class Error < StandardError; end

  def self.connect(options)
    @config = options.symbolize_keys
    @connection = Connection.new config
  end

  def self.config
    @config || {}
  end

  def self.connection
    @connection
  end

end

# Use httpclient to avoid broken pipe errors with large uploads
Faraday.default_adapter = :httpclient

# Only add the following statement if using Faraday >= 0.9.2
# Override gzip middleware with no-op for httpclient
if (Faraday::VERSION.split(".").collect(&:to_i) <=> [0, 9, 2]) > -1
  Faraday::Response.register_middleware :gzip => Faraday::Response::Middleware
end
