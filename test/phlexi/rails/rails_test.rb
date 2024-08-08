# frozen_string_literal: true

require "test_helper"

return unless gem_present?("rails")

module Phlexi
  module Rails
    class RailsTest < ActionDispatch::IntegrationTest
      include ::Rails.application.routes.url_helpers

      def test_something
        post users_path, params: {marco: :polo}
        assert_response :success
        assert_equal "OK", response.body
      end
    end
  end
end
