require 'test_helper'

class Elasticsearch::Transport::Transport::HTTP::FaradayTest < MiniTest::Spec
  include Elasticsearch::Transport::Transport::HTTP

  context "Faraday transport" do
    setup do
      @transport = Faraday.new :hosts => [ { :host => 'foobar', :port => 1234 } ]
    end

    should "implement host_unreachable_exceptions" do
      assert_instance_of Array, @transport.host_unreachable_exceptions
    end

    should "implement __build_connections" do
      assert_equal 1, @transport.hosts.size
      assert_equal 1, @transport.connections.size

      assert_instance_of ::Faraday::Connection, @transport.connections.first.connection
      assert_equal 'http://foobar:1234/', @transport.connections.first.connection.url_prefix.to_s
    end

    should "perform the request" do
      @transport.connections.first.connection.expects(:run_request).returns(stub_everything)
      @transport.perform_request 'GET', '/'
    end

    should "properly prepare the request" do
      @transport.connections.first.connection.expects(:run_request).with do |method, url, body, headers|
        :post == method && '{"foo":"bar"}' == body
      end.returns(stub_everything)
      @transport.perform_request 'POST', '/', {}, {:foo => 'bar'}
    end

    should "serialize the request body" do
      @transport.connections.first.connection.expects(:run_request).returns(stub_everything)
      @transport.serializer.expects(:dump)
      @transport.perform_request 'POST', '/', {}, {:foo => 'bar'}
    end

    should "not serialize a String request body" do
      @transport.connections.first.connection.expects(:run_request).returns(stub_everything)
      @transport.serializer.expects(:dump).never
      @transport.perform_request 'POST', '/', {}, '{"foo":"bar"}'
    end

    should "pass the selector_class options to collection" do
      @transport = Faraday.new :hosts => [ { :host => 'foobar', :port => 1234 } ],
                               :options => { :selector_class => Elasticsearch::Transport::Transport::Connections::Selector::Random }
      assert_instance_of Elasticsearch::Transport::Transport::Connections::Selector::Random,
                         @transport.connections.selector
    end

    should "pass the selector option to collection" do
      @transport = Faraday.new :hosts => [ { :host => 'foobar', :port => 1234 } ],
                               :options => { :selector => Elasticsearch::Transport::Transport::Connections::Selector::Random.new }
      assert_instance_of Elasticsearch::Transport::Transport::Connections::Selector::Random,
                         @transport.connections.selector
    end

    should "allow to set options for Faraday" do
      config_block = lambda do |f|
        f.response :logger
      end

      transport = Faraday.new :hosts => [ { :host => 'foobar', :port => 1234 } ], &config_block

      handlers = transport.connections.first.connection.instance_variable_get(:@builder).instance_variable_get(:@handlers)
      assert handlers.include?(::Faraday::Response::Logger), "#{handlers.inspect} does not include <::Faraday::Adapter::Typhoeus>"
    end
  end

end
