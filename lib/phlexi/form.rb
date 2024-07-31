# frozen_string_literal: true

require "zeitwerk"
require "phlex"

module Phlexi
  module Form
    Loader = Zeitwerk::Loader.new.tap do |loader|
      loader.tag = File.basename(__FILE__, ".rb")
      loader.inflector.inflect(
        "phlexi-form" => "Phlexi",
        "phlexi" => "Phlexi",
        "dom" => "DOM",
      )
      loader.push_dir(File.expand_path("..", __dir__))
      loader.ignore(File.expand_path("../generators", __dir__))
      loader.setup
    end

    BaseComponent = (defined?(::ApplicationComponent) ?  ::ApplicationComponent :  Phlex::HTML)

    class Error < StandardError; end
  end
end


def Phlexi::Form(...)
  Phlexi::Form::Base.new(...)
end
