# frozen_string_literal: true

module Phlexi
  module Form
    module Options
      module Readonly
        def readonly?
          options[:readonly] == true
        end

        def readonly!(readonly = true)
          options[:readonly] = readonly
          self
        end
      end
    end
  end
end
