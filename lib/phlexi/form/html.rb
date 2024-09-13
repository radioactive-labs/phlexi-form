module Phlexi
  module Form
    class HTML < (defined?(::ApplicationComponent) ? ::ApplicationComponent : Phlex::HTML)
      module Behaviour
        protected

        def themed(component, field)
          base_theme = Phlexi::Form::Theme.instance.resolve_theme(component)
          validity_theme = Phlexi::Form::Theme.instance.resolve_validity_theme(component, field)

          tokens(base_theme, validity_theme)
        end
      end

      include Behaviour
    end
  end
end
