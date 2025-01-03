# frozen_string_literal: true

module Phlexi
  module Form
    class GroupedChoicesMapper
      include Enumerable

      def initialize(collection, group_method:, group_label_method: :to_s, label_method: nil, value_method: nil)
        @collection = collection
        @group_method = group_method
        @group_label_method = group_label_method
        @label_method = label_method
        @value_method = value_method
      end

      def each(&)
        grouped_choices.each(&)
      end

      # @return [Array<String>] An array of all choice values.
      def values
        @values ||= grouped_choices.values.flat_map(&:values)
      end

      private

      def grouped_choices
        @grouped_choices ||= materialize_grouped_choices(@collection)
      end

      def materialize_grouped_choices(collection)
        case collection
        in Hash => hash
          hash.transform_values { |items| to_choices_mapper(items) }
        in Array => arr
          array_to_grouped_hash(arr)
        in Proc => proc
          materialize_grouped_choices(proc.call)
        else
          record_collection_to_hash
        end
      end

      def array_to_grouped_hash(array)
        sample = array.first
        if group_method == :last && sample.is_a?(Array) && sample.size == 2
          array.each_with_object({}) do |(label, items), hash|
            hash[label.to_s] = to_choices_mapper(items)
          end
        else
          record_collection_to_hash
        end
      end

      def record_collection_to_hash
        @collection.group_by do |item|
          group = item.public_send(@group_method)
          group.public_send(@group_label_method).to_s
        end.transform_values { |items| to_choices_mapper(items) }
      end

      def to_choices_mapper(items)
        SimpleChoicesMapper.new(items, label_method: @label_method, value_method: @value_method)
      end
    end
  end
end
