require 'test_helper'

module Elasticsearch
  module Test
    class IndicesDeleteMappingTest < MiniTest::Spec

      context "Indices: Delete mapping" do
        subject { FakeClient.new }

        should "require the :index argument" do
          assert_raises ArgumentError do
            subject.indices.delete_mapping :type => 'bar'
          end
        end

        should "require the :type argument" do
          assert_raises ArgumentError do
            subject.indices.delete_mapping :index => 'foo'
          end
        end

        should "perform correct request" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'DELETE', method
            assert_equal 'foo/bar', url
            assert_equal Hash.new, params
            assert_nil   body
            true
          end.returns(FakeResponse.new)

          subject.indices.delete_mapping :index => 'foo', :type => 'bar'
        end

        should "perform request against multiple indices" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'foo,bar/baz', url
            true
          end.returns(FakeResponse.new)

          subject.indices.delete_mapping :index => ['foo','bar'], :type => 'baz'
        end

      end

    end
  end
end
