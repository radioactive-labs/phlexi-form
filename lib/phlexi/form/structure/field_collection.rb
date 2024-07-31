# frozen_string_literal: true

module Phlexi
  module Form
    module Structure
      class FieldCollection
        include Enumerable

        class Builder
          attr_reader :key

          def initialize(key, field)
            @key = key.to_s
            @field = field
          end

          def field(**)
            @field.class.new(key, attributes: @field.attributes, **, parent: @field).tap do |field|
              yield field if block_given?
            end
          end
        end

        def initialize(field:, range:, &)
          @field = field
          @range = case range
          when Range, Array
            range
          when Integer
            1..range
          else
            range.to_a
          end
          each(&) if block_given?
        end

        def each(&)
          @range.each do |key|
            yield Builder.new(key, @field)
          end
        end
      end
    end
  end
end
