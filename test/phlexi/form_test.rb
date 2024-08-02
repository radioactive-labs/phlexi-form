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
        name: "William Bills",
        nicknames: ["Bill", "Billy", "Will"],
        location: OpenStruct.new(lat: "lat", lng: "lng"),
        addresses: [
          OpenStruct.new(street: "Birch Ave", city: "Williamsburg"),
          OpenStruct.new(street: "Main St", city: "Salem")
        ]
      )

      @params = {
        name: {first: "Brad", last: "Gessler", admin: true},
        admin: true,
        nicknames: ["Brad", "Bradley"],
        addresses: [
          {street: "Main St", city: "Salem"},
          {street: "Wall St", city: "New York", state: "New York", admin: true},
          {street: "Wall", city: "York", state: "New York", admin: true}
        ],
        one: {two: {three: {four: 100}}}
      }
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
      expected = Phlexi::Form(@user) do
        render field(:field).label_tag
        render field(:field).input_tag
        render field(:textarea).textarea_tag
        render field(:select).select_tag
        render field(:checkbox).checkbox_tag
        render field(:radio).radio_button_tag
        render field(:collection_checkboxes, collection: 1..5).collection_checkboxes_tag
        render field(:collection_radio_buttons, collection: 1..5).collection_radio_buttons_tag
      end.call
      assert_equal expected, "<form method=\"post\" accept-charset=\"UTF-8\"><label class=\"label optional\" id=\"user_field_label\" for=\"user_field\">Field</label><input class=\"input optional\" id=\"user_field\" name=\"user[field]\" value=\"\" type=\"text\"><textarea class=\"textarea optional\" id=\"user_textarea\" name=\"user[textarea]\"></textarea><select class=\"select optional\" id=\"user_select\" name=\"user[select]\"><option selected></option></select><input type=\"hidden\" name=\"user[checkbox]\" value=\"0\" autocomplete=\"off\" hidden><input class=\"checkbox optional\" id=\"user_checkbox\" name=\"user[checkbox]\" value=\"1\" type=\"checkbox\"><input class=\"radio_button optional\" id=\"user_radio\" name=\"user[radio]\" value=\"1\" type=\"radio\"><input class=\"input optional\" type=\"hidden\" value=\"\" hidden autocomplete=\"off\" id=\"user_collection_checkboxes\" name=\"user[collection_checkboxes][]\"><input class=\"checkbox optional\" id=\"user_collection_checkboxes_1\" name=\"user[collection_checkboxes][]\" value=\"1\" type=\"checkbox\"><label class=\"label 1 optional\" checked-value=\"1\" id=\"user_collection_checkboxes_1_label\" for=\"user_collection_checkboxes_1\">1</label><input class=\"checkbox optional\" id=\"user_collection_checkboxes_2\" name=\"user[collection_checkboxes][]\" value=\"2\" type=\"checkbox\"><label class=\"label 2 optional\" checked-value=\"2\" id=\"user_collection_checkboxes_2_label\" for=\"user_collection_checkboxes_2\">2</label><input class=\"checkbox optional\" id=\"user_collection_checkboxes_3\" name=\"user[collection_checkboxes][]\" value=\"3\" type=\"checkbox\"><label class=\"label 3 optional\" checked-value=\"3\" id=\"user_collection_checkboxes_3_label\" for=\"user_collection_checkboxes_3\">3</label><input class=\"checkbox optional\" id=\"user_collection_checkboxes_4\" name=\"user[collection_checkboxes][]\" value=\"4\" type=\"checkbox\"><label class=\"label 4 optional\" checked-value=\"4\" id=\"user_collection_checkboxes_4_label\" for=\"user_collection_checkboxes_4\">4</label><input class=\"checkbox optional\" id=\"user_collection_checkboxes_5\" name=\"user[collection_checkboxes][]\" value=\"5\" type=\"checkbox\"><label class=\"label 5 optional\" checked-value=\"5\" id=\"user_collection_checkboxes_5_label\" for=\"user_collection_checkboxes_5\">5</label><input class=\"input optional\" type=\"hidden\" value=\"\" hidden autocomplete=\"off\" id=\"user_collection_radio_buttons\" name=\"user[collection_radio_buttons]\"><input class=\"radio_button optional\" id=\"user_collection_radio_buttons_1\" name=\"user[collection_radio_buttons]\" value=\"1\" type=\"radio\"><label class=\"label 1 optional\" checked-value=\"1\" id=\"user_collection_radio_buttons_1_label\" for=\"user_collection_radio_buttons_1\">1</label><input class=\"radio_button optional\" id=\"user_collection_radio_buttons_2\" name=\"user[collection_radio_buttons]\" value=\"2\" type=\"radio\"><label class=\"label 2 optional\" checked-value=\"2\" id=\"user_collection_radio_buttons_2_label\" for=\"user_collection_radio_buttons_2\">2</label><input class=\"radio_button optional\" id=\"user_collection_radio_buttons_3\" name=\"user[collection_radio_buttons]\" value=\"3\" type=\"radio\"><label class=\"label 3 optional\" checked-value=\"3\" id=\"user_collection_radio_buttons_3_label\" for=\"user_collection_radio_buttons_3\">3</label><input class=\"radio_button optional\" id=\"user_collection_radio_buttons_4\" name=\"user[collection_radio_buttons]\" value=\"4\" type=\"radio\"><label class=\"label 4 optional\" checked-value=\"4\" id=\"user_collection_radio_buttons_4_label\" for=\"user_collection_radio_buttons_4\">4</label><input class=\"radio_button optional\" id=\"user_collection_radio_buttons_5\" name=\"user[collection_radio_buttons]\" value=\"5\" type=\"radio\"><label class=\"label 5 optional\" checked-value=\"5\" id=\"user_collection_radio_buttons_5_label\" for=\"user_collection_radio_buttons_5\">5</label></form>"
    end

    def test_that_form_assigns
      form = Phlexi::Form(@user) {
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
      form.call

      original_hash = {name: "William Bills", location: {lat: "lat", lng: "lng"},
                       addresses: [{street: "Birch Ave", city: "Williamsburg"}, {street: "Main St", city: "Salem"}]}
      assert_equal original_hash, form.serialize

      form.assign @params

      assigned_hash = {name: {first: "Brad", last: "Gessler", admin: true}, location: {lat: nil, lng: nil},
                       addresses: [{street: "Main St", city: "Salem"}, {street: "Wall St", city: "New York"}]}
      assert_equal assigned_hash, form.serialize
    end

    private

    def assert_form_attributes(method)
      form = find("form")
      assert_equal method, form["method"]
      assert_equal FORM_CHARSET, form["accept-charset"]
    end

    def assert_input_field_value(name, value)
      input = find("input[name='#{name}']")
      assert input.present?
      assert_equal value, input["value"]
    end
  end
end
