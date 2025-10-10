---
layout: page
title: Format Specifications
nav_order: 3
---

# Format Specifications

Complete reference for YMD and PMD formats.

---

## YMD Format

### Structure

```yaml
{% raw %}meta:                    # Required metadata (grouped)
  id: unique_id         # snake_case identifier
  kind: category        # prompt type
  version: X.Y.Z        # semantic versioning
  title: Title          # human-readable

section_name: |         # Any YAML key (customizable!)
  {{ variables }}       # Jinja2 variables
  {% include "file.pmd" %}  # Includes{% endraw %}
```

### Metadata Fields

#### `meta.id` (required)
- **Type**: string
- **Format**: snake_case
- **Purpose**: Unique identifier
- **Example**: `code_review_assistant`

#### `meta.kind` (required)
- **Type**: string
- **Purpose**: Category/type of prompt
- **Examples**: `review`, `task`, `api_design`, `documentation`

#### `meta.version` (required)
- **Type**: string
- **Format**: Semantic versioning (X.Y.Z)
- **Purpose**: Track changes
- **Example**: `1.0.0`

#### `meta.title` (required)
- **Type**: string
- **Purpose**: Human-readable description
- **Example**: `Code Review Assistant`

### Sections

Sections are **fully customizable** - not limited to standard names!

#### Standard Sections (Optional)
Commonly used but not required:

- `system` - Role/persona definition
- `instructions` - Step-by-step tasks
- `expected_output` - Output format specification
- `developer` - Implementation notes
- `user` - User input template

#### Custom Sections (Any YAML Key)
Use any descriptive name:

- `context` - Contextual information
- `constraints` - Limitations and rules
- `validation_rules` - Quality criteria
- `api_principles` - API design principles
- `review_focus` - Review priorities
- Any domain-specific name!

**Rule**: Use valid YAML key names (snake_case recommended).

### Jinja2 Features

#### Variables
```yaml
{% raw %}user: |
  Analyze {{ code }} for {{ language }}.{% endraw %}
```

#### Includes
```yaml
{% raw %}system: |
  {% include "roles/expert.pmd" %}{% endraw %}
```

#### Control Flow
```yaml
{% raw %}instructions: |
  {% if strict_mode %}
  Apply strict validation rules.
  {% else %}
  Apply relaxed rules.
  {% endif %}{% endraw %}
```

#### Loops
```yaml
{% raw %}examples: |
  {% for example in examples %}
  - {{ example }}
  {% endfor %}{% endraw %}
```

#### Comments
```yaml
{% raw %}{# This is a Jinja2 comment - won't appear in output #}{% endraw %}
```

---

## PMD Format

### Structure

```markdown
{% raw %}{# Optional documentation comment
   Expected variables:
   - var1: description
   - var2: description
#}

Markdown content with **formatting**.

{{ variables }}

{% include "other.pmd" %}{% endraw %}
```

### Key Rules

**PMD files must**:
- ❌ Have NO `meta:` section
- ✅ Be pure Markdown + Jinja2
- ✅ Have single, clear responsibility
- ✅ Document expected variables

### Component Types

#### Leaf PMD
Pure content, no includes:

```markdown
{% raw %}You are an expert in {{ domain }}.

Your expertise:
- {{ skill_1 }}
- {{ skill_2 }}{% endraw %}
```

#### Composite PMD
Aggregates other PMDs:

```markdown
{% raw %}{% include "../roles/senior_dev.pmd" %}
{% include "../shared/principles.pmd" %}{% endraw %}
```

### Common Categories

Organize PMDs by purpose:

- `roles/` - Persona definitions
- `checklists/` - Validation lists
- `formats/` - Output templates
- `shared/` - Common content
- `[domain]/` - Domain-specific (e.g., `languages/`, `frameworks/`)

---

## Composition Rules

### Include Resolution

**Rule**: Includes are relative to **current file**.

```
project/
├── prompts/main.ymd
└── components/
    ├── roles/expert.pmd
    └── shared/core.pmd

# In main.ymd:
{% raw %}{% include "../components/roles/expert.pmd" %}

# In roles/expert.pmd:
{% include "../shared/core.pmd" %}{% endraw %}
```

### Variable Propagation

Variables flow **down** through include chain:

```
YMD defines: domain, language
  └─ PMD A uses: domain, language
      └─ PMD A.1 uses: domain
  └─ PMD B uses: language
```

All included PMDs have access to variables from YMD.

### Composition Patterns

#### Simple (YMD → PMD)
```
main.ymd
  └─ includes component.pmd
```

#### Hierarchical (YMD → PMD → PMD)
```
main.ymd
  └─ includes profile.pmd
      └─ includes role.pmd
```

#### Multiple Includes
```
main.ymd
  ├─ includes role.pmd
  ├─ includes checklist1.pmd
  └─ includes checklist2.pmd
```

#### Conditional
```yaml
{% raw %}{% if condition %}
{% include "path_a.pmd" %}
{% else %}
{% include "path_b.pmd" %}
{% endif %}{% endraw %}
```

### Depth Recommendations

| Depth | Status |
|-------|--------|
| 1-3 levels | ✅ Good |
| 4-5 levels | ✅ Acceptable |
| 6+ levels | ⚠️ Consider refactoring |

---

## Validation Rules

### YMD Validation

Required checks:
- [ ] Has `meta:` section (grouped)
- [ ] Has id, kind, version, title
- [ ] Version follows semver
- [ ] At least one section beyond `meta:`
- [ ] Valid YAML syntax
- [ ] Valid Jinja2 syntax
- [ ] All includes exist
- [ ] No circular dependencies

### PMD Validation

Required checks:
- [ ] NO `meta:` section
- [ ] NO YAML metadata
- [ ] Pure Markdown + Jinja2
- [ ] Valid Markdown syntax
- [ ] Valid Jinja2 syntax
- [ ] All includes exist
- [ ] No circular dependencies

### Composition Validation

Required checks:
- [ ] All include paths are relative
- [ ] No circular dependencies
- [ ] Depth reasonable (≤5 levels)
- [ ] All variables defined or documented

---

## Naming Conventions

### Files
- **YMD**: `snake_case.ymd` (e.g., `code_review_assistant.ymd`)
- **PMD**: `snake_case.pmd` (e.g., `senior_developer_role.pmd`)

### Identifiers
- **IDs**: `snake_case` (e.g., `api_design_assistant`)
- **Sections**: `snake_case` (e.g., `review_focus`, `api_principles`)
- **Variables**: `snake_case` (e.g., `user_id`, `max_retries`)

### Folders
- **Plural**: `roles/`, `checklists/`, `formats/`
- **Lowercase**: all lowercase

---

## Best Practices

### YMD Best Practices

**DO**:
- ✅ Group metadata under `meta:`
- ✅ Use custom sections for clarity
- ✅ Keep thin (mostly includes)
- ✅ Document expected variables
- ✅ Follow semantic versioning

**DON'T**:
- ❌ Put large content inline (extract to PMD)
- ❌ Duplicate content across YMDs
- ❌ Hardcode values (use variables)
- ❌ Forget version updates

### PMD Best Practices

**DO**:
- ✅ Single responsibility
- ✅ Descriptive filename
- ✅ Document expected variables
- ✅ Organize by category
- ✅ Test independently

**DON'T**:
- ❌ Add YAML metadata
- ❌ Create circular includes
- ❌ Make giant monoliths
- ❌ Use absolute paths

### Composition Best Practices

**DO**:
- ✅ Document composition structure
- ✅ Keep depth reasonable (≤5 levels)
- ✅ Use relative paths
- ✅ Test include chains
- ✅ Validate no cycles

**DON'T**:
- ❌ Nest too deeply
- ❌ Create circular includes
- ❌ Over-engineer simple prompts

---

## Common Errors

### Error 1: Flat Metadata in YMD
```yaml
# ❌ WRONG
id: example
kind: task
version: 1.0.0

# ✅ CORRECT
meta:
  id: example
  kind: task
  version: 1.0.0
```

### Error 2: Metadata in PMD
```markdown
<!-- ❌ WRONG -->
meta:
  id: component

<!-- ✅ CORRECT - No metadata in PMD -->
Content here...
```

### Error 3: Circular Includes
```
# ❌ WRONG
a.pmd includes b.pmd
b.pmd includes c.pmd
c.pmd includes a.pmd  # Circular!

# ✅ CORRECT
Extract common content to shared.pmd
Both a.pmd and b.pmd include shared.pmd
```

### Error 4: Missing Pipe
```yaml
# ❌ WRONG
user:
  {{ task }}

# ✅ CORRECT
user: |
  {% raw %}{{ task }}{% endraw %}
```

---

## Reference Documents

Full specifications available at:

- **YMD Format**: `~/.claude/ymd-spec/ymd_format_spec.md`
- **PMD Format**: `~/.claude/ymd-spec/pmd_format_spec.md`
- **Composition**: `~/.claude/ymd-spec/composition_spec.md`
- **Guidelines**: `~/.claude/ymd-spec/context/format-guidelines.md`
- **Quick Reference**: `~/.claude/ymd-spec/context/quick-reference.md`
- **Cheatsheet**: `~/.claude/ymd-spec/cheatsheet/ymd_pmd_cheatsheet.md`
