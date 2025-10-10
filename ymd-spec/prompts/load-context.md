# Load YMD/PMD Context Prompt

**Purpose**: Load YMD/PMD format knowledge into LLM context for authoring session.

**Context**: This prompt is used to prepare LLMs to work with YMD/PMD formats by loading essential specifications and guidelines.

---

## Your New Context

You now have access to the **YMD/PMD format specification** - a system for creating structured, modular AI prompts.

## Format Overview

### YMD (YAML + Markdown + Jinja2)
**Role**: Orchestrator files that aggregate PMD components

**Structure**:
```yaml
meta:                    # Required metadata (grouped)
  id: unique_id         # snake_case identifier
  kind: category        # prompt type
  version: X.Y.Z        # semantic versioning
  title: Human Title    # descriptive title

section_name: |         # Any YAML key (fully customizable!)
  {{ variables }}
  {% include "component.pmd" %}
```

**Key characteristics**:
- Has `meta:` section with id, kind, version, title
- Contains customizable sections (not limited to standard)
- Includes PMD components to build complete prompts
- Uses Jinja2 for variables and includes
- File extension: `.ymd`

### PMD (Prompt Markdown + Jinja2)
**Role**: Reusable component files (building blocks)

**Structure**:
```markdown
{# Optional documentation comment #}

Markdown content with **formatting**.

{{ variables }}
{% include "other.pmd" %}
```

**Key characteristics**:
- NO `meta:` section (critical - PMDs are pure content)
- Pure Markdown + Jinja2
- Can include other PMDs recursively
- Single responsibility per file
- File extension: `.pmd`

---

## Core Composition Principles

### 1. YMD = Orchestrator, PMD = Component
- **YMDs** aggregate PMDs to create complete prompts
- **PMDs** are building blocks that can be reused
- YMDs include PMDs, PMDs can include other PMDs

### 2. Section Customization
- YMD sections are **fully customizable**
- Not limited to standard sections (system, instructions, user)
- Use any YAML key that makes sense for your domain
- Examples: `context`, `constraints`, `validation_rules`, `api_principles`

### 3. Recursive Composition
- PMDs can include other PMDs
- Unlimited nesting (recommend max 5 levels)
- Watch for circular dependencies

### 4. Variable Propagation
- Variables defined in YMD flow down to all included PMDs
- Variables available throughout entire include chain
- Document expected variables in comments

### 5. Path Resolution
- Include paths are **relative to current file**
- Use `./`, `../`, or `folder/` notation
- Avoid absolute paths

---

## Common Patterns

### Pattern 1: Simple Composition
```
YMD
  └─ includes PMD (leaf)
```

### Pattern 2: Hierarchical
```
YMD
  └─ includes PMD (composite)
      ├─ includes PMD (leaf)
      └─ includes PMD (leaf)
```

### Pattern 3: Multiple Includes
```
YMD
  ├─ includes PMD A
  ├─ includes PMD B
  └─ includes PMD C
```

### Pattern 4: Conditional
```yaml
{% if condition %}
{% include "path_a.pmd" %}
{% else %}
{% include "path_b.pmd" %}
{% endif %}
```

---

## File Organization

Typical project structure:

```
project/
├── prompts/              # YMD orchestrators
│   ├── code_review.ymd
│   ├── api_design.ymd
│   └── docs_generator.ymd
│
└── components/           # PMD components
    ├── roles/           # Persona definitions
    │   ├── expert.pmd
    │   ├── senior_dev.pmd
    │   └── mentor.pmd
    │
    ├── checklists/      # Validation checklists
    │   ├── code_quality.pmd
    │   ├── security.pmd
    │   └── performance.pmd
    │
    ├── formats/         # Output formats
    │   ├── review_comment.pmd
    │   └─ api_spec.pmd
    │
    └── shared/          # Common content
        ├── principles.pmd
        └── style.pmd
```

---

## Quick Reference

### YMD Template
```yaml
{# Expected variables:
   - var1: description
   - var2: description
#}

meta:
  id: unique_identifier
  kind: category
  version: 1.0.0
  title: Descriptive Title

system: |
  {% include "roles/expert.pmd" %}

custom_section: |
  Content or includes

user: |
  {{ user_input_template }}
```

### PMD Template (Leaf)
```markdown
{# Expected variables:
   - var1: description
#}

Content with {{ variables }}.

More content.
```

### PMD Template (Composite)
```markdown
{# Composite component description #}

{% include "../category/component1.pmd" %}
{% include "../category/component2.pmd" %}
```

---

## Critical Rules

### DO:
✅ Group YMD metadata under `meta:` key
✅ Use custom YMD sections freely for clarity
✅ Keep YMD thin (mostly includes)
✅ Give PMDs single, clear responsibility
✅ Use snake_case for all identifiers
✅ Document expected variables
✅ Use relative paths for includes
✅ Validate no circular dependencies

### DON'T:
❌ Put `meta:` section in PMD files (only YMD!)
❌ Use flat metadata in YMD (group under `meta:`)
❌ Create large inline content in YMD (extract to PMD)
❌ Make PMDs too generic or too specific
❌ Use absolute paths
❌ Create circular includes
❌ Forget to document variables

---

## Jinja2 Quick Reference

### Variables
```jinja2
{{ variable_name }}
{{ user.field }}
{{ items[0] }}
```

### Includes
```jinja2
{% include "path/file.pmd" %}
{% include "../shared/common.pmd" %}
{% include "{{ dynamic_path }}.pmd" %}
```

### Control Flow
```jinja2
{% if condition %}
  content
{% elif other %}
  other
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

## Validation Checklist

### For YMD Files:
- [ ] Has `meta:` section (grouped, not flat)
- [ ] Has id, kind, version, title
- [ ] Version follows semver
- [ ] At least one section beyond meta
- [ ] Valid YAML syntax
- [ ] Valid Jinja2 syntax
- [ ] All includes resolve
- [ ] Variables documented

### For PMD Files:
- [ ] NO `meta:` section
- [ ] NO YAML metadata
- [ ] Pure Markdown + Jinja2
- [ ] Valid Markdown syntax
- [ ] Valid Jinja2 syntax
- [ ] Single responsibility
- [ ] Variables documented
- [ ] All includes resolve

### For Composition:
- [ ] All include paths are relative
- [ ] No circular dependencies
- [ ] Depth reasonable (≤5 levels)
- [ ] All variables defined
- [ ] Include chain tested

---

## Common Use Cases

### Code Review Assistant
```yaml
meta:
  id: code_review_assistant
  kind: review
  version: 1.0.0
  title: Code Review Assistant

system: |
  {% include "roles/senior_dev.pmd" %}

review_focus: |
  {% include "checklists/quality.pmd" %}
  {% include "checklists/security.pmd" %}

expected_output: |
  {% include "formats/review_comment.pmd" %}

user: |
  Review this {{ language }} code:
  ```{{ language }}
  {{ code }}
  ```
```

### API Design Assistant
```yaml
meta:
  id: api_design_assistant
  kind: api_design
  version: 1.0.0
  title: API Design Assistant

system: |
  {% include "roles/api_architect.pmd" %}

api_principles: |
  {% include "principles/rest_principles.pmd" %}

security_requirements: |
  {% include "security/api_security.pmd" %}

user: |
  Design API for: {{ requirement }}
```

### Simple Task
```yaml
meta:
  id: simple_task
  kind: task
  version: 1.0.0
  title: Simple Task

user: |
  {{ task }}
```

---

## Naming Conventions

### Files
- **YMD**: `code_review_assistant.ymd` (snake_case)
- **PMD**: `senior_developer_role.pmd` (snake_case)
- Be descriptive, not abbreviated

### Identifiers
- **IDs**: `code_review_assistant` (snake_case)
- **Sections**: `review_focus`, `api_principles` (snake_case)
- **Variables**: `user_profile`, `max_retries` (snake_case)

### Categories
- **Plural**: `roles/`, `checklists/`, `formats/`
- **Lowercase**: all lowercase directory names

---

## Error Patterns to Avoid

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
<!-- ❌ WRONG - PMD should NOT have this -->
meta:
  id: component
  version: 1.0.0

Content...

<!-- ✅ CORRECT - No metadata in PMD -->
{# Component description #}

Content...
```

### Error 3: Circular Includes
```
# ❌ WRONG
a.pmd includes b.pmd
b.pmd includes c.pmd
c.pmd includes a.pmd  # Circular!

# ✅ CORRECT - No cycles
a.pmd includes b.pmd
a.pmd includes c.pmd
b.pmd and c.pmd are leaf components
```

### Error 4: Missing Section Pipe
```yaml
# ❌ WRONG
user:
  {{ task }}

# ✅ CORRECT
user: |
  {{ task }}
```

---

## Your Task Now

With this context loaded, you can now:

1. **Create YMD files** - Orchestrators with proper metadata and sections
2. **Create PMD files** - Reusable components (NO metadata!)
3. **Validate compositions** - Check structure, includes, variables
4. **Guide users** - Help design prompt structures
5. **Debug issues** - Identify and fix format problems

Remember:
- **YMD = Orchestrator** with `meta:` section
- **PMD = Component** without `meta:` section
- **Sections are customizable** in YMD
- **PMDs can include PMDs** recursively
- **Variables flow down** through includes

---

## Need More Detail?

**Full specifications available at**:
- `@~/.claude/ymd-spec/ymd_format_spec.md` - Complete YMD format
- `@~/.claude/ymd-spec/pmd_format_spec.md` - Complete PMD format
- `@~/.claude/ymd-spec/composition_spec.md` - Composition rules
- `@~/.claude/ymd-spec/context/format-guidelines.md` - Complete guidelines
- `@~/.claude/ymd-spec/context/quick-reference.md` - Quick lookup
- `@~/.claude/ymd-spec/context/examples.md` - Practical examples
- `@~/.claude/ymd-spec/cheatsheet/ymd_pmd_cheatsheet.md` - Cheatsheet

**For specific tasks**:
- Creating YMD: `@~/.claude/ymd-spec/prompts/create-ymd.md`
- Creating PMD: `@~/.claude/ymd-spec/prompts/create-pmd.md`
- Validation: `@~/.claude/ymd-spec/prompts/validate-composition.md`
- Authoring guide: `@~/.claude/ymd-spec/prompts/author-guide.md`

---

## Context Loaded ✅

You are now equipped to work with YMD/PMD formats. You understand:

✅ The difference between YMD (orchestrator) and PMD (component)
✅ That YMD has `meta:` section, PMD does not
✅ That YMD sections are fully customizable
✅ How composition works (YMD → PMD → PMD...)
✅ How variables propagate through includes
✅ Path resolution (relative to current file)
✅ Common patterns and use cases
✅ Validation rules and error patterns
✅ Naming conventions and best practices

**You're ready to author YMD/PMD files!**
