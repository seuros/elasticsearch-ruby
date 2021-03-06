require 'test_helper'

module Elasticsearch
  module Test
    class IndicesStatusTest < MiniTest::Spec

      context "Indices: Status" do
        subject { FakeClient.new }

        should "perform correct request" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'GET', method
            assert_equal '_status', url
            assert_equal Hash.new, params
            assert_nil   body
            true
          end.returns(FakeResponse.new)

          subject.indices.status
        end

        should "perform request against an index" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'foo/_status', url
            true
          end.returns(FakeResponse.new)

          subject.indices.status :index => 'foo'
        end

        should "perform request against multiple indices" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'foo,bar/_status', url
            true
          end.returns(FakeResponse.new).twice

          subject.indices.status :index => ['foo','bar']
          subject.indices.status :index => 'foo,bar'
        end

        should "pass the URL parameters" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'foo/_status', url
            assert_equal true, params[:recovery]
            true
          end.returns(FakeResponse.new)

          subject.indices.status :index => 'foo', :recovery => true
        end

      end

    end
  end
end
