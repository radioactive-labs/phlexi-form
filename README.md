# Phlexi::Form 

Phlexi::Form is a flexible and powerful form builder for Ruby applications. It provides a more customizable and extensible way to create forms compared to traditional form helpers.

[![Ruby](https://github.com/radioactive-labs/phlexi-form/actions/workflows/main.yml/badge.svg)](https://github.com/radioactive-labs/phlexi-form/actions/workflows/main.yml)

## Features

- Customizable form components (input, select, checkbox, radio button, etc.)
- Automatic field type and attribute inference based on model attributes
- Built-in support for validations and error handling
- Flexible form structure with support for nested attributes
- Works with Phlex or erb views
- Extract input from parameters that match your form definition. No need to strong paramters.
- Rails compatible form inputs


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

There are 2 ways to use Phlexi::Form:

### Direct Usage

```ruby
Phlexi::Form(User.new) do
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

  render submit_button
end
```

> **Important**
>
> If you are rendering your form inline e.g. 
> ```ruby
> render Phlexi::Form(User.new) {
>   render field(:name).label_tag
>   render field(:name).input_tag
> }
> ```
>
> Make sure you use `{...}` in defining your block instead of `do...end`
> This might be fixed in a future version.

### Inherit form

```ruby
class UserForm < Phlexi::Form::Base
  def form_template
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

    render submit_button
  end
end


# In your view or controller
form = UserForm.new(User.new)

# Render the form
render form

# Extract params
form.extract_input({
  name: "Brad Pitt",
  email: "brad@pitt.com",
  address: {
    street: "Plumbago",
    city: "Accra",
  }
})
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
  class FieldBuilder < FieldBuilder
    private
    
    def default_theme
      {
        input: "border rounded px-2 py-1",
        label: "font-bold text-gray-700",
        # Add more theme options here
      }
    end
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
