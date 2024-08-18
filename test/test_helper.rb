require "phlexi-form"

require "minitest/autorun"
require "minitest/reporters"
Minitest::Reporters.use!

require "phlex/testing/capybara"
require "capybara/minitest"

def gem_present?(gem_name)
  Gem::Specification.find_all_by_name(gem_name).any?
end

return unless gem_present?("rails")

require "combustion"
Combustion.path = "test/internal"
Combustion.initialize! :active_record, :action_controller

Rails.application.config.action_dispatch.show_exceptions = :none
