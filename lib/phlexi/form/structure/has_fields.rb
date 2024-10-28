# frozen_string_literal: true

module Phlexi
  module Form
    module Structure
      module HasFields
        def has_file_input!
          if parent
           parent.has_file_input!
          else
            @has_file_input = true
          end
        end

        def has_file_input?
          if parent
           parent.has_file_input?
          else
            @has_file_input || false
          end
        end
      end
    end
  end
end
