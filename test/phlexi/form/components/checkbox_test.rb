# frozen_string_literal: true

require "test_helper"

module Phlexi
  module Form
    module Components
      # A checkbox must reflect the *stored* value's truthiness. Values arriving
      # from JSON/text columns or params ("f", "FALSE", "off", 0, :false, ...)
      # are all falsey to Rails and must render UNCHECKED. Only "", "0" and a
      # lowercase "false" used to be recognised, so every other falsey form
      # wrongly rendered checked.
      class CheckboxTest < Minitest::Test
        include Capybara::DSL
        include Phlex::Testing::Capybara::ViewHelper

        # true-ish values -> checked
        TRUTHY = [true, 1, "1", "t", "true", "TRUE", "on"].freeze
        # Rails ActiveModel::Type::Boolean::FALSE_VALUES (+ nil / blank) -> unchecked
        FALSEY = [false, 0, "0", "f", "F", "false", "FALSE", "off", "OFF", :false, nil, ""].freeze # standard:disable Lint/BooleanSymbol

        def test_truthy_values_render_checked
          TRUTHY.each do |value|
            assert checked?(value), "checkbox should be CHECKED for #{value.inspect}"
          end
        end

        def test_falsey_values_render_unchecked
          FALSEY.each do |value|
            refute checked?(value), "checkbox should be UNCHECKED for #{value.inspect}"
          end
        end

        def test_custom_checked_value_uses_exact_match
          # A non-default checked_value keeps strict equality semantics.
          assert checked?("yes", checked_value: "yes", unchecked_value: "no")
          refute checked?("f", checked_value: "yes", unchecked_value: "no")
          refute checked?("anything-else", checked_value: "yes", unchecked_value: "no")
        end

        private

        def checked?(value, **tag_options)
          html = Phlexi::Form(:user) {
            render field(:flag, value: value).checkbox_tag(**tag_options)
          }.call
          # Only the checkbox input can carry a bare `checked` attribute; the
          # hidden companion never does.
          html.match?(/\bchecked\b/)
        end
      end
    end
  end
end
