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

        def test_associations
          return unless gem_present?("rails")

          user1 = User.create! name: "John Doe"
          Post.create! user: user1, body: "User 1 Post 1"
          Post.create! user: user1, body: "User 1 Post 2"

          user2 = User.create! name: "Jane Doe"
          post = Post.create! user: user2, body: "User 2 Post 1"

          user_form = Phlexi::Form(user1) {
            render field(:posts).select_tag(label_method: :body)
          }
          expected_user_form_html = '<form id="user_1" method="post" accept-charset="UTF-8"><input name="_method" value="patch" type="hidden" hidden><input type="hidden" name="user[posts]" value="" autocomplete="off" hidden><select class="select optional" id="user_1_posts" name="user[posts]" multiple><option selected value="1">User 1 Post 1</option><option selected value="2">User 1 Post 2</option><option value="3">User 2 Post 1</option></select></form>'
          assert_equal expected_user_form_html, user_form.call

          post_form = Phlexi::Form(post) {
            render field(:user).select_tag
          }
          expected_post_form_html = '<form id="post_3" method="post" accept-charset="UTF-8"><input name="_method" value="patch" type="hidden" hidden><select class="select optional" id="post_3_user" name="post[user]"><option></option><option value="1">John Doe</option><option selected value="2">Jane Doe</option></select></form>'
          assert_equal expected_post_form_html, post_form.call
        end
      end
    end
  end
end
