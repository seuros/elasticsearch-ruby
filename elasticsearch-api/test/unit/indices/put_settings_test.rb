require 'test_helper'

module Elasticsearch
  module Test
    class IndicesPutSettingsTest < MiniTest::Unit::TestCase

      context "Indices: Put settings" do
        subject { FakeClient.new }

        should "require the :body argument" do
          assert_raises ArgumentError do
            subject.indices.put_settings
          end
        end

        should "perform correct request" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'PUT', method
            assert_equal '_settings', url
            assert_equal Hash.new, params
            assert_equal Hash.new, body
            true
          end.returns(FakeResponse.new)

          subject.indices.put_settings :body => {}
        end

        should "perform request against a specific indices" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'foo/_settings', url
            true
          end.returns(FakeResponse.new)

          subject.indices.put_settings :index => 'foo', :body => {}
        end

        should "perform request against multiple indices" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'foo,bar/_settings', url
            true
          end.returns(FakeResponse.new)

          subject.indices.put_settings :index => ['foo','bar'], :body => {}
        end

      end

    end
  end
end
