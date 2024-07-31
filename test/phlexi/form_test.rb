# frozen_string_literal: true

require "test_helper"
require "ostruct"

module Phlexi
  class FormTest < Minitest::Test
    include Capybara::DSL
    # include Capybara::Minitest::Assertions
    include Phlex::Testing::Capybara::ViewHelper

    def user
      @user ||= OpenStruct.new \
        model_name: OpenStruct.new(param_key: "user"),
        name: OpenStruct.new(first: "William", last: "Bills"),
        nicknames: ["Bill", "Billy", "Will"],
        addresses: [
          OpenStruct.new(street: "Birch Ave", city: "Williamsburg", state: "New Mexico"),
          OpenStruct.new(street: "Main St", city: "Salem", state: "Indiana")
        ]
    end

    def params
      @params ||= {
        name: {first: "Brad", last: "Gessler", admin: true},
        admin: true,
        nicknames: ["Brad", "Bradley"],
        addresses: [
          {street: "Main St", city: "Salem"},
          {street: "Wall St", city: "New York", state: "New York", admin: true}
        ],
        one: {two: {three: {four: 100}}}
      }
    end

    def test_that_it_renders_form
      render Phlexi::Form(:object) { render field(:name).input_tag }
      form = find("form")
      assert_equal "get", form["method"]
      assert_equal "UTF-8", form["accept-charset"]
      assert form.has_css?('input[name="object[name]"]')

      input_node = form.find('input[name="object[name]"]')
      # assert input_node.present?
      assert_equal "object_name", input_node["id"]
    end

    def test_that_it_renders_with_object
      expected = Phlexi::Form(user) do
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

    def test_that_it_renders_with_symbol
      expected = Phlexi::Form(:user) do
        render field(:field).label_tag
        render field(:field).input_tag
        render field(:textarea).textarea_tag
        render field(:select).select_tag
        render field(:checkbox).checkbox_tag
        render field(:radio).radio_button_tag
        render field(:collection_checkboxes, collection: 1..5).collection_checkboxes_tag
        render field(:collection_radio_buttons, collection: 1..5).collection_radio_buttons_tag
      end.call
      assert_equal expected, "<form method=\"get\" accept-charset=\"UTF-8\"><label class=\"label optional\" id=\"user_field_label\" for=\"user_field\">Field</label><input class=\"input optional\" id=\"user_field\" name=\"user[field]\" value=\"\" type=\"text\"><textarea class=\"textarea optional\" id=\"user_textarea\" name=\"user[textarea]\"></textarea><select class=\"select optional\" id=\"user_select\" name=\"user[select]\"><option selected></option></select><input type=\"hidden\" name=\"user[checkbox]\" value=\"0\" autocomplete=\"off\" hidden><input class=\"checkbox optional\" id=\"user_checkbox\" name=\"user[checkbox]\" value=\"1\" type=\"checkbox\"><input class=\"radio_button optional\" id=\"user_radio\" name=\"user[radio]\" value=\"1\" type=\"radio\"><input class=\"input optional\" type=\"hidden\" value=\"\" hidden autocomplete=\"off\" id=\"user_collection_checkboxes\" name=\"user[collection_checkboxes][]\"><input class=\"checkbox optional\" id=\"user_collection_checkboxes_1\" name=\"user[collection_checkboxes][]\" value=\"1\" type=\"checkbox\"><label class=\"label 1 optional\" checked-value=\"1\" id=\"user_collection_checkboxes_1_label\" for=\"user_collection_checkboxes_1\">1</label><input class=\"checkbox optional\" id=\"user_collection_checkboxes_2\" name=\"user[collection_checkboxes][]\" value=\"2\" type=\"checkbox\"><label class=\"label 2 optional\" checked-value=\"2\" id=\"user_collection_checkboxes_2_label\" for=\"user_collection_checkboxes_2\">2</label><input class=\"checkbox optional\" id=\"user_collection_checkboxes_3\" name=\"user[collection_checkboxes][]\" value=\"3\" type=\"checkbox\"><label class=\"label 3 optional\" checked-value=\"3\" id=\"user_collection_checkboxes_3_label\" for=\"user_collection_checkboxes_3\">3</label><input class=\"checkbox optional\" id=\"user_collection_checkboxes_4\" name=\"user[collection_checkboxes][]\" value=\"4\" type=\"checkbox\"><label class=\"label 4 optional\" checked-value=\"4\" id=\"user_collection_checkboxes_4_label\" for=\"user_collection_checkboxes_4\">4</label><input class=\"checkbox optional\" id=\"user_collection_checkboxes_5\" name=\"user[collection_checkboxes][]\" value=\"5\" type=\"checkbox\"><label class=\"label 5 optional\" checked-value=\"5\" id=\"user_collection_checkboxes_5_label\" for=\"user_collection_checkboxes_5\">5</label><input class=\"input optional\" type=\"hidden\" value=\"\" hidden autocomplete=\"off\" id=\"user_collection_radio_buttons\" name=\"user[collection_radio_buttons]\"><input class=\"radio_button optional\" id=\"user_collection_radio_buttons_1\" name=\"user[collection_radio_buttons]\" value=\"1\" type=\"radio\"><label class=\"label 1 optional\" checked-value=\"1\" id=\"user_collection_radio_buttons_1_label\" for=\"user_collection_radio_buttons_1\">1</label><input class=\"radio_button optional\" id=\"user_collection_radio_buttons_2\" name=\"user[collection_radio_buttons]\" value=\"2\" type=\"radio\"><label class=\"label 2 optional\" checked-value=\"2\" id=\"user_collection_radio_buttons_2_label\" for=\"user_collection_radio_buttons_2\">2</label><input class=\"radio_button optional\" id=\"user_collection_radio_buttons_3\" name=\"user[collection_radio_buttons]\" value=\"3\" type=\"radio\"><label class=\"label 3 optional\" checked-value=\"3\" id=\"user_collection_radio_buttons_3_label\" for=\"user_collection_radio_buttons_3\">3</label><input class=\"radio_button optional\" id=\"user_collection_radio_buttons_4\" name=\"user[collection_radio_buttons]\" value=\"4\" type=\"radio\"><label class=\"label 4 optional\" checked-value=\"4\" id=\"user_collection_radio_buttons_4_label\" for=\"user_collection_radio_buttons_4\">4</label><input class=\"radio_button optional\" id=\"user_collection_radio_buttons_5\" name=\"user[collection_radio_buttons]\" value=\"5\" type=\"radio\"><label class=\"label 5 optional\" checked-value=\"5\" id=\"user_collection_radio_buttons_5_label\" for=\"user_collection_radio_buttons_5\">5</label></form>"
    end

    # it "has correct DOM names" do
    #   spec = self
    #   component = Phlexi::Form :user, object: user do
    #     nest_one(:name) do |name|
    #       name.field(:first).dom.tap do |dom|
    #         spec.expect(dom.id).to spec.eql("user_name_first")
    #         spec.expect(dom.name).to spec.eql("user[name][first]")
    #       end
    #     end
    #     field(:nicknames).multi do |field|
    #       field.dom.tap do |dom|
    #         spec.expect(dom.id).to spec.match /user_nicknames_\d+/
    #         spec.expect(dom.name).to spec.eql("user[nicknames][]")
    #       end
    #     end
    #     nest_many(:addresses) do |address|
    #       address.field(:street).dom.tap do |dom|
    #         spec.expect(dom.id).to spec.match /user_addresses_\d_street+/
    #         spec.expect(dom.name).to spec.eql("user[addresses][][street]")
    #       end
    #       address.field(:city)
    #       address.field(:state)
    #     end
    #     nest_one(:one).nest_one(:two).nest_one(:three).field(:four).dom.tap do |dom|
    #       spec.expect(dom.id).to spec.eql("user_one_two_three_four")
    #       spec.expect(dom.name).to spec.eql("user[one][two][three][four]")
    #     end
    #   end

    #   rendered = component.call
    #   expect(rendered).to include("<h1>Hello, Alice!</h1>")
    # end
  end
end
