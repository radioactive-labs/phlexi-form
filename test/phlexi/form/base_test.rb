# test/phlexi/form/base_test.rb

require "test_helper"
require "ostruct"

module Phlexi
  module Form
    class BaseTest < Minitest::Test
      include Capybara::DSL
      include Phlex::Testing::Capybara::ViewHelper

      class User
        attr_accessor :id, :name, :email, :address, :hobbies

        def initialize(attributes = {})
          attributes.each do |key, value|
            send(:"#{key}=", value)
          end
        end

        def persisted?
          id.present?
        end
      end

      class Address
        attr_accessor :street, :city

        def initialize(attributes = {})
          attributes.each do |key, value|
            send(:"#{key}=", value)
          end
        end
      end

      def setup
        @user = User.new(
          id: 1,
          name: "John Doe",
          email: "john@example.com",
          address: Address.new(
            street: "123 Main St",
            city: "Anytown"
          ),
          hobbies: ["Reading", "Cycling"]
        )
      end

      def test_initialization
        form = Base.new(@user)
        assert_equal :user, form.key
        assert_equal @user, form.object
      end

      def test_field_creation
        form = Base.new(@user) do
          field(:name) do |name|
            render name.input_tag
          end
        end

        render form

        input = find("input[name='user[name]']")
        assert_equal "John Doe", input.value
      end

      def test_nested_form
        form = Base.new(@user) do
          nest_one(:address) do |address|
            render address.field(:street).input_tag
            render address.field(:city).input_tag
          end
        end

        render form

        street_input = find("input[name='user[address][street]']")
        city_input = find("input[name='user[address][city]']")
        assert_equal "123 Main St", street_input.value
        assert_equal "Anytown", city_input.value
      end

      def test_collection_form
        form = Base.new(@user) do
          field(:hobbies) do |hobby|
            render hobby.input_array_tag
          end
        end

        render form

        hobby_inputs = all("input[name='user[hobbies][]']")
        assert_equal 2, hobby_inputs.size
        assert_equal "Reading", hobby_inputs[0].value
        assert_equal "Cycling", hobby_inputs[1].value
      end

      def test_input_extraction
        form = Base.new(@user) do
          field(:name) { |name| render name.input_tag }
          field(:email) { |email| render email.input_tag }
          nest_one(:address) do |address|
            render address.field(:street).input_tag
            render address.field(:city).input_tag
          end
          field(:hobbies) do |hobby|
            render hobby.input_array_tag
          end

          render submit_button
        end

        params = {
          user: {
            name: "Jane Smith",
            email: "jane@example.com",
            address: {
              street: "456 Elm St",
              city: "Othertown"
            },
            hobbies: ["Painting", "Cooking", "Gardening"]
          }
        }

        extracted_input = form.extract_input(params)

        assert_equal "Jane Smith", extracted_input[:user][:name]
        assert_equal "jane@example.com", extracted_input[:user][:email]
        assert_equal "456 Elm St", extracted_input[:user][:address][:street]
        assert_equal "Othertown", extracted_input[:user][:address][:city]
        assert_equal ["Painting", "Cooking", "Gardening"], extracted_input[:user][:hobbies]
      end

      def test_form_action_and_method
        form = Base.new(@user, action: "/update_user", method: "patch")
        render form

        form_element = find("form")
        assert_equal "/update_user", form_element[:action]
        assert_equal "post", form_element[:method]
        assert_equal "patch", find("input[name='_method']", visible: false).value
      end

      def test_custom_form_attributes
        form = Base.new(@user, attributes: {class: "custom-form", data: {controller: "form"}})
        render form

        form_element = find("form")
        assert_includes form_element[:class], "custom-form"
        assert_equal "form", form_element[:"data-controller"]
      end
    end
  end
end
