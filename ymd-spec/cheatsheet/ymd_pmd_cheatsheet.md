# YMD/PMD Quick Lookup Cheatsheet

**One-page reference for YMD/PMD format** - Print-friendly

---

## Format Overview

| Format | Purpose | Contains | File Extension |
|--------|---------|----------|----------------|
| **YMD** | Orchestrator | `meta:` + sections | `.ymd` |
| **PMD** | Component | Markdown + Jinja2 | `.pmd` |

---

## YMD Structure

```yaml
meta:                    # Required metadata
  id: unique_id         # snake_case identifier
  kind: type            # prompt category
  version: 1.0.0        # semver
  title: Title          # human-readable

section_name: |         # Any YAML key (customizable!)
  {{ variable }}        # Variables
  {% include "file.pmd" %}  # Includes
```

### Standard Sections (Optional)
- `system` - Role/persona
- `instructions` - Tasks
- `expected_output` - Output format
- `developer` - Implementation notes
- `user` - User input template

### Custom Sections (Any YAML key)
- `context`, `constraints`, `examples`, `validation_rules`, etc.

---

## PMD Structure

```markdown
<!-- Optional comment -->

Markdown with **formatting**.

{{ variable }}           # Variables
{% include "other.pmd" %}  # Includes (recursive!)
{% if condition %}...{% endif %}  # Control flow
```

**Key**: No `meta:` section, pure Markdown + Jinja2

---

## Jinja2 Syntax Quick Reference

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

## Composition Patterns

### Pattern 1: Simple (YMD → PMD)
```
main.ymd
  └─ includes component.pmd
```

### Pattern 2: Hierarchical (YMD → PMD → PMD)
```
main.ymd
  └─ includes profile.pmd
      └─ includes role.pmd
```

### Pattern 3: Multiple Includes
```
main.ymd
  ├─ includes role.pmd
  ├─ includes checklist1.pmd
  └─ includes checklist2.pmd
```

### Pattern 4: Conditional
```yaml
{% if expert_mode %}
{% include "expert.pmd" %}
{% else %}
{% include "basic.pmd" %}
{% endif %}
```

---

## Path Resolution

**Rule**: Relative to current file

```
project/
├── prompts/main.ymd
└── components/
    ├── roles/expert.pmd
    └── shared/core.pmd

# In main.ymd:
{% include "../components/roles/expert.pmd" %}

# In roles/expert.pmd:
{% include "../shared/core.pmd" %}
```

---

## Variable Propagation

```
YMD defines: domain, language
  └─ PMD A uses: domain, language
      └─ PMD A.1 uses: domain
  └─ PMD B uses: language
```

**Variables flow down** through entire include chain.

---

## File Organization

```
project/
├── prompts/           # YMD orchestrators
│   └── *.ymd
└── components/        # PMD components
    ├── roles/
    ├── checklists/
    ├── formats/
    └── shared/
```

---

## Validation Checklist

### YMD
- [ ] Has `meta:` section (grouped)
- [ ] Has id, kind, version, title
- [ ] Version is semver (X.Y.Z)
- [ ] All includes exist
- [ ] No circular dependencies

### PMD
- [ ] No `meta:` section
- [ ] Valid Markdown
- [ ] Valid Jinja2 syntax
- [ ] All includes exist
- [ ] No circular dependencies

---

## Common Errors & Fixes

| Error | Fix |
|-------|-----|
| `File not found: roles/expert.pmd` | Check path relative to current file |
| `Circular: a.pmd → b.pmd → a.pmd` | Remove circular dependency |
| `Undefined variable 'domain'` | Define in YMD or context |
| `Invalid YAML` | Check indentation, use `\|` for multi-line |
| `Jinja2 syntax error` | Validate `{% %}` and `{{ }}` syntax |

---

## YMD Quick Templates

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

### Standard YMD
```yaml
meta:
  id: assistant
  kind: task
  version: 1.0.0
  title: Assistant

system: |
  {% include "roles/expert.pmd" %}

instructions: |
  {{ instructions }}

user: |
  {{ input }}
```

### Custom Sections YMD
```yaml
meta:
  id: custom
  kind: task
  version: 1.0.0
  title: Custom

context: |
  {{ context }}

constraints: |
  - {{ constraint_1 }}

validation_rules: |
  {% include "rules/validation.pmd" %}

user: |
  {{ input }}
```

---

## PMD Quick Templates

### Leaf PMD (No Includes)
```markdown
You are an expert in {{ domain }}.

Your expertise:
- {{ skill_1 }}
- {{ skill_2 }}
```

### Composite PMD (With Includes)
```markdown
You are a {{ role_type }}.

{% include "../shared/principles.pmd" %}
{% include "../shared/style.pmd" %}
```

### Conditional PMD
```markdown
{% if language == "python" %}
Python-specific content
{% elif language == "javascript" %}
JavaScript-specific content
{% else %}
Generic content
{% endif %}
```

---

## Naming Conventions

### Files
- **YMD**: `snake_case.ymd` (e.g., `code_review_assistant.ymd`)
- **PMD**: `snake_case.pmd` (e.g., `senior_developer_role.pmd`)

### Sections
- **Use**: `snake_case` (e.g., `validation_rules`)
- **Avoid**: `camelCase`, `kebab-case`, `spaces`

### Variables
- **Descriptive**: `user_discount_percentage`
- **Avoid**: `x`, `temp`, `data`

---

## Best Practices Summary

### YMD
✅ Use `meta:` for all metadata
✅ Keep thin (mostly includes)
✅ Use custom sections freely
✅ Document expected variables
✅ Follow semantic versioning

❌ No large content blocks
❌ No hardcoded values (use variables)
❌ No duplicate content across YMDs

### PMD
✅ Single responsibility
✅ Descriptive filenames
✅ Document variables in comments
✅ Organize by category
✅ Test independently

❌ No YAML metadata
❌ No circular includes
❌ No absolute paths
❌ No giant monoliths

### Composition
✅ Document structure
✅ Keep depth ≤5 levels
✅ Use relative paths
✅ Test include chains
✅ Validate no cycles

❌ Don't nest too deep
❌ Don't create circular includes
❌ Don't over-engineer simple prompts

---

## Composition Depth Guide

| Depth | Example | Status |
|-------|---------|--------|
| 1 | YMD | ✅ Start |
| 2 | YMD → PMD | ✅ Good |
| 3 | YMD → PMD → PMD | ✅ Good |
| 4 | YMD → PMD → PMD → PMD | ✅ OK |
| 5 | YMD → PMD → PMD → PMD → PMD | ⚠️ Max |
| 6+ | ... | ❌ Refactor |

---

## Quick Decision Tree

```
Need metadata (id, version, etc.)?
├─ YES → Use YMD
└─ NO → Use PMD

Orchestrating multiple components?
├─ YES → Use YMD (orchestrator)
└─ NO → Use PMD (component)

Reusable across multiple prompts?
├─ YES → Use PMD (in components/)
└─ NO → Inline in YMD or PMD

Need custom sections?
└─ YES → YMD supports any YAML key!

PMD need to include other PMDs?
└─ YES → PMDs can include PMDs recursively!
```

---

## Syntax Comparison

| Feature | YMD | PMD |
|---------|-----|-----|
| **Metadata** | ✅ Required (`meta:`) | ❌ Forbidden |
| **Markdown** | ✅ In sections | ✅ Entire file |
| **Jinja2** | ✅ In sections | ✅ Entire file |
| **Variables** | ✅ `{{ var }}` | ✅ `{{ var }}` |
| **Includes** | ✅ `{% include %}` | ✅ `{% include %}` |
| **Control Flow** | ✅ `{% if/for %}` | ✅ `{% if/for %}` |
| **Can Include** | PMDs only | PMDs only |
| **Can Be Included** | No | Yes (by YMD or PMD) |
| **Sections** | Customizable YAML keys | Not applicable |

---

## Common Use Cases

| Use Case | Start With | Pattern |
|----------|------------|---------|
| **Simple prompt** | Minimal YMD | 1-2 sections |
| **Role-based prompt** | Standard YMD | YMD → role PMD |
| **Complex workflow** | Standard YMD | YMD → multiple PMDs |
| **Reusable role** | Leaf PMD | Pure content |
| **Role aggregation** | Composite PMD | PMD → PMDs |
| **Conditional logic** | Conditional YMD/PMD | `{% if %}` branches |
| **Language-specific** | Parameterized includes | `"{{ lang }}.pmd"` |

---

## Troubleshooting Quick Guide

### Issue: Include not found
```bash
# Check path is relative to current file
# Use `tree` to verify structure
```

### Issue: Circular include
```bash
# Track include chain
# Remove back-reference
```

### Issue: Undefined variable
```bash
# Check YMD defines variable
# Check variable name spelling
# Check variable flows through chain
```

### Issue: YAML parse error
```bash
# Check indentation (2 spaces)
# Use `|` for multi-line strings
# Escape special characters
```

### Issue: Jinja2 syntax error
```bash
# Match opening/closing tags
# Validate {% %} and {{ }}
# Check quotes in strings
```

---

## Integration Examples

### With Python (ymd-prompt)
```python
from ymd_prompt import render_ymd

result = render_ymd(
    "prompts/assistant.ymd",
    variables={"domain": "Python", "task": "Review code"}
)
```

### With VSCode Extension
```bash
# Install vscode-ymd for syntax highlighting
# .ymd and .pmd files get highlighting
```

### With Claude Code Plugin
```bash
# Install plugin
# Use commands: /ymd:create-manifest, /ymd:create-partial
# Use agents: ymd-author, composition-expert
```

---

## Version History

| Version | Changes |
|---------|---------|
| 1.0.0 | Initial YMD/PMD specification |
| 1.1.0 | Added custom sections support |
| 1.2.0 | Added composition patterns |
| 2.0.0 | Grouped metadata under `meta:` key |

---

## Quick Links

- **Full Specs**: `spec/ymd_format.md`, `spec/pmd_format.md`, `spec/composition.md`
- **Guidelines**: `context/format-guidelines.md`
- **Examples**: `context/examples.md`
- **Reference**: `context/quick-reference.md`

---

## Printable Checklist

**Before Creating YMD:**
- [ ] Identified orchestrator role
- [ ] Planned component includes
- [ ] Listed required variables
- [ ] Chose appropriate sections
- [ ] Decided on custom sections if needed

**Before Creating PMD:**
- [ ] Identified single responsibility
- [ ] Planned includes (if composite)
- [ ] Listed used variables
- [ ] Chose category folder
- [ ] Named descriptively

**Before Committing:**
- [ ] Validated YAML/Markdown syntax
- [ ] Checked all includes exist
- [ ] Verified no circular dependencies
- [ ] Tested with sample variables
- [ ] Documented in comments
- [ ] Follows naming conventions

---

**Print this page and keep it handy while authoring YMD/PMD files!**
