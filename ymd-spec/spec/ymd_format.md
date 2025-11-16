# YMD Format Specification (For LLMs)

## Purpose

YMD (YAML + Markdown + Jinja2) is a format for **structured prompt manifests** that act as **orchestrators** composing modular PMD components.

## File Extension

`.ymd` or `.yamd`

## Structure

YMD files have two main parts:

### 1. YAML Metadata (Required)

```yaml
meta:
  id: unique_identifier
  kind: prompt_type
  version: semver
  title: Human-readable title
```

**Required fields under `meta:`**:
- `id` (string): Unique identifier (snake_case recommended)
- `kind` (string): Prompt type/category
- `version` (string): Semantic versioning (MAJOR.MINOR.PATCH)
- `title` (string): Human-readable description

### 2. Sections (Customizable)

Sections use YAML block scalar syntax (`|`):

```yaml
section_name: |
  Markdown content here
  {% include "path.pmd" %}
  {{ variable }}
```

**Standard sections** (common patterns, not required):
- `system` - Role/persona definition
- `instructions` - Step-by-step tasks
- `expected_output` - Output format specification
- `developer` - Implementation notes
- `user` - User input template

**Custom sections**:
- **Any valid YAML key name can be a section**
- Examples: `context`, `constraints`, `examples`, `validation_rules`
- Same syntax: `section_name: |`
- Same Markdown + Jinja2 support

## Complete Example

```yaml
meta:
  id: code_reviewer
  kind: code_analysis
  version: 1.0.0
  title: Code Review Assistant

system: |
  You are a **code review specialist** with expertise in:
  {% include "roles/senior_dev.pmd" %}

instructions: |
  {% include "checklists/code_quality.pmd" %}
  {% include "checklists/security.pmd" %}

context: |
  This code is part of {{ project_name }}.
  Target audience: {{ target_audience }}

constraints: |
  - Maximum response time: {{ max_response_time }}ms
  - Focus areas: {{ focus_areas }}

expected_output: |
  {% include "formats/review_comment.pmd" %}

user: |
  Review this {{ language }} code:
  \`\`\`{{ language }}
  {{ code }}
  \`\`\`
```

## Jinja2 Features

### Variables
```yaml
user: |
  Analyze {{ code }} for {{ language }}.
```

### Includes
```yaml
system: |
  {% include "roles/expert.pmd" %}
```

**Include path resolution**:
- Relative to current YMD file's directory
- Supports nested folders: `components/roles/expert.pmd`
- Can include PMDs that include other PMDs (unlimited depth)

### Control Flow
```yaml
instructions: |
  {% if strict_mode %}
  Apply strict validation rules.
  {% else %}
  Apply relaxed validation rules.
  {% endif %}

  {% for step in steps %}
  - {{ step }}
  {% endfor %}
```

### Comments
```yaml
system: |
  {# This is a Jinja2 comment, won't appear in output #}
  You are an expert.
```

## Role as Orchestrator

YMD files **orchestrate** PMD components to build complete prompts:

```
YMD File (orchestrator)
  ├─ system section
  │   └─ includes roles/expert.pmd
  │       └─ includes shared/principles.pmd
  ├─ instructions section
  │   ├─ includes tasks/analysis.pmd
  │   └─ includes checklists/validation.pmd
  └─ user section
      └─ includes formats/input_template.pmd
```

## Key Principles

### 1. YMD = Orchestrator
- **Aggregates** PMD components
- **Contains** YAML metadata
- **Defines** complete prompt structure

### 2. Sections are Customizable
- **Not limited** to standard sections (system, instructions, user)
- **Any YAML key** can be a section
- **Same syntax** for all sections: `key: |`

### 3. Includes PMDs for Composition
- **Reusable components** via `{% include "path.pmd" %}`
- **Nested includes** supported (PMDs can include PMDs)
- **Variables** passed to included PMDs

## Validation Rules

### Metadata Validation
- ✅ `id` must be unique across project
- ✅ `kind` should follow project conventions
- ✅ `version` must be valid semver
- ✅ `title` should be descriptive

### Section Validation
- ✅ At least one section required
- ✅ Section names must be valid YAML keys
- ✅ Block scalar syntax (`|`) required for multi-line content
- ✅ Jinja2 syntax must be valid

### Include Validation
- ✅ Included files must exist
- ✅ Include paths are relative to YMD file's directory
- ✅ Circular includes not allowed
- ✅ Included PMDs must be valid

## Common Patterns

### Minimal YMD
```yaml
meta:
  id: simple_prompt
  kind: generic
  version: 1.0.0
  title: Simple Prompt

user: |
  {{ input }}
```

### Standard Sections YMD
```yaml
meta:
  id: complete_prompt
  kind: task
  version: 1.0.0
  title: Complete Task Prompt

system: |
  You are an expert in {{ domain }}.

instructions: |
  1. {{ step_1 }}
  2. {{ step_2 }}

user: |
  {{ task_description }}
```

### Custom Sections YMD
```yaml
meta:
  id: api_design
  kind: api
  version: 1.0.0
  title: API Design Prompt

context: |
  Target audience: {{ audience }}
  Use case: {{ use_case }}

constraints: |
  - RESTful principles
  - JSON only
  - Max {{ max_response_time }}ms

validation_rules: |
  - {{ rule_1 }}
  - {{ rule_2 }}

user: |
  Design API for: {{ requirement }}
```

### Composition-Heavy YMD
```yaml
meta:
  id: code_review_pr
  kind: gh_pr
  version: 1.0.0
  title: GitHub PR Code Review

system: |
  {% include "roles/senior_maintainer.pmd" %}

instructions: |
  {% include "gh_pr/analysis_steps.pmd" %}
  {% include "checklists/code_quality.pmd" %}
  {% include "checklists/security.pmd" %}

expected_output: |
  {% include "formats/pr_review.pmd" %}
  {% include "examples/pr_review_example.pmd" %}

user: |
  {% include "gh_pr/context.pmd" %}

  Diff:
  \`\`\`diff
  {{ diff }}
  \`\`\`
```

## Best Practices

### DO:
- ✅ Use descriptive `id` and `title`
- ✅ Follow semantic versioning for `version`
- ✅ Use includes for reusable content
- ✅ Use custom sections when standard ones don't fit
- ✅ Keep YMD files as orchestrators (thin, mostly includes)
- ✅ Use variables for dynamic content
- ✅ Document expected variables in comments

### DON'T:
- ❌ Don't put large content directly in YMD (use PMD includes)
- ❌ Don't duplicate content across YMD files (create PMD component)
- ❌ Don't use circular includes (PMD A → PMD B → PMD A)
- ❌ Don't hardcode values that should be variables
- ❌ Don't forget to update version on changes

## YMD Creation Checklist

When creating a new YMD file:

- [ ] Define metadata (id, kind, version, title)
- [ ] Identify sections needed (standard or custom)
- [ ] Create/reuse PMD components for content
- [ ] Use `{% include %}` to compose PMDs
- [ ] Define variables with `{{ }}`
- [ ] Add Jinja2 logic if needed (`{% if %}`, `{% for %}`)
- [ ] Validate all includes exist
- [ ] Test with sample variables
- [ ] Document expected variables

## Error Messages

When YMD is invalid:

### Missing Metadata
```
Error: YMD file missing required field 'id'
File: prompts/my_prompt.ymd
```

### Invalid Version
```
Error: Invalid semver in 'version' field: '1.0'
Expected: MAJOR.MINOR.PATCH (e.g., '1.0.0')
File: prompts/my_prompt.ymd
```

### Missing Include
```
Error: Included file not found: 'roles/expert.pmd'
Referenced in: prompts/my_prompt.ymd:7
```

### Circular Include
```
Error: Circular include detected
Chain: prompts/a.ymd → components/b.pmd → components/c.pmd → components/b.pmd
```

## Related Specifications

- **PMD Format**: See `pmd_format.md`
- **Composition Rules**: See `composition.md`
- **Quick Reference**: See `context/quick-reference.md`
- **Examples**: See `context/examples.md`
