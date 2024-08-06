# frozen_string_literal: true

require "test_helper"

module Phlexi
  module Form
    module Components
      class SelectTest < Minitest::Test
        include Capybara::DSL
        include Phlex::Testing::Capybara::ViewHelper

        def test_that_it_renders_the_select_input
          render Phlexi::Form(:user) {
            field(:name) do |name|
              render name.select_tag
            end
          }

          select = find("select")
          assert_equal "user_name", select["id"]
          assert_equal "user[name]", select["name"]
        end

        def test_that_it_renders_a_blank_option
          render Phlexi::Form(:user) {
            render field(:name).select_tag
          }

          select = find("select")
          assert_equal 1, select.all("option").count

          option = select.find("option")
          assert option["selected"]
          assert "", option.text
        end

        def test_that_it_renders_a_blank_option_with_placeholder_value
          render Phlexi::Form(:user) {
            render field(:name).placeholder("Placeholder text").select_tag
          }

          option = find("select").find("option")
          assert "Placeholder text", option.text
        end

        def test_that_it_skips_blank_option_if_include_blank_is_false
          render Phlexi::Form(:user) {
            render field(:name).select_tag(include_blank: false)
          }

          assert_equal 0, find("select").all("option").count
        end

        def test_select_attributes
          render Phlexi::Form(:user) {
            render field(:name)
              .focused!
              .required!
              .disabled!
              .multiple!
              .select_tag
          }

          select = find("select")
          assert select["autofocus"]
          assert select["required"]
          assert select["disabled"]
          assert select["multiple"]
        end

        def test_that_it_renders_select_options
          render Phlexi::Form(:user) {
            render field(:name)
              .collection(1..5)
              .select_tag
          }

          select = find("select")
          assert_equal 6, select.all("option").count

          (1..5).each do |value|
            option = select.find("option[value=\"#{value}\"]")
            assert_equal value.to_s, option.text
          end
        end

        def test_that_it_selects_single_option
          render Phlexi::Form(:user) {
            render field(:name, value: 4)
              .collection(1..5)
              .select_tag
          }

          option = find("select").find("option[selected]")
          assert_equal "4", option["value"]
        end

        def test_that_it_selects_multiple_options
          render Phlexi::Form(:user) {
            render field(:name, value: [2, 4])
              .multiple!
              .collection(1..5)
              .select_tag
          }

          options = find("select").all("option[selected]")
          assert_equal 2, options.count
          assert_equal "2", options[0]["value"]
          assert_equal "4", options[1]["value"]
        end

        def test_that_it_extracts_single_option
          form = Phlexi::Form(:user) {
            render field(:name).collection(1..5).select_tag
          }

          assert_equal({user: {name: "1"}}, form.extract_input({user: {name: "1"}}))
          assert_equal({user: {name: nil}}, form.extract_input({user: {name: "0"}}))
          assert_equal({user: {name: nil}}, form.extract_input({user: {name: ""}}))
          assert_equal({user: {name: nil}}, form.extract_input({user: {name: nil}}))
          assert_equal({user: {name: nil}}, form.extract_input({user: {}}))
        end

        def test_that_it_extracts_multiple_options
          form = Phlexi::Form(:user) {
            render field(:name, collection: 1..5).select_tag(multiple: true)
          }

          assert_equal({user: {name: ["1"]}}, form.extract_input({user: {name: "1"}}))
          assert_equal({user: {name: ["1", "4"]}}, form.extract_input({user: {name: ["1", "4"]}}))
          assert_equal({user: {name: []}}, form.extract_input({user: {name: [""]}}))
          assert_equal({user: {name: []}}, form.extract_input({user: {name: "0"}}))
          assert_equal({user: {name: []}}, form.extract_input({user: {name: []}}))
          assert_equal({user: {name: []}}, form.extract_input({user: {name: nil}}))
          assert_equal({user: {name: []}}, form.extract_input({user: {}}))
        end
      end
    end
  end
end
