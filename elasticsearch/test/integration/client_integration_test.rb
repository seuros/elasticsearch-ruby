require 'test_helper'
require 'logger'

module Elasticsearch
  module Test
    class ClientIntegrationTest < Elasticsearch::Test::IntegrationTestCase
      startup do
        Elasticsearch::TestCluster.start if ENV['SERVER'] and not Elasticsearch::TestCluster.running?
      end

      context "Elasticsearch client" do
        setup do
          system "curl -X DELETE http://localhost:9250/_all > /dev/null 2>&1"

          @logger =  Logger.new(STDERR)
          @logger.formatter = proc do |severity, datetime, progname, msg|
            color = case severity
              when /INFO/ then :green
              when /ERROR|WARN|FATAL/ then :red
              when /DEBUG/ then :cyan
              else :white
            end
            ANSI.ansi(severity[0] + ' ', color, :faint) + ANSI.ansi(msg, :white, :faint) + "\n"
          end

          @client = Elasticsearch::Client.new host: 'localhost:9250', logger: @logger
        end

        should "perform the API methods" do
            # Index a document
            #
            @client.index index: 'test-index', type: 'test-type', id: '1', body: { title: 'Test' }

            # Refresh the index
            #
            @client.indices.refresh index: 'test-index'

            # Search
            #
            response = @client.search index: 'test-index', body: { query: { match: { title: 'test' } } }

            assert_equal 1,      response['hits']['total']
            assert_equal 'Test', response['hits']['hits'][0]['_source']['title']

            # Delete the index
            #
            @client.indices.delete index: 'test-index'
        end

      end
    end
  end
end
