# frozen_string_literal: true

module Phlexi
  module Form
    module FieldOptions
      module Associations
        protected

        def reflection
          @reflection ||= find_association_reflection
        end

        def find_association_reflection
          if object.class.respond_to?(:reflect_on_association)
            object.class.reflect_on_association(key)
          end
        end
      end
    end
  end
end
