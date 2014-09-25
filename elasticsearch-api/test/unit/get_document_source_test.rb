require 'test_helper'

module Elasticsearch
  module Test
    class GetSourceTest < Minitest::Test

      context "Get document source" do
        subject { FakeClient.new }

        should "require the :index argument" do
          assert_raises ArgumentError do
            subject.get_source :type => 'bar', :id => '1'
          end
        end

        should "require the :id argument" do
          assert_raises ArgumentError do
            subject.get_source :index => 'foo', :type => 'bar'
          end
        end

        should "perform correct request" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'GET', method
            assert_equal 'foo/bar/1/_source', url
            assert_equal Hash.new, params
            assert_nil   body
            true
          end.returns(FakeResponse.new)

          subject.get_source :index => 'foo', :type => 'bar', :id => '1'
        end

        should "pass the URL parameters" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'foo/bar/1/_source', url
            assert_equal 'abc123', params[:routing]
            true
          end.returns(FakeResponse.new)

          subject.get_source :index => 'foo', :type => 'bar', :id => '1', :routing => 'abc123'
        end

      end

    end
  end
end
