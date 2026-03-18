## Keystone UI

> **DO NOT** explore the keystone_ui gem source code. This reference is the
> complete API. Use only the helpers listed below in your ERB views. All
> styling is handled internally by the components — never add Tailwind
> classes to override them.

### Rules
- Mobile-first — primary UI is often a native webview
- Use simple labels (e.g. "Create", "Save") not resource-specific ones
- Use helpers, not component classes directly
- All layout goes through `ui_page`, `ui_grid`, `ui_section`, `ui_panel`
- Navigation uses `ui_navbar` with slots, `ui_bottom_nav` for mobile tabs

---

### `ui_card`

```erb
<%= ui_card(title: "…", summary: "…", link: "…") %>
<%= ui_card(title: "…", summary: "…", link: "…", cta: "Learn more") %>
```

| Param | Required | Default |
|-------|----------|---------|
| `title:` | yes | — |
| `summary:` | yes | — |
| `link:` | yes | — |
| `cta:` | no | `"Read more"` |
| `edge_to_edge:` | no | `false` | removes side borders/radius on mobile when `true` |

### `ui_button`

```erb
<%= ui_button(label: "Save") %>
<%= ui_button(label: "Visit", href: "/path", variant: :secondary, size: :lg) %>
```

| Param | Required | Default | Values |
|-------|----------|---------|--------|
| `label:` | yes | — | — |
| `href:` | no | `nil` | renders `<a>` when set, `<button>` otherwise |
| `variant:` | no | `:primary` | `:primary`, `:secondary`, `:danger` |
| `size:` | no | `:md` | `:sm`, `:md`, `:lg` |
| `type:` | no | `:submit` | HTML button type (ignored when `href` is set) |
| `data:` | no | `nil` | hash of data attributes (e.g. Stimulus targets/actions) |

### `ui_data_table`

```erb
<%= ui_data_table(items: @users, columns: [{ name: "Name" }, { email: "Email" }]) %>
```

**With Column objects** (for per-column options like `mobile_hidden`):

```erb
<%
  columns = [
    Keystone::Ui::Column.new(:name, "Name"),
    Keystone::Ui::Column.new(:email, "Email", mobile_hidden: true)
  ]
%>
<%= ui_data_table(items: @users, columns: columns) %>
```

**Block API** — links and actions:

```erb
<%= ui_data_table(items: @users, columns: [{ name: "Name" }, { email: "Email" }]) do |table| %>
  <% table.link(:name) { |user| user_path(user) } %>
  <% table.actions do |user| %>
    <%= link_to "Edit", edit_user_path(user) %>
  <% end %>
<% end %>
```

| Param | Required | Default |
|-------|----------|---------|
| `items:` | yes | — |
| `columns:` | yes | array of `{ key: "Label" }` hashes or `Column` objects |
| `empty_message:` | no | `nil` |

`Column.new(key, header_text, mobile_hidden: false)` — use `mobile_hidden: true` to hide a column on small screens.

### `ui_page`

```erb
<%= ui_page(max_width: :lg) do %>
  <!-- page content -->
<% end %>
```

| Param | Required | Default | Values |
|-------|----------|---------|--------|
| `max_width:` | no | `:full` | `:sm`, `:md`, `:lg`, `:xl`, `:full` |
| `padding:` | no | `:standard` | `:standard`, `:none` |

### `ui_section`

```erb
<%= ui_section(title: "Products", subtitle: "All active items") do %>
  <!-- section content -->
<% end %>
```

| Param | Required | Default | Values |
|-------|----------|---------|--------|
| `title:` | no | `nil` | — |
| `subtitle:` | no | `nil` | — |
| `action:` | no | `nil` | slot for a trailing action |
| `spacing:` | no | `:md` | `:sm`, `:md`, `:lg` |

### `ui_grid`

```erb
<%= ui_grid(cols: { default: 1, sm: 2, lg: 4 }, gap: :lg) do %>
  <!-- grid items -->
<% end %>
```

| Param | Required | Default | Values |
|-------|----------|---------|--------|
| `cols:` | no | `{ default: 1 }` | hash of breakpoint → column count (1-12). Keys: `:default`, `:sm`, `:md`, `:lg` |
| `gap:` | no | `:md` | `:sm`, `:md`, `:lg`, `:xl` |
| `gap_x:` | no | `nil` | overrides `gap:` horizontally |
| `gap_y:` | no | `nil` | overrides `gap:` vertically |

### `ui_panel`

```erb
<%= ui_panel(padding: :lg) do %>
  <!-- panel content -->
<% end %>
```

| Param | Required | Default | Values |
|-------|----------|---------|--------|
| `padding:` | no | `:md` | `:sm`, `:md`, `:lg` |
| `radius:` | no | `:lg` | `:md`, `:lg`, `:xl` |
| `shadow:` | no | `true` | `true`, `false` |

### `ui_card_link`

```erb
<%= ui_card_link(href: product_path(@product)) do %>
  <h3>Product name</h3>
<% end %>
```

| Param | Required | Default | Values |
|-------|----------|---------|--------|
| `href:` | yes | — | — |
| `padding:` | no | `:md` | `:sm`, `:md`, `:lg` |
| `shadow:` | no | `true` | `true`, `false` |

### `ui_page_header`

```erb
<%= ui_page_header(title: "Products", subtitle: "Manage your catalog") do |header| %>
  <% header.action do %>
    <%= ui_button(label: "New Product", href: new_product_path) %>
  <% end %>
<% end %>
```

| Param | Required | Default |
|-------|----------|---------|
| `title:` | yes | — |
| `subtitle:` | no | `nil` |
| `action_url:` | no | `nil` | shortcut: renders a default link button |
| `action_label:` | no | `"Add new"` | label for `action_url` button |

Block API: call `header.action { ... }` to add a custom action slot (e.g. a button) aligned to the right.

### `ui_alert`

```erb
<%= ui_alert(message: "Changes saved.", type: :success) %>
<%= ui_alert(message: "Could not save.", type: :error, title: "Error", dismissible: true) %>
```

| Param | Required | Default | Values |
|-------|----------|---------|--------|
| `message:` | yes | — | — |
| `type:` | no | `:info` | `:info`, `:success`, `:warning`, `:error` |
| `title:` | no | `nil` | bold title above message |
| `dismissible:` | no | `false` | shows dismiss button when `true` |

### `ui_input`

```erb
<%= ui_input(name: "email", type: :email, placeholder: "you@example.com") %>
```

| Param | Required | Default | Values |
|-------|----------|---------|--------|
| `name:` | yes | — | — |
| `type:` | no | `:text` | `:text`, `:email`, `:password`, `:number`, etc. |
| `value:` | no | `nil` | — |
| `placeholder:` | no | `nil` | — |
| `disabled:` | no | `false` | — |
| `min:` | no | `nil` | min value for number inputs |
| `max:` | no | `nil` | max value for number inputs |
| `step:` | no | `nil` | step value for number inputs |

### `ui_textarea`

```erb
<%= ui_textarea(name: "description", rows: 5, placeholder: "Enter details…") %>
```

| Param | Required | Default |
|-------|----------|---------|
| `name:` | yes | — |
| `value:` | no | `nil` |
| `rows:` | no | `3` |
| `placeholder:` | no | `nil` |
| `disabled:` | no | `false` |

### `ui_form_field`

```erb
<%= ui_form_field(attribute: :email, label: "Email address", type: :email, required: true) %>
```

| Param | Required | Default | Values |
|-------|----------|---------|--------|
| `attribute:` | yes | — | — |
| `label:` | no | `nil` | auto-derived from attribute if omitted |
| `type:` | no | `:text` | `:text`, `:email`, `:password`, `:number`, etc. |
| `required:` | no | `false` | — |
| `hint:` | no | `nil` | help text below the field |
| `placeholder:` | no | `nil` | — |
| `min:` | no | `nil` | — |
| `max:` | no | `nil` | — |

### `ui_form`

Wraps content in a `<form>` tag with proper method handling. For non-GET/POST methods, renders a hidden `_method` input (Rails convention). Supports multipart for file uploads.

```erb
<%= ui_form(action: items_path) do %>
  <%= ui_form_field(attribute: :name, required: true) %>
  <%= ui_button(label: "Save", type: :submit) %>
<% end %>

<%= ui_form(action: item_path(@item), method: :patch, multipart: true) do %>
  <%= ui_form_field(attribute: :name) %>
  <%= ui_file_upload(name: "item[photo]", accept: "image/*") %>
  <%= ui_button(label: "Save", type: :submit) %>
<% end %>
```

| Param | Required | Default | Values |
|-------|----------|---------|--------|
| `action:` | yes | — | — |
| `method:` | no | `:post` | `:get`, `:post`, `:patch`, `:put`, `:delete` |
| `multipart:` | no | `false` | `true` for file uploads |
| `data:` | no | `nil` | hash of data attributes |

### `ui_file_upload`

Styled file upload with drop zone, label, and optional hint.

```erb
<%= ui_file_upload(name: "avatar", accept: "image/*", hint: "PNG or JPG, max 5MB") %>
<%= ui_file_upload(name: "documents[]", multiple: true, label: "Upload documents") %>
```

| Param | Required | Default |
|-------|----------|---------|
| `name:` | yes | — |
| `label:` | no | `"Choose file"` |
| `accept:` | no | `nil` | accepted file types (e.g. `"image/*"`, `".pdf,.doc"`) |
| `multiple:` | no | `false` | allow multiple files |
| `hint:` | no | `nil` | help text below drop zone |

### `ui_form_page`

Wraps a form page with title and back navigation. Sets `content_for` signals so the navbar can render mobile header context.

```erb
<%= ui_form_page(title: "New Product", back_url: products_path) %>
```

| Param | Required | Default |
|-------|----------|---------|
| `title:` | yes | — |
| `back_url:` | yes | — |
| `subtitle:` | no | `nil` |

### `ui_show_page`

Wraps a show/detail page with title and back navigation. Sets `content_for` signals so the navbar can render mobile header context.

```erb
<%= ui_show_page(title: @product.name, back_url: products_path, subtitle: "Details") %>
```

| Param | Required | Default |
|-------|----------|---------|
| `title:` | yes | — |
| `back_url:` | yes | — |
| `subtitle:` | no | `nil` |

### `ui_navbar`

Top-level navigation bar with slots for desktop and mobile sections. Sticky by default.

```erb
<%= ui_navbar do |nav| %>
  <% nav.with_logo do %>
    <%= link_to "MyApp", root_path %>
  <% end %>
  <% nav.with_desktop_links do %>
    <%= ui_nav_item(label: "Dashboard", href: root_path, active: true) %>
    <%= ui_nav_dropdown(title: "Settings", area: "settings") do %>
      <%= link_to "Profile", profile_path %>
    <% end %>
  <% end %>
  <% nav.with_desktop_right do %>
    <%= ui_settings_link(label: "Settings", href: settings_path) %>
  <% end %>
  <% nav.with_mobile_center do %>
    <span>MyApp</span>
  <% end %>
<% end %>
```

| Param | Required | Default |
|-------|----------|---------|
| `sticky:` | no | `true` |

Slots: `logo`, `desktop_links`, `desktop_right`, `mobile_left`, `mobile_center`, `mobile_right`.

### `ui_nav_item`

A single nav link, used inside `ui_navbar` desktop_links slot.

```erb
<%= ui_nav_item(label: "Dashboard", href: "/", active: current_page?(root_path)) %>
```

| Param | Required | Default |
|-------|----------|---------|
| `label:` | yes | — |
| `href:` | yes | — |
| `active:` | no | `false` |

### `ui_nav_dropdown`

Dropdown menu within the navbar. Uses Stimulus `dropdown` controller.

```erb
<%= ui_nav_dropdown(title: "More", area: "admin", active: false) do %>
  <%= link_to "Users", users_path %>
  <%= link_to "Reports", reports_path %>
<% end %>
```

| Param | Required | Default |
|-------|----------|---------|
| `title:` | yes | — |
| `area:` | yes | — |
| `active:` | no | `false` |

### `ui_bottom_nav`

Mobile bottom tab bar, hidden on desktop (`lg:hidden`). Wrap `ui_bottom_nav_item` calls inside.

```erb
<%= ui_bottom_nav do %>
  <%= ui_bottom_nav_item(label: "Home", href: "/", icon: "<svg>…</svg>", active: true) %>
  <%= ui_bottom_nav_item(label: "Search", href: "/search", icon: "<svg>…</svg>") %>
<% end %>
```

No params.

### `ui_bottom_nav_item`

A single bottom nav tab.

```erb
<%= ui_bottom_nav_item(label: "Home", href: "/", icon: "<svg>…</svg>", active: true) %>
```

| Param | Required | Default |
|-------|----------|---------|
| `label:` | yes | — |
| `href:` | yes | — |
| `icon:` | yes | raw SVG string |
| `active:` | no | `false` |

### `ui_mobile_header`

Mobile header with back link, centered title, and optional subtitle. Hidden on `lg:` screens.

```erb
<%= ui_mobile_header(title: "Edit Product", back_url: products_path) %>
```

| Param | Required | Default |
|-------|----------|---------|
| `title:` | yes | — |
| `back_url:` | yes | — |
| `subtitle:` | no | `nil` |

### `ui_mobile_actions`

Ellipsis dropdown for mobile action menus. Hidden on `lg:` screens.

```erb
<%= ui_mobile_actions do %>
  <%= link_to "Edit", edit_product_path(@product) %>
  <%= link_to "Delete", product_path(@product), data: { turbo_method: :delete } %>
<% end %>
```

No params. Pass action links as block content.

### `ui_settings_link`

Gear icon link for settings navigation.

```erb
<%= ui_settings_link(label: "Settings", href: settings_path) %>
```

| Param | Required | Default |
|-------|----------|---------|
| `label:` | yes | — |
| `href:` | yes | — |

### `ui_select`

Styled `<select>` dropdown.

```erb
<%= ui_select(name: "status", options: [["Active", "active"], ["Inactive", "inactive"]], selected: "active", include_blank: "Select…") %>
```

| Param | Required | Default |
|-------|----------|---------|
| `name:` | yes | — |
| `options:` | no | `[]` | array of `[label, value]` pairs |
| `selected:` | no | `nil` |
| `include_blank:` | no | `nil` |
| `disabled:` | no | `false` |

### `ui_badge`

Inline status badge.

```erb
<%= ui_badge(label: "Active", variant: :success) %>
```

| Param | Required | Default | Values |
|-------|----------|---------|--------|
| `label:` | yes | — | — |
| `variant:` | no | `:neutral` | `:neutral`, `:success`, `:danger`, `:warning`, `:info` |

### `ui_stat_card`

Metric card for dashboards.

```erb
<%= ui_stat_card(label: "Revenue", value: "$42,300", variant: :success, suffix: "/mo") %>
```

| Param | Required | Default | Values |
|-------|----------|---------|--------|
| `label:` | yes | — | — |
| `value:` | yes | — | — |
| `variant:` | no | `:neutral` | `:neutral`, `:success`, `:danger`, `:warning`, `:info` |
| `suffix:` | no | `nil` | unit label after value |

### `ui_chart_card`

Card wrapper for chart content with title and configurable height.

```erb
<%= ui_chart_card(title: "Monthly Revenue", height: :lg) do %>
  <!-- chart content -->
<% end %>
```

| Param | Required | Default | Values |
|-------|----------|---------|--------|
| `title:` | yes | — | — |
| `height:` | no | `:md` | `:sm` (h-48), `:md` (h-64), `:lg` (h-96) |

### `ui_copy_button`

Button that copies text to clipboard.

```erb
<%= ui_copy_button(text: "https://example.com/invite/abc123") %>
```

| Param | Required | Default |
|-------|----------|---------|
| `text:` | yes | — |
| `label:` | no | `"Copy"` |
| `success_message:` | no | `"Copied!"` |
| `error_message:` | no | `"Failed!"` |

### `ui_modal`

Modal dialog with title, close button, and backdrop.

```erb
<%= ui_modal(title: "Confirm Delete", size: :sm) do %>
  <p>This action cannot be undone.</p>
<% end %>
```

| Param | Required | Default | Values |
|-------|----------|---------|--------|
| `title:` | yes | — | — |
| `size:` | no | `:md` | `:sm`, `:md`, `:lg`, `:xl` |

### `ui_accordion`

Collapsible question/answer items.

```erb
<%= ui_accordion(items: [{ question: "What?", answer: "A UI library." }]) %>
```

| Param | Required | Default |
|-------|----------|---------|
| `items:` | no | `[]` | array of hashes with `:question` and `:answer` keys |

### `ui_tab_switcher`

Tab bar with active state. Uses Stimulus `tab-switcher` controller.

```erb
<%= ui_tab_switcher(tabs: ["Overview", "Details"]) do %>
  <!-- tab panel content -->
<% end %>
```

| Param | Required | Default |
|-------|----------|---------|
| `tabs:` | yes | — | array of tab label strings |

### `ui_option_card`

Toggleable card option (radio-like selection).

```erb
<%= ui_option_card(name: "theme", value: "dark", selected: true) do %>
  Dark Mode
<% end %>
```

| Param | Required | Default |
|-------|----------|---------|
| `name:` | yes | — |
| `value:` | yes | — |
| `selected:` | no | `false` |
| `input_data:` | no | `{}` | data attributes for hidden input |
| `label_data:` | no | `{}` | data attributes for label |

### `ui_hero`

Large hero section for landing pages.

```erb
<%= ui_hero(title: "Build faster", subtitle: "UI components for Rails", badge: "New") do |hero| %>
  <% hero.with_aside do %>
    <!-- image -->
  <% end %>
<% end %>
```

| Param | Required | Default | Values |
|-------|----------|---------|--------|
| `title:` | yes | — | — |
| `subtitle:` | no | `nil` | — |
| `badge:` | no | `nil` | small badge text above title |
| `layout:` | no | `:split` | `:split`, `:centered` |

Slot: `aside` — content beside the hero text (split layout).

### `ui_feature_grid`

Grid of feature cards with icons.

```erb
<%= ui_feature_grid(title: "Why Keystone?", features: [
  { icon: "🚀", title: "Fast", description: "No build step." }
]) %>
```

| Param | Required | Default |
|-------|----------|---------|
| `title:` | yes | — |
| `features:` | yes | — | array of hashes with `:icon`, `:title`, `:description` |
| `subtitle:` | no | `nil` |

### `ui_cta_banner`

Call-to-action banner with title, subtitle, and action buttons.

```erb
<%= ui_cta_banner(title: "Ready?", subtitle: "Try Keystone today.") do %>
  <%= ui_button(label: "Get Started", href: signup_path) %>
<% end %>
```

| Param | Required | Default |
|-------|----------|---------|
| `title:` | yes | — |
| `subtitle:` | no | `nil` |

### `ui_color_picker`

HSV color picker with swatch preview. Uses Stimulus `color-picker` controller.

```erb
<%= ui_color_picker(name: "accent_color", value: "#3b82f6", label: "Accent") %>
```

| Param | Required | Default |
|-------|----------|---------|
| `name:` | yes | — |
| `value:` | no | `"#000000"` |
| `label:` | no | `nil` |

### `ui_swipe_deck`

Stacked card deck with touch/click swipe gestures. Emits `swipe-deck:complete`
and `swipe-deck:skip` custom DOM events so the host app handles the action.

```erb
<%= ui_swipe_deck(items: @goals, empty_title: "All done!", empty_subtitle: "No more items.") do |goal| %>
  <p class="text-2xl font-bold"><%= goal.name %></p>
  <% if goal.has_value? %>
    <input type="number" data-swipe-deck-value placeholder="Value">
  <% end %>
<% end %>
```

| Param | Required | Default |
|-------|----------|---------|
| `items:` | yes | — |
| `empty_title:` | no | `"All done!"` |
| `empty_subtitle:` | no | `nil` |

Block yields each item. Cards support an optional `<input data-swipe-deck-value>` whose value is included in the `complete` event detail.

**Events dispatched:**
- `swipe-deck:complete` — `{ detail: { itemId, value, card } }`
- `swipe-deck:skip` — `{ detail: { itemId, card } }`
