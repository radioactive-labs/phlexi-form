# frozen_string_literal: true

module Phlexi
  module Form
    module Options
      module Hints
        def show_hint?
          has_hint? && !show_errors?
        end
      end
    end
  end
end
