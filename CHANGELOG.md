## [Unreleased]

## [0.14.3]

- Fix `Checkbox#checked?` so boolean-ish values from JSON/text columns or params
  (`"f"`, `"F"`, `"FALSE"`, `"off"`, `"OFF"`, `0`, `:false`, ...) render unchecked.
  The recognised falsey set now mirrors Rails' `ActiveModel::Type::Boolean::FALSE_VALUES`
  instead of only `""`, `"0"` and lowercase `"false"`.

## [0.2.0] - 2024-07-31

- Initial release
