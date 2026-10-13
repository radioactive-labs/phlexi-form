## [Unreleased]

## [0.14.4]

- A field's full error now names the attribute by the field's own label when it
  is given one (`field(:oidc_issuer, label: "Issuer URL")`), so the message
  under the field matches the label above it. Fields without a label, or with
  `label: false`, keep ActiveModel's `human_attribute_name`. Per-model and
  per-attribute `format` overrides still apply.
- `input_tag` on a field inferred as `:string` now renders a text input with the
  usual text attributes, instead of falling through to the unhandled-type branch.
- Fix extracting input from an empty nested collection (`nest_many`), which
  passed `nil` to the block.

## [0.14.3]

- Fix `Checkbox#checked?` so boolean-ish values from JSON/text columns or params
  (`"f"`, `"F"`, `"FALSE"`, `"off"`, `"OFF"`, `0`, `:false`, ...) render unchecked.
  The recognised falsey set now mirrors Rails' `ActiveModel::Type::Boolean::FALSE_VALUES`
  instead of only `""`, `"0"` and lowercase `"false"`.

## [0.2.0] - 2024-07-31

- Initial release
