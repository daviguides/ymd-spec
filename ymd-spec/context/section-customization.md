# YMD Section Customization Guide

## Overview

YMD sections are **fully customizable**. You are not limited to standard sections like `system`, `instructions`, or `user`.

**Any valid YAML key** can be a section.

---

## Standard vs Custom Sections

### Standard Sections (Optional)

These are **common patterns**, not requirements:

- `system` - Role/persona definition
- `instructions` - Step-by-step tasks
- `expected_output` - Output format specification
- `developer` - Implementation notes
- `user` - User input template

### Custom Sections (Fully Supported)

**Any YAML key name works**:

- `context` - Contextual information
- `constraints` - Limitations or rules
- `examples` - Sample inputs/outputs
- `validation_rules` - Validation criteria
- `background` - Background information
- `assumptions` - Assumed knowledge
- `edge_cases` - Special scenarios
- `test_cases` - Testing scenarios
- `performance_requirements` - Performance specs
- `error_handling` - Error handling strategy

---

## Custom Section Examples

### Example 1: API Design Prompt

```yaml
meta:
  id: api_designer
  kind: api
  version: 1.0.0
  title: API Design Assistant

context: |
  This API will serve {{ target_audience }}.
  Primary use case: {{ primary_use_case }}

constraints: |
  - RESTful principles
  - JSON only
  - Max response time: {{ max_response_time }}ms
  - Rate limit: {{ rate_limit }} requests/minute

security_requirements: |
  - OAuth 2.0 authentication
  - HTTPS only
  - API key for additional authorization
  {% include "security/api_best_practices.pmd" %}

user: |
  Design an API for: {{ requirement }}
```

### Example 2: Code Review Prompt

```yaml
meta:
  id: code_reviewer
  kind: review
  version: 1.0.0
  title: Code Review Assistant

system: |
  {% include "roles/senior_dev.pmd" %}

review_focus: |
  Primary focus areas:
  1. {{ focus_1 }}
  2. {{ focus_2 }}
  3. {{ focus_3 }}

quality_criteria: |
  {% include "checklists/code_quality.pmd" %}

security_criteria: |
  {% include "checklists/security.pmd" %}

performance_criteria: |
  - Time complexity: O({{ max_complexity }})
  - Memory usage: < {{ max_memory }}MB
  - Network calls: < {{ max_network_calls }}

expected_output: |
  {% include "formats/review_comment.pmd" %}

user: |
  Review this {{ language }} code:
  \`\`\`{{ language }}
  {{ code }}
  \`\`\`
```

### Example 3: Documentation Generator

```yaml
meta:
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

examples_requirements: |
  - Minimum {{ min_examples }} examples
  - Cover {{ coverage_percentage }}% of use cases
  - Include error handling examples

user: |
  Generate documentation for:
  \`\`\`{{ language }}
  {{ code }}
  \`\`\`
```

### Example 4: Test Generator

```yaml
meta:
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

test_data: |
  Use realistic test data:
  {% include "test_data/{{ domain }}_samples.pmd" %}

user: |
  Generate tests for:
  \`\`\`{{ language }}
  {{ code }}
  \`\`\`
```

---

## Section Syntax

All sections use the same syntax:

```yaml
section_name: |
  Content goes here
  {{ variables }}
  {% include "file.pmd" %}
```

**Key points**:
- Use `|` for multi-line block scalar
- Indent content by 2 spaces
- Full Markdown support
- Full Jinja2 support

---

## When to Use Custom Sections

### Use Custom Sections When:

1. **Standard sections don't fit your use case**
   ```yaml
   context: |          # Better than forcing into system
   constraints: |      # Better than hiding in instructions
   ```

2. **You need domain-specific organization**
   ```yaml
   api_endpoints: |    # For API design
   database_schema: |  # For data modeling
   ui_requirements: |  # For UI design
   ```

3. **You want clearer structure**
   ```yaml
   prerequisites: |    # Clearer than generic instructions
   success_criteria: | # Clearer than expected_output
   failure_cases: |    # Explicit error scenarios
   ```

4. **You need separation of concerns**
   ```yaml
   functional_requirements: |
   non_functional_requirements: |
   security_requirements: |
   performance_requirements: |
   ```

---

## Organizing Custom Sections

### By Concern

```yaml
meta:
  id: system_designer
  kind: design
  version: 1.0.0
  title: System Designer

# Functional
functional_requirements: |
  {{ requirements }}

# Non-functional
performance_requirements: |
  {{ performance }}

security_requirements: |
  {{ security }}

scalability_requirements: |
  {{ scalability }}
```

### By Phase

```yaml
meta:
  id: project_planner
  kind: planning
  version: 1.0.0
  title: Project Planner

# Analysis phase
problem_analysis: |
  {{ problem }}

# Design phase
solution_design: |
  {{ design }}

# Implementation phase
implementation_plan: |
  {{ plan }}

# Testing phase
testing_strategy: |
  {{ testing }}
```

### By Stakeholder

```yaml
meta:
  id: requirement_analyzer
  kind: analysis
  version: 1.0.0
  title: Requirement Analyzer

# Business perspective
business_requirements: |
  {{ business }}

# User perspective
user_requirements: |
  {{ user }}

# Technical perspective
technical_requirements: |
  {{ technical }}

# Operations perspective
operational_requirements: |
  {{ operations }}
```

---

## Best Practices

### DO:
- ✅ Use descriptive section names
- ✅ Be consistent within project
- ✅ Document custom sections
- ✅ Group related sections
- ✅ Use domain-specific terminology

### DON'T:
- ❌ Don't use generic names (`section1`, `part2`)
- ❌ Don't abbreviate unnecessarily (`req` → `requirements`)
- ❌ Don't duplicate content across sections
- ❌ Don't create too many sections (keep manageable)

---

## Naming Conventions

### Use snake_case
```yaml
test_cases: |           # ✅ Good
error_handling: |       # ✅ Good
TestCases: |            # ❌ Bad
error-handling: |       # ❌ Bad
```

### Be Specific
```yaml
api_security_requirements: |  # ✅ Specific
security: |                    # ⚠️ Vague
requirements: |                # ❌ Too generic
```

### Use Standard Prefixes/Suffixes
```yaml
# Prefixes
input_validation: |
input_format: |

# Suffixes
security_requirements: |
performance_requirements: |

# Categories
test_unit: |
test_integration: |
```

---

## Advanced Patterns

### Conditional Sections

```yaml
meta:
  id: adaptive_prompt
  kind: task
  version: 1.0.0
  title: Adaptive Prompt

system: |
  {% include "roles/expert.pmd" %}

{% if include_background %}
background: |
  {% include "context/background.pmd" %}
{% endif %}

{% if strict_mode %}
validation_rules: |
  {% include "rules/strict.pmd" %}
{% else %}
validation_rules: |
  {% include "rules/relaxed.pmd" %}
{% endif %}
```

Note: Section names themselves are static (defined in YAML), but their **content** can be conditional.

### Parameterized Section Content

```yaml
meta:
  id: customizable_prompt
  kind: task
  version: 1.0.0
  title: Customizable

{{ custom_section_1_name }}: |
  {{ custom_section_1_content }}

{{ custom_section_2_name }}: |
  {{ custom_section_2_content }}
```

Note: Section **names** can use variables if your renderer supports it.

---

## Validation

### Section Name Validation

Valid section names:
- ✅ `system`
- ✅ `user_input`
- ✅ `api_requirements`
- ✅ `test_cases_unit`

Invalid section names:
- ❌ `123section` (starts with number)
- ❌ `section-name` (hyphen not allowed in some parsers)
- ❌ `section name` (space not allowed)
- ❌ `@section` (special character)

**Rule**: Use valid YAML key names (letters, numbers, underscores).

---

## Migration from Standard to Custom

### Before (Standard Only)

```yaml
meta:
  id: reviewer
  kind: review
  version: 1.0.0
  title: Reviewer

instructions: |
  Review for quality.

  Security checklist:
  - Check 1
  - Check 2

  Performance requirements:
  - Requirement 1
  - Requirement 2
```

### After (Custom Sections)

```yaml
meta:
  id: reviewer
  kind: review
  version: 1.0.0
  title: Reviewer

quality_review: |
  Review for quality.

security_checklist: |
  - Check 1
  - Check 2

performance_requirements: |
  - Requirement 1
  - Requirement 2
```

**Benefits**:
- Clearer organization
- Easier to maintain
- Better reusability (can include different checklists)

---

## Related Documents

- **YMD Format Spec**: `../ymd_format_spec.md`
- **Guidelines**: `./format-guidelines.md`
- **Examples**: `./examples.md`
- **Quick Reference**: `./quick-reference.md`
