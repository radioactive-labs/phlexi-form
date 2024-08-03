# Phlexi::Form 

Phlexi::Form is a flexible and powerful form builder for Ruby on Rails applications. It provides a more customizable and extensible way to create forms compared to traditional Rails form helpers.

[![Ruby](https://github.com/radioactive-labs/phlexi-form/actions/workflows/main.yml/badge.svg)](https://github.com/radioactive-labs/phlexi-form/actions/workflows/main.yml)

## Features

- Flexible form structure with support for nested attributes
- Customizable form components (input, select, checkbox, radio button, etc.)
- Automatic field type and attribute inference based on model attributes
- Built-in support for validations and error handling
- Easy integration with Phlex views
- Extract input from parameters that match your form definition


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'phlexi-form'
```

And then execute:

```
$ bundle install
```

Or install it yourself as:

```
$ gem install phlexi-form
```

## Usage

Here's a basic example of how to use Phlexi::Form:

```ruby
class UserForm < Phlexi::Form::Base
  def template
    form do
      field(:name) do |name|
        render name.label_tag
        render name.input_tag
      end

      field(:email) do |email|
        render email.label_tag
        render email.input_tag
      end

      nest_one(:address) do |address|
        address.field(:street) do |street|
          render street.label_tag
          render street.input_tag
        end

        address.field(:city) do |city|
          render city.label_tag
          render city.input_tag
        end
      end

      button(type: "submit") { "Submit" }
    end
  end
end

# In your view or controller
render UserForm.new(User.new)
```

## Advanced Usage

### Custom Components

You can create custom form components by inheriting from `Phlexi::Form::Components::Base`:

```ruby
class CustomInput < Phlexi::Form::Components::Base
  def template
    div(class: "custom-input") do
      input(**attributes)
      span(class: "custom-icon")
    end
  end
end

# Usage in your form
field(:custom_field) do |field|
  render CustomInput.new(field)
end
```

### Theming

Phlexi::Form supports theming through a flexible theming system:

```ruby
class ThemedForm < Phlexi::Form::Base
  def initialize(record, **options)
    super(record, theme: custom_theme, **options)
  end

  private

  def custom_theme
    {
      input: "border rounded px-2 py-1",
      label: "font-bold text-gray-700",
      # Add more theme options here
    }
  end
end
```

<!-- ## Configuration

You can configure Phlexi::Form globally by creating an initializer:

```ruby
# config/initializers/phlexi_form.rb
Phlexi::Form.configure do |config|
  config.default_theme = {
    # Your default theme options
  }
  # Add more configuration options here
end
``` -->

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/radioactive-labs/phlexi-form.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
