require "google/api_client"

require "google_apis/core_ext"
require "google_apis/connection"
require "google_apis/api"
require "google_apis/version"

module GoogleApis

  class Error < StandardError; end

  def self.connect(options)
    @connection = Connection.new options
  end

  def self.connection
    @connection
  end

end
