require 'test_helper'

module Elasticsearch
  module Test
    class UpdateTest < Minitest::Test

      context "Update document" do
        subject { FakeClient.new }

        should "require the :index argument" do
          assert_raises ArgumentError do
            subject.update :type => 'bar', :id => '1'
          end
        end

        should "require the :type argument" do
          assert_raises ArgumentError do
            subject.update :index => 'foo', :id => '1'
          end
        end

        should "require the :id argument" do
          assert_raises ArgumentError do
            subject.update :index => 'foo', :type => 'bar'
          end
        end

        should "perform correct request" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'POST', method
            assert_equal 'foo/bar/1/_update', url
            assert_equal Hash.new, params
            assert_equal Hash.new, body[:doc]
            true
          end.returns(FakeResponse.new)

          subject.update :index => 'foo', :type => 'bar', :id => '1', :body => { :doc => {} }
        end

        should "pass the URL parameters" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'foo/bar/1/_update', url
            assert_equal 100, params[:version]
            true
          end.returns(FakeResponse.new)

          subject.update :index => 'foo', :type => 'bar', :id => '1', :version => 100, :body => {}
        end

      end

    end
  end
end
