# YMD/PMD Format Quick Reference

**Purpose**: Condensed quick-reference for YMD and PMD formats.

**Full specifications**: @../ymd_format_spec.md and @../pmd_format_spec.md

---

## YMD Quick Reference

### Required Structure
```yaml
meta:
  id: unique_identifier          # snake_case
  kind: category                  # review, task, api_design, etc.
  version: X.Y.Z                  # Semantic versioning
  title: Human Readable Title     # Clear description

section_name: |                   # Any YAML key works
  Content with {{ variables }}
  {% include "component.pmd" %}
```

### Key Rules
- **Metadata MUST be under `meta:` key** (not flat)
- Sections use `|` for multi-line content
- Include paths in quotes: `{% include "path.pmd" %}`
- Variables: `{{ variable_name }}`

---

## PMD Quick Reference

### Structure
```markdown
{# Component description
   Expected variables:
   - var1: type - description
#}

Markdown content with **formatting**.

{{ variable_usage }}

{% include "other_component.pmd" %}
```

### Key Rules
- **NO `meta:` section** (critical!)
- Pure Markdown + Jinja2
- Single clear responsibility
- Variables in `{{ ... }}`

---

## Jinja2 Syntax Essentials

### Variables
```markdown
{{ variable_name }}
{{ project.field }}
```

### Includes
```markdown
{% include "path/file.pmd" %}
{% include "../parent/file.pmd" %}
```

### Conditionals
```markdown
{% if condition %}
  Content
{% elif other %}
  Other content
{% else %}
  Default
{% endif %}
```

### Loops
```markdown
{% for item in list %}
  - {{ item }}
{% endfor %}
```

### Comments
```markdown
{# This is a comment #}
```

---

## Common Patterns Cheatsheet

### Minimal YMD
```yaml
meta: [required fields]
user: | {{ task }}
```

### Standard YMD
```yaml
meta: [...]
system: | {% include "roles/..." %}
instructions: | {% include "tasks/..." %}
expected_output: | {% include "formats/..." %}
user: | {{ input }}
```

### Conditional
```yaml
system: |
  {% if mode == "expert" %}
  {% include "roles/expert.pmd" %}
  {% else %}
  {% include "roles/beginner.pmd" %}
  {% endif %}
```

### Parameterized
```yaml
language_specific: |
  {% include "languages/{{ language }}_guidelines.pmd" %}
```

---

## Decision Trees

### YMD or PMD?
- Complete prompt with metadata → YMD
- Reusable component → PMD

### Inline or Include?
- Short (<10 lines), unique → Inline
- Long (>10 lines) or reusable → Include

### Standard or Custom Sections?
- Fits naturally → Standard
- Domain-specific clarity → Custom

---

## Quick Validation

### YMD Checklist
- [ ] Has `meta:` section (grouped)
- [ ] All 4 fields (id, kind, version, title)
- [ ] Sections use `|`
- [ ] Valid YAML, Jinja2

### PMD Checklist
- [ ] NO metadata
- [ ] Pure Markdown + Jinja2
- [ ] Single responsibility
- [ ] Variables documented

---

## Error Quick Fixes

### "Flat metadata"
❌ `id: example` (flat)
✅ `meta:\n  id: example` (grouped)

### "PMD with metadata"
❌ PMD has `meta:` section
✅ Remove all YAML metadata

### "Unclosed block"
❌ `{% if ... %}` without `{% endif %}`
✅ Always close blocks

### "Include without quotes"
❌ `{% include file.pmd %}`
✅ `{% include "file.pmd" %}`

---

## Best Practices Summary

1. **YMD = Thin** - Mostly includes (>50%)
2. **PMD = Focused** - Single responsibility
3. **Depth ≤ 5** - Max 5 composition levels
4. **snake_case** - Files, variables, IDs
5. **Document variables** - Always
6. **Relative paths** - For includes
7. **No circles** - Avoid circular includes
