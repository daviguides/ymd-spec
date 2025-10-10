---
layout: page
title: Cheatsheet
nav_order: 6
---

# YMD/PMD Cheatsheet

Quick reference for YMD/PMD syntax and patterns.

---

## Format Overview

| Format | Purpose | Contains | Extension |
|--------|---------|----------|-----------|
| **YMD** | Orchestrator | `meta:` + sections | `.ymd` |
| **PMD** | Component | Markdown + Jinja2 | `.pmd` |

---

## YMD Structure

```yaml
{% raw %}meta:                    # Required (grouped!)
  id: unique_id
  kind: category
  version: X.Y.Z
  title: Title

section_name: |         # Any YAML key
  {{ variables }}
  {% include "file.pmd" %}{% endraw %}
```

### Metadata Fields

```yaml
meta:
  id: snake_case_identifier
  kind: review | task | api_design | documentation | ...
  version: 1.0.0              # Semantic versioning
  title: Human Readable Title
```

### Standard Sections (Optional)

- `system` - Role/persona
- `instructions` - Tasks
- `expected_output` - Output format
- `developer` - Notes
- `user` - User input

### Custom Sections (Any YAML Key!)

- `context`, `constraints`, `examples`, `validation_rules`
- `api_principles`, `review_focus`, `test_categories`
- Any domain-specific name

---

## PMD Structure

```markdown
{% raw %}{# Optional comment with variable documentation #}

Markdown content with **formatting**.

{{ variables }}
{% include "other.pmd" %}{% endraw %}
```

**Key**: NO `meta:` section!

---

## Jinja2 Quick Reference

### Variables
```jinja2
{% raw %}{{ variable_name }}
{{ user.field }}
{{ items[0] }}{% endraw %}
```

### Includes
```jinja2
{% raw %}{% include "path/file.pmd" %}
{% include "../shared/common.pmd" %}
{% include "{{ dynamic }}.pmd" %}{% endraw %}
```

### Control Flow
```jinja2
{% raw %}{% if condition %}
  content
{% elif other %}
  other
{% else %}
  default
{% endif %}

{% for item in items %}
  - {{ item }}
{% endfor %}{% endraw %}
```

### Comments
```jinja2
{% raw %}{# This won't appear in output #}{% endraw %}
```

---

## Path Resolution

**Rule**: Relative to current file

```
project/
├── prompts/main.ymd
└── components/
    └── roles/expert.pmd

# In main.ymd:
{% raw %}{% include "../components/roles/expert.pmd" %}{% endraw %}
```

---

## Composition Patterns

### Simple
```
YMD → PMD
```

### Hierarchical
```
YMD → PMD → PMD → PMD
```

### Conditional
```yaml
{% raw %}{% if condition %}
{% include "path_a.pmd" %}
{% else %}
{% include "path_b.pmd" %}
{% endif %}{% endraw %}
```

---

## Quick Templates

### Minimal YMD
```yaml
{% raw %}meta:
  id: minimal
  kind: task
  version: 1.0.0
  title: Minimal

user: |
  {{ task }}{% endraw %}
```

### Standard YMD
```yaml
{% raw %}meta:
  id: standard
  kind: task
  version: 1.0.0
  title: Standard

system: |
  {% include "roles/expert.pmd" %}

instructions: |
  {{ instructions }}

user: |
  {{ task }}{% endraw %}
```

### Leaf PMD
```markdown
{% raw %}You are an expert in {{ domain }}.

Your expertise:
- {{ skill_1 }}
- {{ skill_2 }}{% endraw %}
```

### Composite PMD
```markdown
{% raw %}{% include "../roles/base.pmd" %}
{% include "../shared/principles.pmd" %}{% endraw %}
```

---

## Validation Checklist

### YMD
- [ ] Has `meta:` section (grouped)
- [ ] Has id, kind, version, title
- [ ] Version is semver
- [ ] At least one section
- [ ] All includes exist
- [ ] No circular dependencies

### PMD
- [ ] NO `meta:` section
- [ ] Pure Markdown + Jinja2
- [ ] Valid syntax
- [ ] All includes exist
- [ ] Variables documented

---

## Common Errors & Fixes

### Error: Flat Metadata
```yaml
# ❌ WRONG
id: example
kind: task

# ✅ CORRECT
meta:
  id: example
  kind: task
```

### Error: PMD with Metadata
```markdown
<!-- ❌ WRONG -->
meta:
  id: component

<!-- ✅ CORRECT -->
No metadata in PMD!
```

### Error: Circular Include
```
# ❌ WRONG
a.pmd → b.pmd → a.pmd

# ✅ FIX
Extract common to shared.pmd
```

### Error: Missing Pipe
```yaml
# ❌ WRONG
user:
  {% raw %}{{ task }}{% endraw %}

# ✅ CORRECT
user: |
  {% raw %}{{ task }}{% endraw %}
```

---

## File Organization

```
project/
├── prompts/           # YMD files
│   └── *.ymd
└── components/        # PMD files
    ├── roles/
    ├── checklists/
    ├── formats/
    └── shared/
```

---

## Naming Conventions

### Files
- YMD: `code_review_assistant.ymd`
- PMD: `senior_developer_role.pmd`
- Use: `snake_case`

### Identifiers
- IDs: `snake_case`
- Sections: `snake_case`
- Variables: `snake_case`

### Folders
- Plural: `roles/`, `checklists/`
- Lowercase

---

## Composition Depth

| Depth | Status |
|-------|--------|
| 1-3 | ✅ Good |
| 4-5 | ✅ OK |
| 6+ | ⚠️ Refactor |

---

## Variables

### Define in YMD
```yaml
{% raw %}{# Expected variables:
   - domain: string
   - task: string
#}{% endraw %}
```

### Use in PMD
```markdown
{% raw %}Expert in {{ domain }}.{% endraw %}
```

### Flow Down
```
YMD defines: domain, language
  └─ PMD uses: domain, language
      └─ PMD uses: domain
```

---

## Commands Reference

```bash
# Load context
/load-ymd-context

# Create files
/create-ymd-manifest
/create-pmd-partial

# Validate
/validate-composition path/to/file.ymd
```

---

## Agents Reference

```bash
# Interactive authoring
@ymd-author

# Structure optimization
@composition-expert

# Validation & debugging
@ymd-validator
```

---

## Quick Decision Tree

```
Need metadata?
├─ YES → YMD
└─ NO → PMD

Reusable component?
├─ YES → PMD
└─ NO → Inline in YMD

Need custom sections?
└─ YES → Any YAML key works!

PMD includes other PMDs?
└─ YES → PMDs can include PMDs!
```

---

## Best Practices Summary

### YMD
- ✅ Group metadata under `meta:`
- ✅ Keep thin (mostly includes)
- ✅ Use custom sections freely
- ✅ Document variables

### PMD
- ✅ NO `meta:` section
- ✅ Single responsibility
- ✅ Descriptive filename
- ✅ Document variables

### Composition
- ✅ Use relative paths
- ✅ Keep depth ≤5 levels
- ✅ No circular dependencies
- ✅ Test include chains

---

## Example Use Cases

### Code Review
```yaml
{% raw %}system: |
  {% include "roles/senior_dev.pmd" %}

review_focus: |
  {% include "checklists/quality.pmd" %}
  {% include "checklists/security.pmd" %}{% endraw %}
```

### API Design
```yaml
{% raw %}system: |
  {% include "roles/api_architect.pmd" %}

api_principles: |
  {% include "principles/rest.pmd" %}{% endraw %}
```

### Documentation
```yaml
{% raw %}system: |
  {% include "roles/tech_writer.pmd" %}

style_guide: |
  {% include "styles/docs_style.pmd" %}{% endraw %}
```

---

## More Info

- **Full Specs**: [Format Specifications]({% link _pages/specifications.md %})
- **Get Started**: [Quick Start]({% link _pages/quick-start.md %})
- **Learn Patterns**: [Examples]({% link _pages/examples.md %})
- **Guidelines**: [Best Practices]({% link _pages/best-practices.md %})
- **Local Docs**: `~/.claude/ymd-spec/`

---

## Print This Page!

This cheatsheet is designed to be printed and kept handy while authoring YMD/PMD files.

**Pro tip**: Also check `~/.claude/ymd-spec/cheatsheet/ymd_pmd_cheatsheet.md` for a more detailed version.
