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

## Contributing

Each plugin lives in `plugins/{slug}/`. Run `/create-skill` inside this repo to scaffold a new one.
