# frozen_string_literal: true

module Phlexi
  module Form
    module Options
      module InferredTypes
        private

        def infer_field_component
          case inferred_field_type
          when :string, :text
            infer_string_field_type || inferred_field_type
          when :integer, :float, :decimal
            :number
          when :json, :jsonb
            :text
          when :enum
            :select
          when :association
            association_reflection.polymorphic? ? :"polymorphic_#{association_reflection.macro}" : association_reflection.macro
          when :attachment, :binary
            :file
          when :citext
            infer_string_field_type || :string
          when :date, :time, :datetime, :boolean, :hstore
            inferred_field_type
          else
            :string
          end
        end
      end
    end
  end
end
