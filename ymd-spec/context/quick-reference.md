# YMD/PMD Quick Reference

## YMD Structure

```yaml
meta:
  id: unique_id
  kind: type
  version: 1.0.0
  title: Title

section_name: |
  {{ variable }}
  {% include "file.pmd" %}
```

## PMD Structure

```markdown
{{ variable }}
{% include "other.pmd" %}
```

---

## YMD Sections

### Standard (Optional)
- `system` - Role/persona
- `instructions` - Tasks
- `expected_output` - Format
- `developer` - Notes
- `user` - Input

### Custom (Any YAML key)
- `context` - Context info
- `constraints` - Limitations
- `examples` - Samples
- `validation_rules` - Rules

---

## Jinja2 Syntax

### Variables
```jinja2
{{ variable_name }}
{{ user.name }}
{{ items[0] }}
```

### Includes
```jinja2
{% include "path/file.pmd" %}
{% include "../shared/common.pmd" %}
```

### Control Flow
```jinja2
{% if condition %}
  content
{% elif other %}
  other content
{% else %}
  default
{% endif %}

{% for item in items %}
  - {{ item }}
{% endfor %}
```

### Comments
```jinja2
{# This won't appear in output #}
```

---

## Path Resolution

**Relative to current file**:
- `./file.pmd` - Same directory
- `../file.pmd` - Parent directory
- `folder/file.pmd` - Subdirectory
- `../../shared/file.pmd` - Two levels up

---

## Composition Patterns

### YMD → PMD
```yaml
system: |
  {% include "roles/expert.pmd" %}
```

### PMD → PMD
```markdown
{% include "../shared/principles.pmd" %}
```

### YMD → PMD → PMD
```
main.ymd
  └─ roles/senior.pmd
      └─ shared/principles.pmd
```

---

## Best Practices

### YMD
- ✅ Use `meta:` for metadata
- ✅ Keep thin (mostly includes)
- ✅ Custom sections OK
- ❌ No large content blocks

### PMD
- ✅ No `meta:` section
- ✅ Pure Markdown + Jinja2
- ✅ Single responsibility
- ❌ No YAML metadata

### Composition
- ✅ Max depth ~5 levels
- ✅ Document variables
- ✅ Test include chains
- ❌ No circular includes

---

## Validation Checklist

### YMD
- [ ] Has `meta:`  section
- [ ] Has id, kind, version, title
- [ ] Version is semver
- [ ] All includes exist
- [ ] No circular deps

### PMD
- [ ] No `meta:` section
- [ ] Valid Markdown
- [ ] Valid Jinja2
- [ ] Includes exist

---

## Common Errors

### Missing Include
```
Error: File not found: roles/expert.pmd
```
**Fix**: Check path relative to current file

### Circular Include
```
Error: Circular: a.pmd → b.pmd → a.pmd
```
**Fix**: Remove circular dependency

### Undefined Variable
```
Error: Undefined variable 'domain'
```
**Fix**: Define in YMD or context

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

## Quick Examples

### Minimal YMD
```yaml
meta:
  id: simple
  kind: task
  version: 1.0.0
  title: Simple

user: |
  {{ input }}
```

### Leaf PMD
```markdown
You are an expert in {{ domain }}.
```

### Composite PMD
```markdown
{% include "base.pmd" %}
{% include "extensions.pmd" %}
```

---

## Related Docs

- Full Spec: `../ymd_format_spec.md`, `../pmd_format_spec.md`
- Guidelines: `./format-guidelines.md`
- Examples: `./examples.md`
- Cheatsheet: `../cheatsheet/ymd_pmd_cheatsheet.md`
