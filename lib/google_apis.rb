require "google/api_client"

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

Faraday.default_adapter = :httpclient
