---
layout: page
title: Examples
nav_order: 4
---

# Examples

Real-world examples demonstrating YMD/PMD usage patterns.

---

## Simple Examples

### Minimal YMD

The absolute minimum valid YMD file:

```yaml
{% raw %}meta:
  id: minimal
  kind: task
  version: 1.0.0
  title: Minimal

user: |
  {{ task }}{% endraw %}
```

**Use when**: Simple, single-purpose task with no role needed.

### With Role

YMD with system section including a role:

```yaml
{% raw %}meta:
  id: with_role
  kind: task
  version: 1.0.0
  title: Task with Expert Role

system: |
  {% include "components/expert.pmd" %}

user: |
  {{ task }}{% endraw %}
```

**Component** (`components/expert.pmd`):
```markdown
{% raw %}You are an expert in {{ domain }}.

Your approach:
- Precise, technical answers
- Best practices focus
- Concrete examples{% endraw %}
```

**Use when**: Task needs specific persona or expertise.

---

## Custom Sections Example

Using custom sections for better organization:

```yaml
{% raw %}meta:
  id: api_designer
  kind: api_design
  version: 1.0.0
  title: API Design Assistant

context: |
  Target: {{ target_audience }}
  Domain: {{ domain }}

api_principles: |
  {% include "principles/rest_principles.pmd" %}

constraints: |
  - RESTful architecture
  - JSON only
  - Max response time: {{ max_response_time }}ms

security_requirements: |
  {% include "security/api_security.pmd" %}

user: |
  Design API for: {{ requirement }}{% endraw %}
```

**Key point**: Sections `context`, `api_principles`, `constraints`, `security_requirements` are all custom - not standard sections!

---

## Code Review Example

Complete code review assistant:

### YMD (`code_review.ymd`)

```yaml
{% raw %}meta:
  id: code_review_assistant
  kind: review
  version: 1.0.0
  title: Code Review Assistant

system: |
  {% include "roles/senior_developer.pmd" %}

context: |
  Reviewing {{ language }} code for {{ project_type }}.

review_focus: |
  {% include "checklists/code_quality.pmd" %}
  {% include "checklists/security_review.pmd" %}
  {% include "checklists/performance_review.pmd" %}

expected_output: |
  {% include "formats/review_comment.pmd" %}

user: |
  Review this {{ language }} code:
  ```{{ language }}
  {{ code }}
  ```{% endraw %}
```

### Components

**Role** (`roles/senior_developer.pmd`):
```markdown
{% raw %}You are a senior software engineer with 10+ years of experience in {{ primary_language }}.

Your approach:
- Constructive and specific feedback
- Highlight both issues and good practices
- Provide actionable suggestions
- Prioritize by severity{% endraw %}
```

**Checklist** (`checklists/code_quality.pmd`):
```markdown
## Code Quality Checklist

### Readability
- [ ] Clear, descriptive names
- [ ] Consistent formatting
- [ ] Appropriate comments
- [ ] No magic numbers

### Structure
- [ ] Single Responsibility Principle
- [ ] Appropriate function length
- [ ] Proper separation of concerns
- [ ] DRY principle followed
```

**Format** (`formats/review_comment.pmd`):
```markdown
{% raw %}Return your review in this format:

## Summary
[One-paragraph overview]

## Critical Issues ❌
[Issues that must be fixed]

## Important Improvements ⚠️
[Should be addressed]

## Minor Suggestions 💡
[Nice-to-have]

## What Went Well ✅
[Positive aspects]{% endraw %}
```

---

## Conditional Composition Example

Adapt behavior based on variables:

```yaml
{% raw %}meta:
  id: adaptive_assistant
  kind: adaptive
  version: 1.0.0
  title: Adaptive Assistant

system: |
  {% if experience_level == "beginner" %}
  {% include "roles/mentor.pmd" %}
  {% elif experience_level == "intermediate" %}
  {% include "roles/senior_dev.pmd" %}
  {% else %}
  {% include "roles/expert.pmd" %}
  {% endif %}

instructions: |
  {% if task_type == "learning" %}
  {% include "tasks/teaching_mode.pmd" %}
  {% elif task_type == "debugging" %}
  {% include "tasks/debugging_mode.pmd" %}
  {% else %}
  {% include "tasks/general_mode.pmd" %}
  {% endif %}

user: |
  {{ user_request }}{% endraw %}
```

**Use when**: Need different behavior based on context.

---

## Documentation Generator Example

```yaml
{% raw %}meta:
  id: docs_generator
  kind: documentation
  version: 1.0.0
  title: Documentation Generator

system: |
  {% include "roles/technical_writer.pmd" %}

target_audience: |
  Documentation for {{ audience_level }} developers.
  Assumed knowledge: {{ assumed_knowledge }}

documentation_structure: |
  Required sections:
  1. Overview
  2. Installation
  3. Usage
  4. API Reference
  5. Examples
  6. Troubleshooting

style_guide: |
  {% include "docs/style_guide.pmd" %}

user: |
  Generate documentation for:
  ```{{ language }}
  {{ code }}
  ```{% endraw %}
```

---

## Multi-Level Composition Example

PMDs including other PMDs:

### YMD
```yaml
{% raw %}meta:
  id: enterprise_review
  kind: review
  version: 1.0.0
  title: Enterprise Code Review

system: |
  {% include "roles/senior_architect.pmd" %}

user: |
  Review PR #{{ pr_number }}{% endraw %}
```

### Composite PMD
**`roles/senior_architect.pmd`**:
```markdown
{% raw %}{% include "senior_developer.pmd" %}
{% include "../shared/architecture_principles.pmd" %}
{% include "../shared/enterprise_standards.pmd" %}{% endraw %}
```

### Composition Tree
```
enterprise_review.ymd
  └─ roles/senior_architect.pmd (composite)
      ├─ senior_developer.pmd (leaf)
      ├─ shared/architecture_principles.pmd (leaf)
      └─ shared/enterprise_standards.pmd (leaf)
```

---

## Test Generator Example

```yaml
{% raw %}meta:
  id: test_generator
  kind: testing
  version: 1.0.0
  title: Test Generator

system: |
  {% include "roles/qa_engineer.pmd" %}

testing_framework: |
  Framework: {{ framework }}
  Assertions: {{ assertion_library }}

test_categories: |
  Generate tests for:
  - Happy path scenarios
  - Edge cases
  - Error handling
  - Boundary conditions

coverage_requirements: |
  - Line coverage: > {{ line_coverage }}%
  - Branch coverage: > {{ branch_coverage }}%
  - Function coverage: 100%

user: |
  Generate tests for:
  ```{{ language }}
  {{ code }}
  ```{% endraw %}
```

---

## Language-Specific Example

Dynamic includes based on language:

```yaml
{% raw %}meta:
  id: code_analyzer
  kind: analysis
  version: 1.0.0
  title: Code Analyzer

system: |
  {% include "roles/code_analyst.pmd" %}

language_specifics: |
  {% include "languages/{{ language }}_guidelines.pmd" %}

best_practices: |
  {% include "languages/{{ language }}_best_practices.pmd" %}

user: |
  Analyze this {{ language }} code:
  ```{{ language }}
  {{ code }}
  ```{% endraw %}
```

**Components**:
- `languages/python_guidelines.pmd`
- `languages/javascript_guidelines.pmd`
- `languages/java_guidelines.pmd`
- etc.

---

## Variable Propagation Example

Demonstrating variable flow:

### YMD
```yaml
{% raw %}meta:
  id: variable_demo
  kind: demo
  version: 1.0.0
  title: Variable Flow Demo

system: |
  {% include "level1.pmd" %}

user: |
  Variables: domain={{ domain }}, language={{ language }}{% endraw %}
```

### Level 1 PMD (`level1.pmd`)
```markdown
{% raw %}# Level 1

Domain: {{ domain }}

{% include "level2.pmd" %}{% endraw %}
```

### Level 2 PMD (`level2.pmd`)
```markdown
{% raw %}# Level 2

Domain: {{ domain }}
Language: {{ language }}

Both variables are available here!{% endraw %}
```

**Key point**: Variables flow down through entire include chain.

---

## Complete Real-World Example

See `examples/ymd-pmd/gh_pr.ymd` for a complete GitHub PR generator with:
- Multiple components
- Complex composition
- Real-world structure
- Best practices demonstrated

---

## More Examples

### Local Examples
- `examples/simple/` - Basic instructional examples
- `examples/ymd-pmd/` - Complete real-world example

### Specification Examples
- `~/.claude/ymd-spec/context/examples.md` - 10 detailed examples
- `~/.claude/ymd-spec/context/section-customization.md` - Custom section examples

---

## Creating Your Own

1. **Start simple** - Use minimal pattern
2. **Add role** - Include persona when needed
3. **Extract reusable** - Move common content to PMDs
4. **Add sections** - Use custom sections for clarity
5. **Validate** - Use `/validate-composition`

**Get help**: Use `@ymd-author` for guided creation!
