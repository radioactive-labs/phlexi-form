# frozen_string_literal: true

module Phlexi
  module Form
    module Structure
      class NamespaceCollection < Node
        include Enumerable

        def initialize(key, parent:, collection: nil, &block)
          raise ArgumentError, "block is required" unless block.present?

          super(key, parent: parent)

          @collection = collection
          @block = block
          each(&block)
        end

        def extract_input(params)
          namespace = build_namespace(0)
          @block.call(namespace)

          inputs = params[key].map { |param| namespace.extract_input([param]) }
          {key => inputs}
        end

        private

        def each(&)
          namespaces.each(&)
        end

        # Builds and memoizes namespaces for the collection.
        #
        # @return [Array<Namespace>] An array of namespace objects.
        def namespaces
          @namespaces ||= @collection.map.with_index do |object, key|
            build_namespace(key, object: object)
          end
        end

        def build_namespace(index, **)
          parent.class.new(index, parent: self, builder_klass: parent.builder_klass, **)
        end
      end
    end
  end
end
