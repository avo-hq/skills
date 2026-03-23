# Avo Skills — Claude Code Plugin Marketplace

A plugin marketplace for the Avo ecosystem. Distributes Claude Code skills to help Avo developers build, upgrade, and enhance Avo-powered admin panels faster.

## Available plugins

| Plugin           | Command           | Description                                                             |
| ---------------- | ----------------- | ----------------------------------------------------------------------- |
| `avo-menu-icons` | `/avo-menu-icons` | Auto-populate Avo menu items with semantically appropriate Tabler icons |

## Installation

### Add the marketplace

```shell
/plugin marketplace add avo-hq/skills
```

### Install a plugin

```shell
/plugin install avo-menu-icons@avo-skills
```

### Install all plugins

```shell
/plugin install avo-menu-icons@avo-skills
```

### Auto-install for your team

Add to your project's `.claude/settings.json` so teammates are prompted automatically:

```json
{
  "extraKnownMarketplaces": {
    "avo-skills": {
      "source": {
        "source": "github",
        "repo": "avo-hq/skills"
      }
    }
  },
  "enabledPlugins": {
    "avo-menu-icons@avo-skills": true
  }
}
```

## Icon cache (avo-menu-icons)

The `avo-menu-icons` plugin fetches Tabler icon names from GitHub and caches them locally. A pre-built cache is included in the repository. To refresh it:

```bash
ruby skills/avo-menu-icons/scripts/fetch_icons.rb --force
# Optional: provide a GitHub token to avoid rate limits
ruby skills/avo-menu-icons/scripts/fetch_icons.rb --force --token ghp_yourtoken
```

## Repository structure

```
.claude-plugin/
  marketplace.json          ← marketplace catalog
skills/
  avo-menu-icons/
    SKILL.md                ← the skill prompt
    scripts/
      fetch_icons.rb        ← fetches Tabler icon names from GitHub
    icons-cache.json        ← pre-built icon cache
```

## Roadmap

| Plugin           | Status   | Description                                     |
| ---------------- | -------- | ----------------------------------------------- |
| `avo-menu-icons` | ✅ Ready | Add icons to all menu items (v3 → v4 migration) |

## Contributing

Each skill lives in `skills/{slug}/SKILL.md`. Run `/create-skill` inside this repo to scaffold a new one.
