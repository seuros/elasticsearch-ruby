require 'test_helper'

module Elasticsearch
  module Test
    class IndicesGetTemplateTest < Minitest::Test

      context "Indices: Get template" do
        subject { FakeClient.new }

        should "require the :name argument" do
          assert_raises ArgumentError do
            subject.indices.get_template
          end
        end

        should "perform correct request" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'GET', method
            assert_equal '_template/foo', url
            assert_equal Hash.new, params
            assert_nil   body
            true
          end.returns(FakeResponse.new)

          subject.indices.get_template :name => 'foo'
        end

      end

    end
  end
end
