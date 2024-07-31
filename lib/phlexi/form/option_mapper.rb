# frozen_string_literal: true

module Phlexi
  module Form
    # OptionMapper is responsible for converting a collection of objects into a hash of options
    # suitable for form controls, such as `select > options`.
    # Both values and labels are converted to strings.
    #
    # @example Basic usage
    #   collection = [["First", 1], ["Second", 2]]
    #   mapper = OptionMapper.new(collection)
    #   mapper.each { |value, label| puts "#{value}: #{label}" }
    #
    # @example Using with ActiveRecord objects
    #   users = User.all
    #   mapper = OptionMapper.new(users)
    #   mapper.each { |id, name| puts "#{id}: #{name}" }
    #
    # @example Array access with different value types
    #   mapper = OptionMapper.new([["Integer", 1], ["String", "2"], ["Symbol", :three]])
    #   puts mapper["1"]      # Output: "Integer"
    #   puts mapper["2"]      # Output: "String"
    #   puts mapper["three"]  # Output: "Symbol"
    #
    # @note This class is thread-safe as it doesn't maintain mutable state.
    class OptionMapper
      include Enumerable

      # Initializes a new OptionMapper instance.
      #
      # @param collection [#call, #to_a] The collection to be mapped.
      # @param label_method [Symbol, nil] The method to call on each object to get the label.
      # @param value_method [Symbol, nil] The method to call on each object to get the value.
      def initialize(collection, label_method: nil, value_method: nil)
        @raw_collection = collection
        @label_method = label_method
        @value_method = value_method
      end

      # Iterates over the collection, yielding value-label pairs.
      #
      # @yieldparam value [String] The string value for the current item.
      # @yieldparam label [String] The string label for the current item.
      # @return [Enumerator] If no block is given.
      def each(&)
        collection.each(&)
      end

      # @return [Array<String>] An array of all labels in the collection.
      def labels
        collection.values
      end

      # @return [Array<String>] An array of all values in the collection.
      def values
        collection.keys
      end

      # Retrieves the label for a given value.
      #
      # @param value [#to_s] The value to look up.
      # @return [String, nil] The label corresponding to the value, or nil if not found.
      def [](value)
        collection[value.to_s]
      end

      private

      # @return [Hash<String, String>] The materialized collection as a hash of string value => string label.
      def collection
        @collection ||= materialize_collection(@raw_collection)
      end

      # Converts the raw collection into a materialized hash.
      #
      # @param collection [#call, #to_a] The collection to be materialized.
      # @return [Hash<String, String>] The materialized collection as a hash of string value => string label.
      # @raise [ArgumentError] If the collection cannot be materialized into an enumerable.
      def materialize_collection(collection)
        case collection
        in Hash => hash
          hash.transform_keys(&:to_s).transform_values(&:to_s)
        in Array => arr
          array_to_hash(arr)
        in Range => range
          range_to_hash(range)
        in Proc => proc
          materialize_collection(proc.call)
        in Symbol
          raise ArgumentError, "Symbol collections are not supported in this context"
        in Set => set
          array_to_hash(set.to_a)
        else
          array_to_hash(Array(collection))
        end
      rescue ArgumentError => e
        # Rails.logger.warn("Unhandled inclusion collection type: #{e}")
        {}
      end

      # Converts an array to a hash using detected or specified methods.
      #
      # @param array [Array] The array to convert.
      # @return [Hash<String, String>] The resulting hash of string value => string label.
      def array_to_hash(array)
        sample = array.first || array.last
        methods = detect_methods_for_sample(sample)

        array.each_with_object({}) do |item, hash|
          value = item.public_send(methods[:value]).to_s
          label = item.public_send(methods[:label]).to_s
          hash[value] = label
        end
      end

      # Converts a range to a hash.
      #
      # @param range [Range] The range to convert.
      # @return [Hash<String, String>] The range converted to a hash of string value => string label.
      # @raise [ArgumentError] If the range is unbounded.
      def range_to_hash(range)
        raise ArgumentError, "Cannot safely materialize an unbounded range" if range.begin.nil? || range.end.nil?

        range.each_with_object({}) { |value, hash| hash[value.to_s] = value.to_s }
      end

      # Detects suitable methods for label and value from a sample object.
      #
      # @param sample [Object] A sample object from the collection.
      # @return [Hash{Symbol => Symbol}] A hash containing :label and :value keys with corresponding method names.
      def detect_methods_for_sample(sample)
        case sample
        when Array
          {value: :last, label: :first}
        else
          {
            value: @value_method || collection_value_methods.find { |m| sample.respond_to?(m) },
            label: @label_method || collection_label_methods.find { |m| sample.respond_to?(m) }
          }
        end
      end

      # @return [Array<Symbol>] An array of method names to try for collection values.
      def collection_value_methods
        @collection_value_methods ||= %i[to_param id to_s].freeze
      end

      # @return [Array<Symbol>] An array of method names to try for collection labels.
      def collection_label_methods
        @collection_label_methods ||= %i[to_label name title to_s].freeze
      end
    end
  end
end
