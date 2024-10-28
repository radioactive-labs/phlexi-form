# frozen_string_literal: true

module Phlexi
  module Form
    module Structure
      class Namespace < Phlexi::Field::Structure::Namespace
        include Phlexi::Form::Structure::ManagesFields
        
        class NamespaceCollection < Phlexi::Form::Structure::NamespaceCollection; end

        def submit_button(key = :submit_button, **, &)
          field(key).submit_button_tag(**, &)
        end

        def extract_input(params)
          if params.is_a?(Array)
            each_with_object({}) do |child, hash|
              hash.merge! child.extract_input(params[0])
            end
          elsif params.is_a?(Hash)
            input = each_with_object({}) do |child, hash|
              input = params[key].is_a?(Hash) ? params[key] : {}
              hash.merge! child.extract_input(input)
            end
            {key => input}
          else
            {key => {}}
          end
        end
      end
    end
  end
end
