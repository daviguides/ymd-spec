# YMD/PMD Format Guidelines

**Purpose**: Consolidated formatting rules and syntax guidelines for YMD and PMD files.

**For specifications**: See @../spec/ymd_format.md and @../spec/pmd_format.md

---

## YAML Guidelines (YMD Only)

### Metadata Structure

**Required**: Metadata MUST be grouped under `meta:` key

✅ **Correct**:
```yaml
meta:
  id: example
  kind: task
  version: 1.0.0
  title: Example
```

❌ **Incorrect** (flat metadata):
```yaml
id: example
kind: task
version: 1.0.0
title: Example
```

### Section Syntax

All sections use block scalar (`|`) for multi-line content:

```yaml
section_name: |
  Content here
  More content
```

**Indentation**: 2 spaces consistently

---

## Markdown Guidelines

### Headings

- Use proper hierarchy: `#`, `##`, `###`
- No skipping levels (don't go from `#` to `###`)
- Keep headings descriptive and clear

### Lists

**Unordered lists**:
```markdown
- Item 1
- Item 2
  - Nested item
```

**Ordered lists**:
```markdown
1. First
2. Second
3. Third
```

**Checklists** (in PMD):
```markdown
- [ ] Unchecked item
- [x] Checked item
```

### Code Blocks

Use triple backticks with language:
```markdown
```python
def example():
    pass
`` `
```

**Within YAML sections**, indent properly:
```yaml
instructions: |
  Here's an example:

  ```python
  def example():
      pass
  ```
```

---

## Jinja2 Guidelines

### Variables

**Syntax**: `{{ variable_name }}`

**Naming**: snake_case, descriptive

```markdown
{{ project_type }}
{{ primary_language }}
{{ user_input }}
```

### Includes

**Syntax**: `{% include "path/file.pmd" %}`

**Requirements**:
- Use quotes around path
- Path is relative to current file
- File extension included

```markdown
{% include "roles/expert.pmd" %}
{% include "../shared/common.pmd" %}
```

### Control Flow

**If statements**:
```markdown
{% if condition %}
  Content when true
{% elif other_condition %}
  Content for other case
{% else %}
  Default content
{% endif %}
```

**For loops**:
```markdown
{% for item in list %}
  - {{ item }}
{% endfor %}
```

**Must close**: All `{% ... %}` blocks must have matching `{% end... %}`

### Comments

**Jinja2 comments** (not rendered):
```markdown
{# This is a comment
   Can be multi-line
#}
```

**Documentation header** (recommended):
```markdown
{# File: roles/expert.pmd
   Purpose: Define expert persona
   Expected variables:
   - domain: string - Area of expertise
   - experience_years: int - Years of experience
#}
```

---

## YMD-Specific Guidelines

### Metadata Requirements

All four fields required under `meta:`:

```yaml
meta:
  id: descriptive_name          # snake_case, unique
  kind: category                 # e.g., review, task, api_design
  version: X.Y.Z                 # Semantic versioning
  title: Human Readable Title    # Clear description
```

### Section Names

- **Standard sections**: `system`, `instructions`, `expected_output`, `developer`, `user`
- **Custom sections**: Any valid YAML key works
- Use descriptive names (e.g., `review_focus`, `api_principles`)

### Variable Documentation

Include documentation header:
```yaml
{# Expected variables:
   - variable_1: type - description
   - variable_2: type - description
#}

meta:
  ...
```

---

## PMD-Specific Guidelines

### NO Metadata

**Critical**: PMD files must NOT have `meta:` section or any YAML metadata

✅ **Correct PMD**:
```markdown
{# Role: Senior Developer #}

You are a **senior developer** with {{ years }} years of experience.
```

❌ **Incorrect PMD** (has metadata):
```markdown
meta:
  id: senior_dev  # ← WRONG! PMDs don't have metadata

You are a senior developer.
```

### Single Responsibility

Each PMD should have one clear purpose:
- ✅ `roles/senior_developer.pmd` - One role
- ✅ `checklists/security_review.pmd` - One checklist
- ❌ `roles/senior_dev_with_checklist.pmd` - Mixed responsibilities

### Include Paths

For composite PMDs:
```markdown
{# Composite role combining aspects #}

{% include "base_role.pmd" %}          # Same directory
{% include "../shared/principles.pmd" %} # Parent directory
{% include "sub/specific.pmd" %}        # Subdirectory
```

---

## Common Syntax Errors

### Error 1: Flat Metadata in YMD

❌ **Wrong**:
```yaml
id: example
kind: task

system: |
  ...
```

✅ **Correct**:
```yaml
meta:
  id: example
  kind: task
  version: 1.0.0
  title: Example

system: |
  ...
```

### Error 2: Metadata in PMD

❌ **Wrong**:
```markdown
meta:
  id: my_role

You are an expert.
```

✅ **Correct**:
```markdown
{# Role: Expert #}

You are an expert.
```

### Error 3: Missing Block Scalar

❌ **Wrong**:
```yaml
instructions:
  Step 1
  Step 2
```

✅ **Correct**:
```yaml
instructions: |
  Step 1
  Step 2
```

### Error 4: Unclosed Jinja2 Blocks

❌ **Wrong**:
```markdown
{% if condition %}
  Content here
```

✅ **Correct**:
```markdown
{% if condition %}
  Content here
{% endif %}
```

### Error 5: Include Without Quotes

❌ **Wrong**:
```markdown
{% include roles/expert.pmd %}
```

✅ **Correct**:
```markdown
{% include "roles/expert.pmd" %}
```

---

## Validation Checklist

### For YMD Files

- [ ] Has `meta:` section (grouped, not flat)
- [ ] All 4 metadata fields present (id, kind, version, title)
- [ ] Sections use `|` for multi-line content
- [ ] Valid YAML syntax (check indentation)
- [ ] Valid Jinja2 syntax (all blocks closed)
- [ ] Variables documented in header comment
- [ ] Include paths use quotes and are relative

### For PMD Files

- [ ] NO `meta:` section
- [ ] NO YAML metadata of any kind
- [ ] Valid Markdown syntax
- [ ] Valid Jinja2 syntax (all blocks closed)
- [ ] Single clear responsibility
- [ ] Variables documented in header comment
- [ ] Include paths use quotes and are relative (if composite)

---

## Best Practices

### Naming Conventions

- **Files**: snake_case (e.g., `code_review_assistant.ymd`, `senior_developer.pmd`)
- **Variables**: snake_case (e.g., `{{ project_type }}`, `{{ user_input }}`)
- **IDs**: snake_case (e.g., `id: api_design_assistant`)

### Indentation

- **YAML**: 2 spaces
- **Markdown**: Standard (4 spaces for nested lists, etc.)
- **Consistency**: Use same indentation throughout

### Comments

- **Document purpose**: Add header comment explaining file purpose
- **Document variables**: List all expected variables with types
- **Explain non-obvious**: Comment complex logic or conditions

### Organization

- **YMD**: Mostly includes, minimal inline content
- **PMD**: Focused content, one responsibility
- **Paths**: Relative, organized by category

---

## Quick Reference

**YMD Structure**:
```yaml
{# Documentation #}
meta: { id, kind, version, title }
section: | content
```

**PMD Structure**:
```markdown
{# Documentation #}
Markdown + {{ variables }} + {% includes %}
```

**Include Syntax**:
```markdown
{% include "path/file.pmd" %}
```

**Variable Syntax**:
```markdown
{{ variable_name }}
```

**Control Flow**:
```markdown
{% if condition %} ... {% endif %}
{% for item in list %} ... {% endfor %}
```
