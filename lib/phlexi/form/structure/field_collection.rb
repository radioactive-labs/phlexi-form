# frozen_string_literal: true

module Phlexi
  module Form
    module Structure
      class FieldCollection
        include Enumerable

        class Builder
          attr_reader :key, :index

          def initialize(key, field, index)
            @key = key.to_s
            @field = field
            @index = index
          end

          def field(**)
            @field.class.new(key, attributes: @field.attributes, **, parent: @field).tap do |field|
              yield field if block_given?
            end
          end

          def hidden_field_tag(value: "", force: false)
            raise "Attempting to build hidden field on non-first field in a collection" unless index == 0 || force

            @field.class
              .new("hidden", parent: @field)
              .input_tag(type: :hidden, value:)
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
          @range.each.with_index do |key, index|
            yield Builder.new(key, @field, index)
          end
        end
      end
    end
  end
end
