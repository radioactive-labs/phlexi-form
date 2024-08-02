# frozen_string_literal: true

module Phlexi
  module Form
    module Structure
      class NamespaceCollection < Node
        include Enumerable

        def initialize(key, parent:, collection: nil, &)
          super(key, parent: parent)

          @collection = collection
          each(&) if block_given?
        end

        def serialize
          map(&:serialize)
        end

        def assign(array)
          # The problem with zip-ing the array is if I need to add new
          # elements to it and wrap it in the namespace.
          zip(array) do |namespace, hash|
            namespace.assign hash
          end
        end

        def each(&)
          namespaces.each(&)
        end

        private

        # Builds and memoizes namespaces for the collection.
        #
        # @return [Array<Hash>] An array of namespace hashes.
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
