# frozen_string_literal: true

require "test_helper"
require "ostruct"

module Phlexi
  class FormTest < Minitest::Test
    include Capybara::DSL
    include Phlex::Testing::Capybara::ViewHelper

    FORM_CHARSET = "UTF-8"
    POST_METHOD = "post"
    GET_METHOD = "get"

    def setup
      @user = OpenStruct.new(
        model_name: OpenStruct.new(param_key: "user"),
        id: 1,
        name: "William Bills",
        nicknames: ["Bill", "Billy", "Will"],
        location: OpenStruct.new(lat: "lat", lng: "lng"),
        addresses: [
          OpenStruct.new(street: "Birch Ave", city: "Williamsburg"),
          OpenStruct.new(street: "Main St", city: "Salem")
        ]
      )
    end

    def test_that_complex_form_renders
      render Phlexi::Form(@user) {
        field(:name) do |name|
          render name.input_tag
        end
        nest_one(:location) do |location|
          render location.field(:lat).input_tag
          render location.field(:lng).input_tag
        end
        nest_many(:addresses) do |address|
          render address.field(:street).input_tag
          render address.field(:city).input_tag
        end
      }

      # <form method="post" accept-charset="UTF-8">
      #   <input class="input optional" id="user_name" name="user[name]" value="William Bills" type="text">
      #   <input class="input optional" id="user_location_lat" name="user[location][lat]" value="1" type="text">
      #   <input class="input optional" id="user_location_lng" name="user[location][lng]" value="2" type="text">
      #   <input class="input optional" id="user_addresses_0_street" name="user[addresses][0][street]" value="Birch Ave" type="text">
      #   <input class="input optional" id="user_addresses_0_city" name="user[addresses][0][city]" value="Williamsburg" type="text">
      #   <input class="input optional" id="user_addresses_1_street" name="user[addresses][1][street]" value="Main St" type="text">
      #   <input class="input optional" id="user_addresses_1_city" name="user[addresses][1][city]" value="Salem" type="text">
      # </form>

      assert_form_attributes(POST_METHOD)
      assert_input_field_value("user[name]", "William Bills")
      assert_input_field_value("user[location][lat]", "lat")
      assert_input_field_value("user[location][lng]", "lng")
      assert_input_field_value("user[addresses][0][street]", "Birch Ave")
      assert_input_field_value("user[addresses][0][city]", "Williamsburg")
      assert_input_field_value("user[addresses][1][street]", "Main St")
      assert_input_field_value("user[addresses][1][city]", "Salem")
    end

    def test_form_renders_with_string
      render Phlexi::Form("object") { render field(:name).input_tag }

      assert_form_attributes(GET_METHOD)
      assert_input_field_value("object[name]", "")
    end

    def test_form_renders_with_symbol
      render Phlexi::Form(:object) { render field(:name).input_tag }

      assert_form_attributes(GET_METHOD)
      assert_input_field_value("object[name]", "")
    end

    def test_form_renders_all_field_types
      html_string = Phlexi::Form(@user) do
        render field(:field).label_tag
        render field(:field).input_tag
        render field(:textarea).textarea_tag
        render field(:select).select_tag
        render field(:checkbox).checkbox_tag
        render field(:radio).radio_button_tag
        render field(:collection_checkboxes, collection: 1..2).collection_checkboxes_tag
        render field(:collection_radio_buttons, collection: 1..2).collection_radio_buttons_tag
        render field(:input_array, value: 1..2).input_array_tag
      end.call
      expected = '<form id="user_1" method="post" accept-charset="UTF-8"><label class="label optional" id="user_1_field_label" for="user_1_field">Field</label><input class="input optional" id="user_1_field" name="user[field]" value="" type="text"><textarea class="textarea optional" id="user_1_textarea" name="user[textarea]"></textarea><select class="select optional" id="user_1_select" name="user[select]"><option selected></option></select><input type="hidden" name="user[checkbox]" value="0" autocomplete="off" hidden><input class="checkbox optional" id="user_1_checkbox" name="user[checkbox]" value="1" type="checkbox"><input class="radio_button optional" id="user_1_radio" name="user[radio]" value="1" type="radio"><div id="user_1_collection_checkboxes" class="collection_checkboxes optional"><input type="hidden" value="" id="user_1_collection_checkboxes_hidden" name="user[collection_checkboxes][]" hidden autocomplete="off"><input class="checkbox optional" id="user_1_collection_checkboxes_1" name="user[collection_checkboxes][]" value="1" type="checkbox"><label class="label optional" id="user_1_collection_checkboxes_1_label" for="user_1_collection_checkboxes_1">1</label><input class="checkbox optional" id="user_1_collection_checkboxes_2" name="user[collection_checkboxes][]" value="2" type="checkbox"><label class="label optional" id="user_1_collection_checkboxes_2_label" for="user_1_collection_checkboxes_2">2</label></div><div id="user_1_collection_radio_buttons" class="collection_radio_buttons optional"><input type="hidden" value="" id="user_1_collection_radio_buttons_hidden" name="user[collection_radio_buttons][]" hidden autocomplete="off"><input class="radio_button optional" id="user_1_collection_radio_buttons_1" name="user[collection_radio_buttons]" value="1" type="radio"><label class="label optional" id="user_1_collection_radio_buttons_1_label" for="user_1_collection_radio_buttons_1">1</label><input class="radio_button optional" id="user_1_collection_radio_buttons_2" name="user[collection_radio_buttons]" value="2" type="radio"><label class="label optional" id="user_1_collection_radio_buttons_2_label" for="user_1_collection_radio_buttons_2">2</label></div><div id="user_1_input_array" class="input_array optional"><input type="hidden" value="" id="user_1_input_array_hidden" name="user[input_array][]" hidden autocomplete="off"><input class="input optional" id="user_1_input_array_1" name="user[input_array][]" value="1" type="text"><input class="input optional" id="user_1_input_array_2" name="user[input_array][]" value="2" type="text"></div></form>'
      assert_equal expected, html_string
    end

    def test_that_form_extracts_inputs
      form = Phlexi::Form(:user) {
        field(:name) do |name|
          render name.input_tag
        end
        field(:nicknames) do |name|
          render name.input_array_tag
        end
        nest_one(:location) do |location|
          render location.field(:lat).input_tag
          render location.field(:lng).input_tag
        end
        nest_many(:addresses) do |address|
          render address.field(:street).input_tag
          render address.field(:city).input_tag
        end

        render field(:checked_checkbox).checkbox_tag
        render field(:unchecked_checkbox).checkbox_tag
        render field(:invalid_checkbox).checkbox_tag

        render field(:checked_radio).radio_button_tag
        render field(:unchecked_radio).radio_button_tag
        render field(:invalid_radio).radio_button_tag

        render field(:select).select_tag(collection: 1..5)
        render field(:invalid_select).select_tag(collection: 1..5)
        render field(:multi_select).select_tag(collection: 1..5, multiple: true)

        render field(:collection_checkboxes, collection: 1..5).collection_checkboxes_tag
        render field(:collection_radio_buttons, collection: 1..5).collection_radio_buttons_tag
        render field(:invalid_collection_radio_buttons, collection: 1..5).collection_radio_buttons_tag

        render field(:input_param, input_attributes: {input_param: :custom_input_param}).input_tag

        render submit_button
      }

      params = {
        user: {
          name: "Brad Gessler",
          admin: true,
          nicknames: ["Brad", :Bradley],
          location: {lat: "new_lat"},
          addresses: [
            {street: "Main St", city: "Salem"},
            {street: "Wall St", city: :"New York", state: "New York", admin: true},
            {street: "Acme St", city: "", state: "New York", admin: true}
          ],
          one: {two: {three: {four: 100}}},
          checked_checkbox: "1", unchecked_checkbox: "0", invalid_checkbox: "0",
          checked_radio: "1", unchecked_radio: nil, invalid_radio: "8",
          select: "4", invalid_select: "7", multi_select: [1, 2, 5, 6, 7, nil, ""],
          collection_checkboxes: ["1", 2, "6", 7],
          collection_radio_buttons: "1",
          invalid_collection_radio_buttons: "6",
          input_param: "Mangoes"
        }
      }
      expected_extracted_params = {
        user: {
          name: "Brad Gessler",
          nicknames: ["Brad", "Bradley"],
          location: {lat: "new_lat", lng: nil},
          addresses: [
            {street: "Main St", city: "Salem"},
            {street: "Wall St", city: "New York"},
            {street: "Acme St", city: nil}
          ],
          checked_checkbox: "1", unchecked_checkbox: "0", invalid_checkbox: "0",
          checked_radio: "1",
          select: "4", invalid_select: nil, multi_select: ["1", "2", "5"],
          collection_checkboxes: ["1", "2"],
          collection_radio_buttons: "1",
          invalid_collection_radio_buttons: nil,
          custom_input_param: "Mangoes"
        }
      }
      assert_equal expected_extracted_params, form.extract_input(params)
    end

    class CustomFieldBuilder < Phlexi::Form::Base::FieldBuilder
      def custom_tag(...)
        label_tag(...)
      end
    end

    class CustomFormBase < Phlexi::Form::Base
      class Namespace < Namespace
        def marco
          "Polo"
        end
      end

      private

      def default_builder_klass = CustomFieldBuilder
    end

    class CustomForm < CustomFormBase
      delegate :marco, to: :@namespace
    end

    def test_that_it_uses_implicit_custom_namespace
      form = CustomForm.new(:custom_form)

      assert_equal "Polo", form.marco
      assert form.field(:field).present?
    end

    def test_that_it_uses_explicit_custom_field_builder
      render CustomForm.new(:custom_form) {
        render field(:custom_field).custom_tag
        render field(:custom_field).input_tag
      }

      custom_component = find("label[id='custom_form_custom_field_label']")
      assert custom_component.present?

      assert_input_field_value("custom_form[custom_field]", "")
    end

    def test_submit_button
      render Phlexi::Form(:form) {
        render submit_button
      }

      submit_btn = find("button[id='form_submit_button']")
      assert submit_btn.present?
      if gem_present?("rails")
        assert_equal "Save Form", submit_btn.text
      else
        assert_equal "Submit Form", submit_btn.text
      end
    end

    private

    def assert_form_attributes(method)
      form = find("form")
      assert_equal method, form["method"]
      assert_equal FORM_CHARSET, form["accept-charset"]
    end

    def assert_input_field_value(name, value)
      input = find("input[name='#{name}']")
      assert_equal value, input["value"]
    end
  end
end
