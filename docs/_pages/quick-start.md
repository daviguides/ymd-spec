---
layout: page
title: Quick Start
nav_order: 2
---

# Quick Start Guide

Get started with YMD/PMD in 5 minutes.

---

## Installation

### Step 1: Clone Repository
```bash
git clone https://github.com/daviguides/ymd-spec.git
cd ymd-spec
```

### Step 2: Run Installer
```bash
./install.sh
```

This installs specifications to `~/.claude/ymd-spec/`.

### Step 3: Verify Installation
```bash
ls ~/.claude/ymd-spec/
```

You should see:
- `ymd_format_spec.md`
- `pmd_format_spec.md`
- `composition_spec.md`
- `context/`
- `prompts/`
- `cheatsheet/`

---

## Your First YMD File

### Create Minimal YMD

Create `my_first_prompt.ymd`:

```yaml
{% raw %}meta:
  id: my_first_prompt
  kind: task
  version: 1.0.0
  title: My First Prompt

user: |
  {{ task }}{% endraw %}
```

**Key points**:
- ✅ Metadata grouped under `meta:`
- ✅ At least one section (here: `user`)
- ✅ Variables use `{% raw %}{{ variable }}{% endraw %}`

### Test It

If using `ymd-prompt` Python library:

```python
from ymd_prompt import render_ymd

result = render_ymd(
    "my_first_prompt.ymd",
    variables={"task": "Explain Python generators"}
)
print(result)
```

---

## Your First PMD Component

### Create Simple Role

Create `components/expert.pmd`:

```markdown
{% raw %}You are an expert in {{ domain }}.

Your approach:
- Provide clear, technical answers
- Focus on best practices
- Use concrete examples{% endraw %}
```

**Key points**:
- ❌ NO `meta:` section (PMDs don't have metadata!)
- ✅ Pure Markdown + Jinja2
- ✅ Document expected variables in comment

### Use It in YMD

Update your YMD:

```yaml
{% raw %}meta:
  id: my_first_prompt
  kind: task
  version: 1.0.0
  title: My First Prompt

system: |
  {% include "components/expert.pmd" %}

user: |
  {{ task }}{% endraw %}
```

Now the prompt includes the expert role!

---

## Using Claude Code

### Load Context

In Claude Code, run:
```
/load-ymd-context
```

This loads YMD/PMD knowledge into the session.

### Create YMD with Command

```
/create-ymd-manifest
```

Follow the interactive prompts to create a complete YMD file.

### Create PMD with Command

```
/create-pmd-partial
```

Follow prompts to create a reusable component.

### Use Interactive Agent

For guided creation with conversation:
```
@ymd-author I want to create a code review prompt
```

The agent will guide you step-by-step!

---

## Common Patterns

### Pattern 1: Simple Task
```yaml
{% raw %}meta:
  id: simple_task
  kind: task
  version: 1.0.0
  title: Simple Task

user: |
  {{ task }}{% endraw %}
```

### Pattern 2: With Role
```yaml
{% raw %}meta:
  id: with_role
  kind: task
  version: 1.0.0
  title: Task with Role

system: |
  {% include "roles/expert.pmd" %}

user: |
  {{ task }}{% endraw %}
```

### Pattern 3: Custom Sections
```yaml
{% raw %}meta:
  id: custom_sections
  kind: task
  version: 1.0.0
  title: Custom Sections

context: |
  Working on {{ project_name }}

constraints: |
  - Keep code simple
  - Add error handling

user: |
  {{ task }}{% endraw %}
```

### Pattern 4: Conditional
```yaml
{% raw %}meta:
  id: conditional
  kind: task
  version: 1.0.0
  title: Conditional

system: |
  {% if level == "beginner" %}
  {% include "roles/mentor.pmd" %}
  {% else %}
  {% include "roles/expert.pmd" %}
  {% endif %}

user: |
  {{ task }}{% endraw %}
```

---

## File Organization

### Recommended Structure

```
my-prompts/
├── prompts/              # YMD orchestrators
│   ├── code_review.ymd
│   ├── api_design.ymd
│   └── docs_generator.ymd
│
└── components/           # PMD components
    ├── roles/
    │   ├── expert.pmd
    │   ├── senior_dev.pmd
    │   └── mentor.pmd
    │
    ├── checklists/
    │   ├── quality.pmd
    │   └── security.pmd
    │
    ├── formats/
    │   └── review_comment.pmd
    │
    └── shared/
        └── principles.pmd
```

---

## Validation

### Validate Your Files

```
/validate-composition path/to/file.ymd
```

Or with the agent:
```
@ymd-validator Check my code_review.ymd
```

### Common Issues

#### Issue: PMD has metadata
```markdown
<!-- ❌ WRONG -->
meta:
  id: component
```

**Fix**: Remove `meta:` - only YMD has metadata!

#### Issue: Flat metadata in YMD
```yaml
# ❌ WRONG
id: example
kind: task
```

**Fix**: Group under `meta:`
```yaml
# ✅ CORRECT
meta:
  id: example
  kind: task
```

#### Issue: Include not found
```yaml
{% raw %}{% include "expert.pmd" %}  # Can't find it!{% endraw %}
```

**Fix**: Use correct relative path
```yaml
{% raw %}{% include "components/expert.pmd" %}{% endraw %}
```

---

## Next Steps

Now that you have the basics:

1. **Explore Examples**
   - Check `examples/simple/` for basic patterns
   - Check `examples/ymd-pmd/` for real-world example

2. **Read Documentation**
   - [Format Specifications]({% link _pages/specifications.md %}) - Complete reference
   - [Best Practices]({% link _pages/best-practices.md %}) - Guidelines
   - [Examples]({% link _pages/examples.md %}) - Detailed examples

3. **Create Your Own**
   - Start with simple YMD
   - Extract reusable parts to PMDs
   - Validate with `/validate-composition`

4. **Get Help**
   - Use `@ymd-author` for guided creation
   - Use `@composition-expert` for structure advice
   - Use `@ymd-validator` for debugging

---

## Cheatsheet

Check: `~/.claude/ymd-spec/cheatsheet/ymd_pmd_cheatsheet.md`

One-page quick reference for YMD/PMD syntax and patterns.
