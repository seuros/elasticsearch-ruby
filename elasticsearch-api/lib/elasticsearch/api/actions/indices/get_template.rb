module Elasticsearch
  module API
    module Indices
      module Actions

        # Get a single index template.
        #
        # @example Get a template named _mytemplate_
        #
        #     client.indices.get_template name: 'mytemplate'
        #
        # @note Use the {Cluster::Actions#state} API to get a list of all templates.
        #
        # @option arguments [String] :name The name of the template (*Required*)
        #
        # @see http://www.elasticsearch.org/guide/reference/api/admin-indices-templates/
        #
        def get_template(arguments={})
          raise ArgumentError, "Required argument 'name' missing" unless arguments[:name]
          method = 'GET'
          path   = "_template/#{arguments[:name]}"
          params = {}
          body = nil

          perform_request(method, path, params, body).body
        end
      end
    end
  end
end
