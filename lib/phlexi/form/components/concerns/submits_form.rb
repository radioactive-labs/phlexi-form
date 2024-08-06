# frozen_string_literal: true

module Phlexi
  module Form
    module Components
      module Concerns
        module SubmitsForm
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

          # def submit(value = nil, options = {})
          #   value, options = nil, value if value.is_a?(Hash)
          #   value ||= submit_default_value
          #   @template.submit_tag(value, options)
          # end

          # def submit_tag(value = "Save changes", options = {})
          #   options = options.deep_stringify_keys
          #   tag_options = { "type" => "submit", "name" => "commit", "value" => value }.update(options)
          #   set_default_disable_with value, tag_options
          #   tag :input, tag_options
          # end

          # def button_tag(content_or_options = nil, options = nil, &block)
          #   if content_or_options.is_a? Hash
          #     options = content_or_options
          #   else
          #     options ||= {}
          #   end

          #   options = { "name" => "button", "type" => "submit" }.merge!(options.stringify_keys)

          #   if block_given?
          #     content_tag :button, options, &block
          #   else
          #     content_tag :button, content_or_options || "Button", options
          #   end
          # end

          # def button(value = nil, options = {}, &block)
          #   case value
          #   when Hash
          #     value, options = nil, value
          #   when Symbol
          #     value, options = nil, { name: field_name(value), id: field_id(value) }.merge!(options.to_h)
          #   end
          #   value ||= submit_default_value

          #   if block_given?
          #     value = @template.capture { yield(value) }
          #   end

          #   formmethod = options[:formmethod]
          #   if formmethod.present? && !/post|get/i.match?(formmethod) && !options.key?(:name) && !options.key?(:value)
          #     options.merge! formmethod: :post, name: "_method", value: formmethod
          #   end

          #   @template.button_tag(value, options)
          # end
        end
      end
    end
  end
end
