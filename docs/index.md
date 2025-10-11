---
layout: home
title: Home
nav_order: 1
---

<img src="./assets/images/ymd-pmd-banner.png" alt="Principles Diagram" align="right" style="width: 450px;background-color:#f2f0e9;border-radius: 1rem;margin-left:10px;"/>

# YMD/PMD Format Specification

**Structured, Modular AI Prompts**

YMD/PMD is a format for creating maintainable, reusable AI prompts using YAML, Markdown, and Jinja2 templating.

<br/><br/>

## Quick Start

### One-Line Installation (Claude Code Plugin)

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/daviguides/ymd-spec/main/install.sh)"
```

---

## Why YMD/PMD?

### The Problem: Monolithic Prompts

**Traditional prompts create visual coupling that makes it nearly impossible to manage individual concepts:**

- **No isolation** - Can't test, version, or update individual concepts (roles, principles, checklists) separately
- **Visual coupling** - 150+ line files mixing multiple concerns make it hard to see where one concept ends and another begins
- **Team friction** - Multiple people can't work on the same prompt simultaneously without conflicts
- **Duplication everywhere** - Same concepts copied across prompts lead to inconsistent versions
- **Fragile changes** - Small updates require hunting through multiple monolithic files

**Example of a monolithic prompt:**

```markdown
You are a senior Python developer with 10+ years of experience.
You focus on clean code, SOLID principles, and test coverage.
You always check for security vulnerabilities.
You prefer async/await over threading.
[... 150+ lines mixing role, principles, checklists ...]
```

### The Solution: Modular Composition

YMD/PMD separates concerns into **independent, reusable components** that compose together:

```yaml
# Modular prompt - Each concept is isolated and testable
meta:
  id: python_code_reviewer
  kind: review
  version: 1.0.0

system: |
  {% raw %}{% include "roles/senior_python_dev.pmd" %}
  {% include "principles/clean_code.pmd" %}
  {% include "principles/async_first.pmd" %}{% endraw %}

review_focus: |
  {% raw %}{% include "checklists/security.pmd" %}
  {% include "checklists/testing.pmd" %}{% endraw %}
```

**Benefits:**

- **Isolated concepts** - Test, version, and update each component independently
- **Clear boundaries** - Each PMD has a single responsibility and purpose
- **Team-friendly** - Different people can work on different components simultaneously
- **Single source of truth** - Update `senior_python_dev.pmd` once, affects all prompts that include it
- **Easier maintenance** - See exactly what a prompt includes at a glance

---

## What is YMD/PMD?

### YMD (YAML + Markdown + Jinja2)
**Orchestrator files** that aggregate reusable components into complete prompts.

```yaml
meta:
  id: code_reviewer
  kind: review
  version: 1.0.0
  title: Code Review Assistant

system: |
  {% raw %}{% include "roles/expert.pmd" %}{% endraw %}

user: |
  {% raw %}Review this code: {{ code }}{% endraw %}
```

### PMD (Prompt Markdown + Jinja2)
**Component files** that are pure Markdown + Jinja2, reusable across prompts.

```markdown
You are an expert in {% raw %}{{ domain }}{% endraw %}.

Your approach:
- Clear, actionable feedback
- Best practices focus
```

---

## Tools & Integration

### Claude Code Plugin
```bash
# Commands
/load-ymd-context          # Load format knowledge
/create-ymd-manifest       # Create YMD file
/create-pmd-partial        # Create PMD component
/validate-composition      # Validate structure

# Agents
@ymd-author               # Interactive authoring
@composition-expert       # Structure optimization
@ymd-validator           # Validation & debugging
```

### Python Library

**[ymd-prompt](https://github.com/daviguides/ymd-prompt)** - Python library for rendering YMD files

```python
from ymd_prompt import render_ymd

result = render_ymd(
    "prompts/code_review.ymd",
    variables={"language": "python", "code": code_sample}
)
```

### VSCode Extension

**[vscode-ymd](https://github.com/daviguides/vscode-ymd)** - VSCode syntax highlighting extension:
- Syntax highlighting for `.ymd` and `.pmd` files
- Auto-completion for includes
- Validation on save

---

## Documentation

- **[Format Specifications]({% link _pages/specifications.md %})** - Complete YMD/PMD format reference
- **[Quick Start Guide]({% link _pages/quick-start.md %})** - Get started in 5 minutes
- **[Examples]({% link _pages/examples.md %})** - Real-world usage examples
- **[Best Practices]({% link _pages/best-practices.md %})** - Guidelines and patterns
- **[Cheatsheet]({% link _pages/cheatsheet.md %})** - Quick reference

---

## Key Features

### Modular Design
- **YMD files** orchestrate complete prompts
- **PMD files** are reusable building blocks
- Compose complex prompts from simple parts

### Fully Customizable
- Sections are **not limited** to standard names
- Use any YAML key that makes sense
- Domain-specific organization supported

### Recursive Composition
- PMDs can include other PMDs
- Build hierarchies of components
- Unlimited nesting (with best practices)

### Single Source of Truth
- Define components once
- Reuse across multiple prompts
- Maintain consistency easily

---

## Community

- **GitHub**: [daviguides/ymd-spec](https://github.com/daviguides/ymd-spec)
- **Issues**: [Report bugs or request features](https://github.com/daviguides/ymd-spec/issues)

---

## License

MIT License - see [LICENSE](https://github.com/daviguides/ymd-spec/blob/main/LICENSE) for details.

<br/><br/>

<img src="./assets/images/ymd-pmd-banner.png" alt="Principles Diagram" align="center" style="width: 650px;background-color:#f2f0e9;border-radius: 1rem;margin:0 auto;"/>