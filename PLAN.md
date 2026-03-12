# Beautiful Photons — Implementation Plan

A mountable Rails engine for managing photo galleries with responsive focal-point cropping.

## Overview

**beautiful_photons** provides:
- Photo upload and management via ActiveStorage
- Named galleries (e.g. "homepage", "services", "portfolio")
- Category tagging within galleries
- Position/ordering within galleries
- Focal point cropping (desktop + mobile) via CSS `object-position`
- API for uploading and managing photos programmatically
- Admin UI built with Keystone UI components
- View helpers for rendering gallery images with correct focal points

## Architecture

### Models
- `BeautifulPhotons::Photo` — core model
  - ActiveStorage attachment (`:image`)
  - `title` (string)
  - `description` (text)
  - `focal_x`, `focal_y` (decimal, default 50.0) — desktop focal point as percentage
  - `mobile_focal_x`, `mobile_focal_y` (decimal, nullable) — mobile override, falls back to desktop
  - `published` (boolean, default false)
  - timestamps

- `BeautifulPhotons::Gallery` — named collections
  - `name` (string, unique) — machine name like "homepage_hero"
  - `title` (string) — display name
  - `description` (text, nullable)
  - timestamps

- `BeautifulPhotons::GalleryPhoto` — join table with ordering + category
  - `gallery_id` (references)
  - `photo_id` (references)
  - `position` (integer)
  - `category` (string, nullable) — e.g. "backsplashes", "bathrooms"
  - timestamps

### API Endpoints (mounted at `/beautiful_photons/api/v1`)
- `POST /photos` — upload a photo (multipart)
- `GET /photos` — list all photos
- `PATCH /photos/:id` — update title, description, focal points, published
- `DELETE /photos/:id` — remove a photo
- `GET /galleries` — list galleries
- `POST /galleries` — create a gallery
- `GET /galleries/:id/photos` — list photos in gallery (ordered)
- `POST /galleries/:id/photos` — add photo to gallery (with position, category)
- `PATCH /galleries/:id/photos/:photo_id` — update position, category
- `DELETE /galleries/:id/photos/:photo_id` — remove photo from gallery

### Admin UI (mounted at `/beautiful_photons/admin`)
- Photo library — grid of all uploaded photos
- Focal point editor — click/drag pin on photo, live preview at desktop + mobile aspect ratios
- Gallery manager — view/reorder photos in a gallery, assign categories
- Uses Keystone UI: `ui_page`, `ui_section`, `ui_panel`, `ui_data_table`, `ui_button`, `ui_form_field`, `ui_page_header`
- Custom components needed (candidates for Keystone UI):
  - Drag-to-reorder list/grid
  - Image focal point picker (interactive, Stimulus controller)

### View Helpers
```ruby
# Render a single photo with focal point styles
beautiful_photons_image(photo, class: "...", aspect: "4/3")

# Render all photos from a named gallery
beautiful_photons_gallery("homepage_hero") do |photo|
  # custom rendering per photo
end

# Get photos for a gallery (for manual rendering)
beautiful_photons_photos("homepage_hero", category: "backsplashes")
```

### Host App Integration
```ruby
# Gemfile
gem "beautiful_photons", github: "tylercschneider/beautiful_photons"

# config/routes.rb
mount BeautifulPhotons::Engine, at: "/beautiful_photons"

# config/initializers/beautiful_photons.rb
BeautifulPhotons.configure do |config|
  config.galleries = ["homepage", "services", "portfolio"]
  config.categories = ["backsplashes", "bathrooms", "floors", "specialty"]
  config.api_authentication = :devise  # or :token, :none
end
```

## Implementation Order (TDD, one test per commit)

### Phase 1: Foundation
1. Generate engine with `rails plugin new beautiful_photons --mountable`
2. Create GitHub repo, push skeleton
3. Photo model + migration + basic test
4. Gallery model + migration + basic test
5. GalleryPhoto join model + migration + test

### Phase 2: API
6. Photos API — create (upload) endpoint + test
7. Photos API — index/show endpoints + test
8. Photos API — update (focal points, metadata) + test
9. Photos API — delete + test
10. Galleries API — CRUD endpoints + tests
11. Gallery photos API — add/remove/reorder + tests

### Phase 3: View Helpers
12. `beautiful_photons_image` helper + test
13. `beautiful_photons_gallery` helper + test
14. `beautiful_photons_photos` query helper + test

### Phase 4: Admin UI
15. Photo library grid view
16. Focal point editor (Stimulus controller)
17. Gallery manager with drag-to-reorder
18. Photo upload form

### Phase 5: Integrate into SOTA
19. Add gem to SOTA, run migrations
20. Bulk upload existing photos via API
21. Update gallery/services views to use helpers
22. Replace hardcoded photo arrays with database queries

## CLI Upload Workflow

From local machine with Claude:
```
# Claude reads photos from folder, uploads via API
POST /beautiful_photons/api/v1/photos
  -> multipart upload with file

# User opens admin, uses swipe UI to categorize
# User sets focal points via drag UI
# Photos appear on public site
```

## Responsive Focal Point System

Each photo stores:
- `focal_x` / `focal_y` (0-100) — desktop focal point
- `mobile_focal_x` / `mobile_focal_y` (0-100, nullable) — mobile override

CSS output:
```css
/* Desktop */
.bp-image { object-fit: cover; object-position: 60% 30%; }

/* Mobile override via media query or data attribute */
@media (max-width: 768px) {
  .bp-image { object-position: 40% 20%; }
}
```

No server-side image processing needed — the browser handles cropping around the focal point.
