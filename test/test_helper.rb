require_relative "test_helper/coverage"

require "minitest/autorun"
require "mocha/setup"

require "bundler"
Bundler.require :default, :development

def project_file(path)
  File.expand_path "../../#{path}", __FILE__
end
