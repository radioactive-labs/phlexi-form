# frozen_string_literal: true

module Phlexi
  module Form
    module Components
      class FormErrors < Phlexi::Form::HTML
        def initialize(message, errors)
          @message = message
          @errors = errors
        end

        def view_template
          div(class: themed(:form_errors_wrapper, nil), role: "alert") do
            div(class: themed(:form_errors_inner_wrapper, nil)) do
              p(class: themed(:form_errors_message, nil)) { @message }
              ul(class: themed(:form_errors_list, nil)) do
                @errors.each do |error|
                  li(class: themed(:form_errors_list_item, nil)) { 
                    error.to_s
                  }
                end
              end
            end
          end
        end
      end
    end
  end
end
