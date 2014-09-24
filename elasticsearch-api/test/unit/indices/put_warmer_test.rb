require 'test_helper'

module Elasticsearch
  module Test
    class IndicesPutWarmerTest < MiniTest::Unit::TestCase

      context "Indices: Put warmer" do
        subject { FakeClient.new }

        should "require the :index argument" do
          assert_raises ArgumentError do
            subject.indices.put_warmer :name => 'foo', :body => {}
          end
        end

        should "require the :name argument" do
          assert_raises ArgumentError do
            subject.indices.put_warmer :index => 'foo', :body => {}
          end
        end

        should "require the :body argument" do
          assert_raises ArgumentError do
            subject.indices.put_warmer :index => 'foo', :name => 'bar'
          end
        end

        should "perform correct request" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'PUT', method
            assert_equal 'foo/_warmer/bar', url
            assert_equal Hash.new, params
            assert_equal :match_all, body[:query].keys.first
            true
          end.returns(FakeResponse.new)

          subject.indices.put_warmer :index => 'foo', :name => 'bar', :body => { :query => { :match_all => {} } }
        end

        should "perform request against multiple indices" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'foo,bar/_warmer/xul', url
            true
          end.returns(FakeResponse.new)

          subject.indices.put_warmer :index => ['foo','bar'], :name => 'xul', :body => {}
        end

        should "perform request against an index and type" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'foo/bar/_warmer/xul', url
            true
          end.returns(FakeResponse.new)

          subject.indices.put_warmer :index => 'foo', :type => 'bar', :name => 'xul', :body => {}
        end

      end

    end
  end
end
