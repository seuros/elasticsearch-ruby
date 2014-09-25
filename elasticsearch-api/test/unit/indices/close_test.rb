require 'test_helper'

module Elasticsearch
  module Test
    class IndicesCloseTest < Minitest::Test

      context "Indices: Close" do
        subject { FakeClient.new }

        should "require the :index argument" do
          assert_raises ArgumentError do
            subject.indices.close
          end
        end

        should "perform correct request" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'POST', method
            assert_equal 'foo/_close', url
            assert_equal Hash.new, params
            assert_nil   body
            true
          end.returns(FakeResponse.new)

          subject.indices.close :index => 'foo'
        end

        should "pass the URL parameters" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'foo/_close', url
            assert_equal '1s', params[:timeout]
            true
          end.returns(FakeResponse.new)

          subject.indices.close :index => 'foo', :timeout => '1s'
        end

      end

    end
  end
end
