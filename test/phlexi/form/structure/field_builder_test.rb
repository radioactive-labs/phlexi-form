# frozen_string_literal: true

require "test_helper"
require "ostruct"

module Phlexi
  module Form
    module Structure
      class FieldBuilderTest < Minitest::Test
        def setup
          @parent = nil
          @object = OpenStruct.new(name: "Test User")
          @options = {}
        end

        def test_initialization
          field = FieldBuilder.new(:name, parent: @parent, object: @object, **@options)
          assert_equal :name, field.key
          assert_equal "Test User", field.value
          assert_equal @options, field.options
        end

        def test_label_tag
          field = FieldBuilder.new(:name, parent: @parent, object: @object)
          label = field.label_tag
          assert_instance_of Components::Label, label
          assert_equal "Name", label.field.label
        end

        def test_input_tag
          field = FieldBuilder.new(:name, parent: @parent, object: @object)
          input = field.input_tag
          assert_instance_of Components::Input, input
          assert_equal "Test User", input.attributes[:value]
        end

        def test_checkbox_tag
          field = FieldBuilder.new(:active, parent: @parent, object: @object)
          checkbox = field.checkbox_tag
          assert_instance_of Components::Checkbox, checkbox
        end

        def test_radio_button_tag
          field = FieldBuilder.new(:gender, parent: @parent, object: @object)
          radio = field.radio_button_tag
          assert_instance_of Components::RadioButton, radio
        end

        def test_textarea_tag
          field = FieldBuilder.new(:bio, parent: @parent, object: @object)
          textarea = field.textarea_tag
          assert_instance_of Components::Textarea, textarea
        end

        def test_select_tag
          field = FieldBuilder.new(:country, parent: @parent, object: @object)
          select = field.select_tag
          assert_instance_of Components::Select, select
        end

        def test_collection_checkboxes_tag
          field = FieldBuilder.new(:interests, parent: @parent, object: @object, collection: %w[Sports Music Art])
          collection_checkboxes = field.collection_checkboxes_tag
          assert_instance_of Components::CollectionCheckboxes, collection_checkboxes
        end

        def test_collection_radio_buttons_tag
          field = FieldBuilder.new(:favorite_color, parent: @parent, object: @object, collection: %w[Red Green Blue])
          collection_radio_buttons = field.collection_radio_buttons_tag
          assert_instance_of Components::CollectionRadioButtons, collection_radio_buttons
        end

        def test_hint_tag
          field = FieldBuilder.new(:password, parent: @parent, object: @object, hint: "Must be at least 8 characters")
          hint = field.hint_tag
          assert_instance_of Components::Hint, hint
          assert_equal "Must be at least 8 characters", hint.field.hint
        end

        def test_error_tag
          field = FieldBuilder.new(:email, parent: @parent, object: @object)
          error = field.error_tag
          assert_instance_of Components::Error, error
        end

        def test_input_extraction
          field = FieldBuilder.new(:name, parent: @parent, object: @object)
          field.input_tag
          assert_equal({name: "Test User"}, field.extract_input({name: "Test User"}))
        end

        def test_wrapped
          field = FieldBuilder.new(:name, parent: @parent, object: @object)
          wrapper = field.wrapped do |f|
            f.label_tag
            f.input_tag
          end
          assert_instance_of Components::Wrapper, wrapper
        end

        def test_direct_theme_resolution
          theme = {input: "input", custom_input: "custom-input"}
          field = create_field_with_theme(theme)
          assert_equal "input", field.send(:resolve_theme, :input)
        end

        def test_single_level_theme_recursion
          theme = {input: :custom_input, custom_input: "custom-input"}
          field = create_field_with_theme(theme)
          assert_equal "custom-input", field.send(:resolve_theme, :input)
        end

        def test_circular_theme_reference
          theme = {input: :custom_input, custom_input: :input}
          field = create_field_with_theme(theme)
          assert_nil field.send(:resolve_theme, :input)
        end

        def test_multi_level_theme_recursion
          theme = {input: :level1, level1: :level2, level2: "final-value"}
          field = create_field_with_theme(theme)
          assert_equal "final-value", field.send(:resolve_theme, :input)
        end

        def test_theme_resolution_with_missing_key
          theme = {other_key: "value"}
          field = create_field_with_theme(theme)
          assert_nil field.send(:resolve_theme, :input)
        end

        def test_theme_resolution_with_non_symbol_intermediate_value
          theme = {input: "intermediate", intermediate: "final-value"}
          field = create_field_with_theme(theme)
          assert_equal "intermediate", field.send(:resolve_theme, :input)
        end

        def test_theme_resolution_with_falsey
          field = create_field_with_theme({})
          assert_nil field.send(:resolve_theme, false)
          assert_nil field.send(:resolve_theme, nil)
          assert_nil field.send(:resolve_theme, 0)
        end

        private

        def create_field_with_theme(theme)
          FieldBuilder.new(:name, parent: @parent, object: @object, theme: theme)
        end
      end
    end
  end
end
