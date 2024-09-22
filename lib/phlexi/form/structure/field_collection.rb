# frozen_string_literal: true

module Phlexi
  module Form
    module Structure
      class FieldCollection < Phlexi::Field::Structure::FieldCollection
        class Builder < Phlexi::Field::Structure::FieldCollection::Builder
          def field(**options)
            options = mix({input_attributes: @field.input_attributes}, options)
            @field.class.new(key, **options, parent: @field).tap do |field|
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

        private

        def build_collection(collection)
          case collection
          when Range, Array
            collection
          when Integer
            1..collection
          else
            collection.to_a
          end
        end
      end
    end
  end
end
