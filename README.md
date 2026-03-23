# Avo Skills

Claude Code skills for the Avo ecosystem — build, upgrade, and enhance Avo-powered admin panels faster.

## Available skills

| Skill            | Command           | Description                                                             |
| ---------------- | ----------------- | ----------------------------------------------------------------------- |
| `avo-menu-icons` | `/avo-menu-icons` | Auto-populate Avo menu items with semantically appropriate Tabler icons |

## Installation

```bash
npx skills add avo-hq/skills
```

To install a specific skill:

```bash
npx skills add avo-hq/skills/avo-menu-icons
```

## Structure

```
skills/
└── avo-menu-icons/
    ├── SKILL.md
    └── scripts/
        └── fetch_icons.rb
```

Each skill lives in `skills/{slug}/SKILL.md`. Scripts needed by the skill go in `skills/{slug}/scripts/`.

## Contributing

Add a new skill by creating a `skills/{slug}/` directory with a `SKILL.md` file.
