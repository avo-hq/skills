---
name: avo-menu-icons
description: Add icons to Avo menu items in config/initializers/avo.rb. Use when the user wants to populate icons for sidebar sections, groups, resources, links, and dashboards. Especially useful when migrating from Avo 3 to Avo 4.
allowed-tools: Read, Edit, Glob
---

# Add Icons to Avo Menu Items

!`ruby ${CLAUDE_PLUGIN_ROOT}/scripts/fetch_icons.rb`

The two lines above list every available Tabler icon name, grouped by style. To use an icon, prefix the name with `tabler/outline/` or `tabler/filled/` — e.g. `icon: "tabler/outline/users"`. Only use names that appear in the lists above.

## Step 1: Read the Avo menu configuration

Find and read the Avo initializer — usually `config/initializers/avo.rb`. Locate the `config.main_menu` block and `config.profile_menu` if present.

## Step 2: Identify items without icons

For each DSL call inside the menu blocks, check whether it already has an `icon:` argument:

- `section "Name", ...`
- `group "Name", ...`
- `resource :name, ...`
- `link "Name", path: ..., ...`
- `dashboard :name, ...`

Collect every call that is missing `icon:`.

## Step 3: Choose icons

For each item without an icon, find the best-matching name from the outline list above. Prefer outline icons; only use filled when it clearly fits better.

**Matching strategy — try in order:**

1. **Exact match** — the item name or a keyword from it appears verbatim in the list (e.g. `users` section → find `users`).
2. **Semantic match** — the concept maps to a well-known icon. Common hints:

   | Concept                    | Try these names                               |
   | -------------------------- | --------------------------------------------- |
   | Users / People / Members   | `users`, `user`, `user-circle`                |
   | Posts / Articles / Blog    | `article`, `news`, `writing`                  |
   | Orders / Purchases         | `shopping-cart`, `receipt`, `cash-register`   |
   | Products / Items / Catalog | `package`, `box`, `tag`                       |
   | Settings / Config          | `settings`, `adjustments`, `sliders`          |
   | Reports / Analytics        | `chart-bar`, `chart-line`, `report-analytics` |
   | Dashboard / Overview       | `layout-dashboard`, `dashboard`, `home`       |
   | Comments / Reviews         | `message`, `message-circle`, `star`           |
   | Teams / Organizations      | `users-group`, `building`, `hierarchy`        |
   | Roles / Permissions        | `shield-lock`, `lock`, `key`                  |
   | Media / Files / Uploads    | `photo`, `file`, `paperclip`                  |
   | Tags / Labels / Categories | `tag`, `tags`, `bookmark`                     |
   | Email / Notifications      | `mail`, `bell`, `send`                        |
   | Calendar / Events          | `calendar`, `calendar-event`, `clock`         |
   | Invoices / Billing         | `receipt`, `credit-card`, `currency-dollar`   |
   | Geography / Locations      | `map-pin`, `map`, `globe`                     |
   | Tools / Utilities          | `tool`, `tools`, `hammer`                     |
   | External links             | `external-link`, `link`                       |
   | Sign out / Logout          | `logout`, `door-exit`                         |
   | Profile / Account          | `user-circle`, `id-badge`                     |

3. **No match** — if nothing fits well, skip the item. Never force a generic placeholder.

Always verify the chosen name exists in the injected list before using it.

## Step 4: Apply the changes

Edit the initializer, adding `icon: "tabler/outline/{name}"` (or `tabler/filled/{name}`) to each matched item:

- Preserve exact indentation, spacing, and all existing arguments.
- Place `icon:` naturally — before `collapsable:`/`collapsed:` on sections, otherwise appended.
- Do not touch anything outside the menu blocks.
- Leave existing `icon:` values unchanged.

## Step 5: Report

Tell the user:

- Total icons added
- For each item that got an icon: menu item name → icon chosen, with a one-word reason
- Any items skipped because no good match was found
