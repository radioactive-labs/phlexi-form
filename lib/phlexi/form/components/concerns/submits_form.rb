# frozen_string_literal: true

module Phlexi
  module Form
    module Components
      module Concerns
        module SubmitsForm
          include Phlexi::Form::Components::Concerns::ExtractsInput

          def extract_input(params)
            {}
          end

          protected

          def submit_type_value
            if field.object.respond_to?(:persisted?)
              field.object.persisted? ? :update : :create
            else
              :submit
            end
          end

          def submit_type_label
            @submit_type_label ||= begin
              key = submit_type_value

              model_object = field.dom.lineage.first.key.to_s
              model_name_human = if field.object.respond_to?(:model_name)
                field.object.model_name.human
              else
                model_object.humanize
              end

              defaults = []
              defaults << :"helpers.submit.#{model_object}.#{key}"
              defaults << :"helpers.submit.#{key}"
              defaults << "#{key.to_s.humanize} #{model_name_human}"

              I18n.t(defaults.shift, model: model_name_human, default: defaults)
            end
          end
        end
      end
    end
  end
end
