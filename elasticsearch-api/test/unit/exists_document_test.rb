require 'test_helper'

module Elasticsearch
  module Test
    class ExistsTest < MiniTest::Unit::TestCase

      context "Exists document" do
        subject { FakeClient.new }

        should "require the :index argument" do
          assert_raises ArgumentError do
            subject.exists :type => 'bar', :id => '1'
          end
        end

        should "require the :id argument" do
          assert_raises ArgumentError do
            subject.exists :index => 'foo', :type => 'bar'
          end
        end

        should "perform correct request" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'HEAD', method
            assert_equal 'foo/bar/1', url
            assert_equal Hash.new, params
            assert_nil   body
            true
          end.returns(FakeResponse.new)

          subject.exists :index => 'foo', :type => 'bar', :id => '1'
        end

        should "pass the URL parameters" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'foo/bar/1', url
            assert_equal 'abc123', params[:routing]
            true
          end.returns(FakeResponse.new)

          subject.exists :index => 'foo', :type => 'bar', :id => '1', :routing => 'abc123'
        end

        should "return true for successful response" do
          subject.expects(:perform_request).returns(FakeResponse.new 200, 'OK')
          assert_equal true, subject.exists(:index => 'foo', :type => 'bar', :id => '1')
        end

        should "return false for 404 response" do
          subject.expects(:perform_request).returns(FakeResponse.new 404, 'Not Found')
          assert_equal false, subject.exists(:index => 'foo', :type => 'bar', :id => '1')
        end

        should "return false on 'not found' exceptions" do
          subject.expects(:perform_request).raises(StandardError.new '404 NotFound')
          assert_equal false, subject.exists(:index => 'foo', :type => 'bar', :id => '1')
        end

        should "re-raise generic exceptions" do
          subject.expects(:perform_request).raises(StandardError)
          assert_raises(StandardError) do
            assert_equal false, subject.exists(:index => 'foo', :type => 'bar', :id => '1')
          end
        end

      end

    end
  end
end
