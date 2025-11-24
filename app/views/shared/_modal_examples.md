# Modal Component Usage Guide

The modal component is now available application-wide. Here's how to use it:

## Basic Usage

### 1. In your view, add a link that opens the modal:

```erb
<%= link_to "Open Modal", your_modal_path,
    data: { turbo_frame: "modal" } %>
```

Or use the helper:
```erb
<%= modal_link_to "Open Modal", your_modal_path %>
```

### 2. Create a route for your modal:

```ruby
# config/routes.rb
resources :your_resource do
  member do
    get :your_modal_action
  end
end
```

### 3. Create a controller action:

```ruby
def your_modal_action
  render layout: false
end
```

### 4. Create the modal view:

```erb
<!-- app/views/your_resource/your_modal_action.html.erb -->
<%= turbo_frame_tag "modal" do %>
  <%= render "shared/modal", close_url: your_resource_path do %>
    <!-- Your modal content here -->
    <h3>Modal Title</h3>
    <p>Modal content...</p>
  <% end %>
<% end %>
```

## Modal Options

The modal partial accepts these options:

- `close_url` - URL to navigate when closing (default: `request.referer || root_path`)
- `size` - Modal size: `:small`, `:medium`, `:large`, `:xl` (default: `:medium`)
- `show_close_button` - Show/hide the X button (default: `true`)

### Examples:

```erb
<!-- Large modal without close button -->
<%= render "shared/modal", size: :large, show_close_button: false do %>
  Content here
<% end %>

<!-- Small modal with custom close URL -->
<%= render "shared/modal", size: :small, close_url: root_path do %>
  Content here
<% end %>
```

## Examples for Different Use Cases

### Delete Confirmation Modal
See: `app/views/authors/delete_confirmation.html.erb`

### Form Modal
```erb
<%= turbo_frame_tag "modal" do %>
  <%= render "shared/modal", size: :large do %>
    <%= render "form", resource: @resource %>
  <% end %>
<% end %>
```

### Info/Alert Modal
```erb
<%= turbo_frame_tag "modal" do %>
  <%= render "shared/modal", size: :small do %>
    <div class="text-center">
      <h3 class="text-lg font-medium mb-2">Information</h3>
      <p>Your message here</p>
    </div>
  <% end %>
<% end %>
```


