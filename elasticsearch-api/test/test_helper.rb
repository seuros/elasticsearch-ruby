RUBY_1_8 = defined?(RUBY_VERSION) && RUBY_VERSION < '1.9'

require 'simplecov' and SimpleCov.start { add_filter "/test|test_/" } if ENV["COVERAGE"]

require 'minitest/autorun'
require 'shoulda-context'
require 'mocha/setup'

require 'require-prof' if ENV["REQUIRE_PROF"]
require 'elasticsearch/api'
RequireProf.print_timing_infos if ENV["REQUIRE_PROF"]

module Elasticsearch
  module Test
    class FakeClient
      include Elasticsearch::API

      def perform_request(method, path, params, body)
        puts "PERFORMING REQUEST:", "--> #{method.to_s.upcase} #{path} #{params} #{body}"
        FakeResponse.new(200, 'FAKE', {})
      end
    end

    FakeResponse = Struct.new(:status, :body, :headers) do
      def status
        values[0] || 200
      end
      def body
        values[1] || '{}'
      end
      def headers
        values[2] || {}
      end
    end

    class NotFound < StandardError; end
  end
end
