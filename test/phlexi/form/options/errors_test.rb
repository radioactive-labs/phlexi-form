# frozen_string_literal: true

# Runs without test_helper, so it needs only ActiveModel, not the Rails app
# and the view helpers the rendering tests use.
require "minitest/autorun"
require "phlexi-form"
require "active_model"

module Phlexi
  module Form
    module Options
      class ErrorsTest < Minitest::Test
        class Account
          include ActiveModel::Model

          attr_accessor :oidc_issuer

          validates :oidc_issuer, presence: true
        end

        def setup
          @account = Account.new
          @account.valid?
        end

        def test_full_error_names_the_attribute_by_default
          assert_equal "Oidc issuer can't be blank", full_error(:oidc_issuer)
        end

        def test_full_error_uses_the_fields_own_label
          assert_equal "Issuer URL can't be blank", full_error(:oidc_issuer, label: "Issuer URL")
        end

        def test_full_error_falls_back_when_the_label_is_hidden
          assert_equal "Oidc issuer can't be blank", full_error(:oidc_issuer, label: false)
        end

        def test_full_error_keeps_a_custom_attribute_format
          ActiveModel::Error.i18n_customize_full_message = true
          I18n.backend.store_translations(:en, activemodel: {errors: {models: {"phlexi/form/options/errors_test/account": {attributes: {oidc_issuer: {format: "%{attribute} is required"}}}}}})

          assert_equal "Issuer URL is required", full_error(:oidc_issuer, label: "Issuer URL")
        ensure
          ActiveModel::Error.i18n_customize_full_message = false
          I18n.backend.reload!
        end

        def test_error_is_unchanged_by_the_label
          assert_equal "can't be blank", Base.new(@account).field(:oidc_issuer, label: "Issuer URL").error
        end

        private

        def full_error(key, **options)
          Base.new(@account).field(key, **options).full_error
        end
      end
    end
  end
end
