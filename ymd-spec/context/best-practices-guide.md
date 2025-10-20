# YMD/PMD Best Practices

**Purpose**: Applied best practices for creating maintainable, reusable YMD/PMD structures.

**For specifications**: See @../ymd_format_spec.md and @../pmd_format_spec.md

---

## Structure Best Practices

### YMD: Keep It Thin

**Principle**: YMD should orchestrate, not contain

✅ **Good**:
```yaml
system: |
  {% include "roles/expert.pmd" %}

instructions: |
  {% include "tasks/analysis.pmd" %}
```

❌ **Bad**:
```yaml
system: |
  You are an expert with 15 years experience...
  [50 more lines of inline content]
```

**Target**: >50% of YMD content should be includes

### PMD: Single Responsibility

**Principle**: Each PMD does one thing well

✅ **Good**:
- `roles/senior_developer.pmd` - Just the role
- `checklists/security_review.pmd` - Just security checks

❌ **Bad**:
- `senior_dev_with_checklists_and_format.pmd` - Mixed responsibilities

**Test**: Can you describe the PMD's purpose in one clear sentence?

### Composition Depth: Stay Shallow

**Principle**: Avoid deep nesting

✅ **Good**: 2-4 levels
```
YMD → PMD → PMD (done)
```

⚠️ **Acceptable**: 5 levels
```
YMD → PMD → PMD → PMD → PMD (max)
```

❌ **Bad**: 6+ levels
```
YMD → PMD → PMD → PMD → PMD → PMD → PMD
```

**Action**: If >5 levels, flatten or combine intermediate PMDs

---

## Naming Best Practices

### Descriptive Over Generic

✅ **Good**:
- `code_review_assistant.ymd`
- `senior_python_developer.pmd`
- `api_security_checklist.pmd`

❌ **Bad**:
- `assistant.ymd`
- `dev.pmd`
- `checks.pmd`

### Consistent Conventions

- **Files**: `snake_case.{ymd|pmd}`
- **Variables**: `{{ snake_case_var }}`
- **IDs**: `id: snake_case_id`

### Avoid Abbreviations

✅ **Good**: `security_review.pmd`
❌ **Bad**: `sec_rev.pmd`

---

## Variable Best Practices

### Document All Variables

✅ **Good**:
```yaml
{# Expected variables:
   - project_type: string - Type of project
   - language: string - Programming language
   - code: string - Code to review
#}
```

❌ **Bad**:
```yaml
{# Uses some variables #}
```

### Use Descriptive Names

✅ **Good**: `{{ primary_language }}`, `{{ experience_level }}`
❌ **Bad**: `{{ lang }}`, `{{ lvl }}`

### Provide Defaults When Sensible

```yaml
{% if quality_threshold %}
Target: {{ quality_threshold }}
{% else %}
Target: 80% (default)
{% endif %}
```

---

## Include Best Practices

### Use Relative Paths

✅ **Good**:
```markdown
{% include "roles/expert.pmd" %}
{% include "../shared/principles.pmd" %}
```

❌ **Bad**:
```markdown
{% include "/absolute/path/roles/expert.pmd" %}
```

### Organize by Category

```
components/
├── roles/           # Role definitions
├── checklists/      # Validation lists
├── formats/         # Output templates
└── shared/          # Common content
```

### Avoid Circular Dependencies

❌ **Bad**:
```
a.pmd includes b.pmd
b.pmd includes a.pmd  ← Circular!
```

✅ **Good**:
```
a.pmd includes shared/common.pmd
b.pmd includes shared/common.pmd
```

---

## Reusability Best Practices

### Extract Common Patterns

When you see the same content twice:
1. Extract to shared PMD
2. Include from both locations
3. Maintain single source of truth

### Balance Specificity and Generality

Too specific:
```markdown
{# Only works for Python 3.11 FastAPI projects with PostgreSQL #}
```

Too generic:
```markdown
{# Works for anything? #}
```

Just right:
```markdown
{# Works for Python web applications with common patterns #}
```

### Use Variables for Flexibility

✅ **Good**:
```markdown
You are a **{{ role_type }}** with expertise in **{{ domain }}**.
```

❌ **Bad**:
```markdown
You are a senior developer with expertise in Python.
```

---

## Maintenance Best Practices

### Version Appropriately

```yaml
meta:
  version: 1.0.0  # Start here
  # 1.0.1 - Bug fixes
  # 1.1.0 - New features (backward compatible)
  # 2.0.0 - Breaking changes
```

### Document Changes

```yaml
{# Version 1.1.0
   Changes:
   - Added support for TypeScript
   - Enhanced security checklist
#}
```

### Keep Related Files Together

```
code_review/
├── code_review_assistant.ymd       # Main YMD
├── roles/
│   └── code_reviewer.pmd
├── checklists/
│   ├── quality.pmd
│   └── security.pmd
└── formats/
    └── review_comment.pmd
```

---

## Quality Best Practices

### Validate Before Using

Checklist:
- [ ] Valid YAML/Markdown/Jinja2 syntax
- [ ] All includes resolve
- [ ] Variables documented
- [ ] No circular dependencies
- [ ] Appropriate naming
- [ ] Single responsibility (PMDs)

### Test with Real Data

```python
# Test your YMD
variables = {
    "language": "python",
    "code": "def example(): pass"
}
# Render and verify output
```

### Review Composition Depth

```bash
# Check your include tree
# Should not exceed 5 levels
```

---

## Performance Best Practices

### Minimize Include Count

Balance between:
- **Too few**: Large inline content (bad)
- **Too many**: 20+ includes in one file (also bad)

Sweet spot: 3-8 includes per YMD

### Cache Common PMDs

If rendering multiple times, cache frequently-included PMDs.

### Avoid Redundant Includes

❌ **Bad**:
```yaml
section1: |
  {% include "common.pmd" %}

section2: |
  {% include "common.pmd" %}  # Duplicate!
```

✅ **Good**:
```yaml
common_content: |
  {% include "common.pmd" %}

section1: |
  {{ common_content }}
  [specific content]

section2: |
  {{ common_content }}
  [specific content]
```

---

## Collaboration Best Practices

### Consistent Style Within Team

Establish conventions:
- Naming patterns
- Directory structure
- Variable naming
- Comment format

### Use Clear Commit Messages

```
feat(roles): add security expert persona
fix(checklists): correct Python-specific items
docs(api): update API design examples
```

### Review PMD Changes

PMD changes affect all YMDs that include them:
- Review impact before changing
- Version appropriately
- Communicate breaking changes

---

## Migration Best Practices

### Gradual Refactoring

Don't try to perfect everything at once:

1. **Start**: Simple YMD with inline content
2. **Extract**: Move large blocks to PMDs
3. **Organize**: Group PMDs by category
4. **Optimize**: Refine structure
5. **Maintain**: Keep improving

### Preserve Functionality

When refactoring:
1. Test before changes
2. Make one change at a time
3. Test after each change
4. Verify output unchanged

### Document Migration Path

```markdown
# Migration from old format

Old structure:
[show old]

New structure:
[show new]

Changes:
- [list changes]

Testing:
- [how to verify]
```

---

## Security Best Practices

### Don't Hardcode Secrets

❌ **Bad**:
```yaml
api_key: "sk-1234567890abcdef"
```

✅ **Good**:
```yaml
api_key: {{ env.API_KEY }}
```

### Validate User Input

```yaml
user: |
  {% if user_input|length > 0 %}
  {{ user_input }}
  {% else %}
  [Error: Input required]
  {% endif %}
```

### Sanitize Included Paths

Ensure include paths don't allow directory traversal:
```yaml
# Avoid: {% include "{{ user_provided_path }}" %}
```

---

## Common Anti-Patterns to Avoid

### 1. Mega Files
❌ 500-line YMD or PMD
✅ Break into focused components

### 2. No Structure
❌ Everything in `user:` section
✅ Use appropriate sections

### 3. Duplicate Content
❌ Same content in 5 files
✅ Extract to shared PMD

### 4. Unclear Naming
❌ `file1.ymd`, `temp.pmd`
✅ Descriptive names

### 5. Missing Documentation
❌ No comments, no variable docs
✅ Document purpose and variables

### 6. Flat Metadata (YMD)
❌ Metadata not under `meta:`
✅ Group under `meta:` key

### 7. PMD with Metadata
❌ PMD has `meta:` section
✅ PMDs are pure Markdown+Jinja2

---

## Quick Checklist

Before finalizing YMD/PMD:

**YMD**:
- [ ] Metadata under `meta:` key
- [ ] Mostly includes (>50%)
- [ ] Variables documented
- [ ] Sections use `|` syntax
- [ ] Descriptive name and ID

**PMD**:
- [ ] NO metadata
- [ ] Single responsibility
- [ ] Variables documented
- [ ] Appropriate category
- [ ] Descriptive name

**Both**:
- [ ] Valid syntax
- [ ] No circular includes
- [ ] Relative include paths
- [ ] Clear naming
- [ ] ≤5 levels depth
