require 'test_helper'

module Elasticsearch
  module Test
    class IndicesFlushTest < Minitest::Test

      context "Indices: Flush" do
        subject { FakeClient.new }

        should "perform correct request" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'POST', method
            assert_equal '_flush', url
            assert_equal Hash.new, params
            assert_nil   body
            true
          end.returns(FakeResponse.new)

          subject.indices.flush
        end

        should "perform request against multiple indices" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'foo,bar/_flush', url
            true
          end.returns(FakeResponse.new)

          subject.indices.flush :index => ['foo','bar']
        end

        should "pass the URL parameters" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'foo/_flush', url
            assert_equal true, params[:refresh]
            true
          end.returns(FakeResponse.new)

          subject.indices.flush :index => 'foo', :refresh => true
        end

      end

    end
  end
end
