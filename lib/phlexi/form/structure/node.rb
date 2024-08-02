# frozen_string_literal: true

module Phlexi
  module Form
    module Structure
      # Superclass for Namespace and Field classes. Not much to it other than it has a `name`
      # and `parent` node attribute. Think of it as a tree.
      class Node
        attr_reader :key, :parent

        def initialize(key, parent:)
          @key = key.to_s.to_sym
          @parent = parent
        end
      end
    end
  end
end
