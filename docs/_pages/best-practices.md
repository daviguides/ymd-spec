---
layout: page
title: Best Practices
nav_order: 5
---

# Best Practices

Guidelines and patterns for creating high-quality YMD/PMD files.

---

## YMD Best Practices

### Metadata

#### Use Descriptive IDs
```yaml
# ✅ GOOD
meta:
  id: code_review_assistant

# ❌ BAD
meta:
  id: cr_assist
```

**Why**: Clear, descriptive IDs make the purpose obvious.

#### Follow Semantic Versioning
```yaml
meta:
  version: 1.0.0  # Initial release
  version: 1.1.0  # New feature (backward compatible)
  version: 2.0.0  # Breaking change
```

**Why**: Tracks changes and compatibility clearly.

#### Meaningful Titles
```yaml
# ✅ GOOD
meta:
  title: Comprehensive Code Review Assistant

# ❌ BAD
meta:
  title: Assistant
```

**Why**: Titles help users understand purpose at a glance.

### Structure

#### Keep YMD Thin
```yaml
# ✅ GOOD - Mostly includes
system: |
  {% raw %}{% include "roles/senior_dev.pmd" %}{% endraw %}

review_focus: |
  {% raw %}{% include "checklists/quality.pmd" %}
  {% include "checklists/security.pmd" %}{% endraw %}

# ❌ BAD - Large inline content
system: |
  You are a senior developer...
  [45 lines of content]
```

**Why**: Reusability and maintainability improve with extracted components.

#### Use Custom Sections Appropriately
```yaml
# ✅ GOOD - Clear, domain-specific sections
context: |
  Working on {{ project_type }}

api_principles: |
  {% raw %}{% include "principles/rest_principles.pmd" %}{% endraw %}

security_requirements: |
  {% raw %}{% include "security/api_security.pmd" %}{% endraw %}

# ❌ BAD - Everything in instructions
instructions: |
  Context: Working on {{ project_type }}

  API Principles: ...

  Security Requirements: ...
```

**Why**: Custom sections provide better organization and clarity.

#### Document Expected Variables
```yaml
{% raw %}{# Expected variables:
   - project_type: string - Type of project
   - language: string - Programming language
   - code: string - Code to review
#}

meta:
  id: code_reviewer{% endraw %}
  ...
```

**Why**: Makes it clear what variables are needed at render time.

### Organization

#### Logical Section Order
```yaml
# ✅ GOOD - Logical flow
meta: ...
system: ...       # Who
context: ...      # Where/when
instructions: ... # What
expected_output: ...  # How
user: ...         # Input

# ❌ BAD - Random order
meta: ...
user: ...
system: ...
expected_output: ...
```

**Why**: Natural reading order improves understanding.

---

## PMD Best Practices

### Single Responsibility

#### One Clear Purpose
```markdown
<!-- ✅ GOOD - Single responsibility -->
{% raw %}You are an expert in {{ domain }}.

Your approach:
- Clear, technical answers
- Best practices focus{% endraw %}
```

```markdown
<!-- ❌ BAD - Multiple responsibilities -->
{% raw %}You are an expert in {{ domain }}.

Your approach: ...

Also, here are some checklists:
- [ ] Check 1
- [ ] Check 2

And output format:
Return as JSON...{% endraw %}
```

**Why**: Single responsibility makes components more reusable.

#### Extract Related Concerns
```markdown
<!-- If mixing concerns, split into multiple PMDs -->
roles/expert.pmd           # Just the role
checklists/quality.pmd     # Just the checklist
formats/json_response.pmd  # Just the format
```

### Naming

#### Descriptive Filenames
```bash
# ✅ GOOD
roles/senior_python_developer.pmd
checklists/api_security_review.pmd
formats/markdown_documentation.pmd

# ❌ BAD
roles/dev.pmd
checklists/check.pmd
formats/format.pmd
```

**Why**: Names should explain the component's purpose.

#### Follow Conventions
```bash
# Use snake_case
roles/technical_writer.pmd  ✅
roles/TechnicalWriter.pmd   ❌
roles/technical-writer.pmd  ❌
```

### Documentation

#### Document Variables
```markdown
{% raw %}{# Senior Developer Role

   Expected variables:
   - primary_language: string - Main programming language
   - years_experience: number - Years of experience (default: 10)
#}

You are a senior {{ primary_language }} developer...{% endraw %}
```

**Why**: Clear variable documentation prevents confusion.

#### Add Context Comments
```markdown
{% raw %}{# This checklist focuses on API security specifically,
   not general application security.

   Use with: API design prompts
   Related: checklists/general_security.pmd
#}{% endraw %}
```

**Why**: Helps others understand when and how to use the component.

---

## Composition Best Practices

### Include Paths

#### Use Relative Paths
```yaml
# ✅ GOOD - Relative to current file
{% raw %}{% include "../components/roles/expert.pmd" %}{% endraw %}

# ❌ BAD - Absolute path
{% raw %}{% include "/Users/username/project/roles/expert.pmd" %}{% endraw %}
```

**Why**: Relative paths work across different environments.

#### Consistent Path Structure
```
prompts/
  └── code_review.ymd → {% raw %}{% include "../components/roles/expert.pmd" %}{% endraw %}

components/
  └── roles/
      └── expert.pmd
```

**Why**: Consistent structure makes includes predictable.

### Composition Depth

#### Keep Reasonable Depth
```
# ✅ GOOD - 3 levels
main.ymd
  └── profile.pmd
      └── role.pmd

# ⚠️ ACCEPTABLE - 5 levels
main.ymd
  └── orchestrator.pmd
      └── profile.pmd
          └── role.pmd
              └── core.pmd

# ❌ BAD - 7+ levels (too deep)
main.ymd → ... → ... → ... → ... → ... → deep.pmd
```

**Why**: Deep nesting becomes hard to understand and debug.

### Avoid Circular Dependencies

#### Bad Pattern
```
a.pmd includes b.pmd
b.pmd includes c.pmd
c.pmd includes a.pmd  ❌ Circular!
```

#### Good Pattern
```
a.pmd includes shared.pmd
b.pmd includes shared.pmd
c.pmd includes shared.pmd  ✅ No cycle
```

**Why**: Circular dependencies cause infinite loops.

---

## Variable Best Practices

### Naming

#### Use Descriptive Names
```yaml
# ✅ GOOD
{% raw %}user_profile_data: {{ user_profile_data }}
max_retry_attempts: {{ max_retry_attempts }}
api_base_url: {{ api_base_url }}

# ❌ BAD
data: {{ data }}
max: {{ max }}
url: {{ url }}{% endraw %}
```

**Why**: Clear names prevent confusion about variable purpose.

### Documentation

#### Document in YMD
```yaml
{% raw %}{# Expected variables:
   - language: string - Programming language (e.g., "python", "javascript")
   - code: string - Code to review
   - strict_mode: boolean - Enable strict validation (default: false)
#}{% endraw %}
```

#### Document in PMD
```markdown
{% raw %}{# Expected variables:
   - domain: string - Domain of expertise
   - experience_level: string - "junior" | "senior" | "expert"
#}{% endraw %}
```

**Why**: Clear documentation prevents runtime errors.

### Defaults

#### Provide Sensible Defaults
```yaml
{% raw %}{% set max_retries = max_retries | default(3) %}
{% set timeout = timeout | default(30) %}{% endraw %}
```

**Why**: Makes variables optional when appropriate.

---

## File Organization Best Practices

### Directory Structure

#### Organize by Category
```
project/
├── prompts/              # YMD files
│   ├── code_review.ymd
│   └── api_design.ymd
│
└── components/           # PMD files
    ├── roles/
    ├── checklists/
    ├── formats/
    └── shared/
```

**Why**: Clear structure improves discoverability.

#### Or by Domain
```
project/
├── prompts/
└── components/
    ├── python/          # Python-specific
    ├── javascript/      # JavaScript-specific
    └── general/         # Language-agnostic
```

**Why**: Domain organization works well for specialized use cases.

### File Placement

#### Place by Function
```bash
# Role definitions
components/roles/senior_dev.pmd

# Validation checklists
components/checklists/security.pmd

# Output formats
components/formats/json_response.pmd

# Shared content
components/shared/principles.pmd
```

**Why**: Function-based placement is intuitive.

---

## Testing Best Practices

### Validate Regularly

```bash
# After creating/editing files
/validate-composition path/to/file.ymd
```

**Why**: Catch errors early.

### Test Include Chains

```bash
# Test that all includes resolve
# Test with sample variables
# Verify no circular dependencies
```

**Why**: Ensures composition works as expected.

### Version Control

```bash
# Commit YMD and PMD files together
git add prompts/code_review.ymd
git add components/roles/senior_dev.pmd
git commit -m "Add code review prompt with senior dev role"
```

**Why**: Keeps related changes together.

---

## Performance Best Practices

### Minimize Include Depth

**Recommendation**: Keep depth ≤ 5 levels

**Why**: Deep nesting impacts render performance and debugging.

### Reuse Components

```yaml
# ✅ GOOD - Reuse across prompts
review_focus: |
  {% raw %}{% include "checklists/quality.pmd" %}{% endraw %}

# ❌ BAD - Duplicate content
review_focus: |
  ## Quality Checklist
  [same content copied in multiple YMDs]
```

**Why**: Reuse reduces duplication and maintenance burden.

### Cache Common Components

If using rendering library, cache frequently used PMDs.

**Why**: Reduces file I/O for repeated includes.

---

## Maintenance Best Practices

### Version Your Prompts

```yaml
meta:
  version: 1.0.0  # Track changes

# Document changes in CHANGELOG
```

### Review Periodically

- Check for outdated components
- Remove unused PMDs
- Update variable documentation
- Refactor complex compositions

### Keep Documentation Updated

- Update README when structure changes
- Document new patterns
- Keep examples current

---

## Common Patterns

### Pattern: Adapter

Create thin adapter YMDs for different use cases:

```yaml
# code_review_strict.ymd
{% raw %}{% set strict_mode = true %}
{% include "code_review_base.ymd" %}{% endraw %}

# code_review_relaxed.ymd
{% raw %}{% set strict_mode = false %}
{% include "code_review_base.ymd" %}{% endraw %}
```

### Pattern: Template Method

Base YMD with customization points:

```yaml
# base.ymd
system: |
  {% raw %}{% include "roles/base_role.pmd" %}
  {% block custom_expertise %}{% endblock %}{% endraw %}
```

### Pattern: Composition

Build complex from simple:

```yaml
system: |
  {% raw %}{% include "roles/expert.pmd" %}
  {% include "shared/principles.pmd" %}
  {% include "shared/communication_style.pmd" %}{% endraw %}
```

---

## Anti-Patterns to Avoid

### ❌ Giant Monolithic PMD

```markdown
<!-- DON'T: 500+ line PMD doing everything -->
```

**Fix**: Split by responsibility into multiple PMDs.

### ❌ Flat Metadata in YMD

```yaml
# DON'T
id: example
kind: task
```

**Fix**: Group under `meta:`.

### ❌ Magic Values

```yaml
# DON'T
{% raw %}if attempts > 3:{% endraw %}
```

**Fix**: Use variables:
```yaml
{% raw %}{% set max_attempts = max_attempts | default(3) %}
if attempts > max_attempts:{% endraw %}
```

### ❌ No Variable Documentation

```yaml
# DON'T: Undocumented variables
user: |
  {% raw %}{{ mysterious_variable }}{% endraw %}
```

**Fix**: Document all variables.

---

## Checklist Before Publishing

- [ ] YMD has grouped `meta:` section
- [ ] PMD has NO `meta:` section
- [ ] All includes use relative paths
- [ ] All variables documented
- [ ] No circular dependencies
- [ ] Naming follows conventions
- [ ] Files validated with `/validate-composition`
- [ ] Tested with sample variables
- [ ] README updated (if needed)

---

## Getting Help

- Use `@ymd-author` for guided creation
- Use `@composition-expert` for structure advice
- Use `@ymd-validator` for debugging
- Check [Examples]({% link _pages/examples.md %}) for patterns
- Refer to [Specifications]({% link _pages/specifications.md %}) for details
