# YMD Creation Examples

**Purpose**: Complete, practical examples for creating YMD orchestrator files.

**For specification**: See @../ymd_format_spec.md

---

## Example 1: Code Review Assistant

### Requirements
- Review code for quality, security, performance
- Provide actionable feedback
- Support multiple languages

### Generated YMD

**File**: `prompts/code_review_assistant.ymd`

```yaml
{# Expected variables:
   - project_type: string - Type of project (e.g., "web application")
   - primary_language: string - Main programming language
   - language: string - Language of code to review
   - code: string - Code to review
#}

meta:
  id: code_review_assistant
  kind: review
  version: 1.0.0
  title: Comprehensive Code Review Assistant

system: |
  {% include "roles/senior_developer.pmd" %}

context: |
  Reviewing {{ primary_language }} code for {{ project_type }}.

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
  ```
```

### Required Components
- `roles/senior_developer.pmd`
- `checklists/code_quality.pmd`
- `checklists/security_review.pmd`
- `checklists/performance_review.pmd`
- `formats/review_comment.pmd`

### Usage Example
```python
variables = {
    "project_type": "web application",
    "primary_language": "Python",
    "language": "python",
    "code": "def process(data): ..."
}
```

---

## Example 2: API Design Assistant

### Requirements
- Design RESTful APIs
- Follow best practices
- Include security considerations

### Generated YMD

**File**: `prompts/api_design_assistant.ymd`

```yaml
{# Expected variables:
   - domain: string - Domain/business area
   - target_audience: string - API consumers
   - auth_method: string - Authentication method
   - requirement: string - API requirement description
#}

meta:
  id: api_design_assistant
  kind: api_design
  version: 1.0.0
  title: RESTful API Design Assistant

system: |
  {% include "roles/api_architect.pmd" %}

context: |
  Designing API for: {{ domain }}
  Target users: {{ target_audience }}

api_principles: |
  {% include "principles/rest_principles.pmd" %}

security_requirements: |
  {% include "security/api_security.pmd" %}

expected_output: |
  {% include "formats/api_specification.pmd" %}

user: |
  Design API for: {{ requirement }}
```

### Required Components
- `roles/api_architect.pmd`
- `principles/rest_principles.pmd`
- `security/api_security.pmd`
- `formats/api_specification.pmd`

---

## Example 3: Documentation Generator

### Requirements
- Generate technical documentation
- Include examples
- Target specific audience level

### Generated YMD

**File**: `prompts/documentation_generator.ymd`

```yaml
{# Expected variables:
   - audience_level: string - "beginner" | "intermediate" | "advanced"
   - language: string - Programming language
   - code: string - Code to document
   - doc_type: string - Type of documentation
#}

meta:
  id: documentation_generator
  kind: documentation
  version: 1.0.0
  title: Technical Documentation Generator

system: |
  {% include "roles/technical_writer.pmd" %}

target_audience: |
  Documentation for {{ audience_level }} developers.

documentation_structure: |
  {% include "structures/{{ doc_type }}_structure.pmd" %}

style_guide: |
  {% include "styles/documentation_style.pmd" %}

expected_output: |
  {% include "formats/markdown_documentation.pmd" %}

user: |
  Generate documentation for:
  ```{{ language }}
  {{ code }}
  ```
```

### Required Components
- `roles/technical_writer.pmd`
- `structures/[doc_type]_structure.pmd` (dynamic)
- `styles/documentation_style.pmd`
- `formats/markdown_documentation.pmd`

---

## Example 4: Simple Task Prompt

### Requirements
- Single focused task
- Minimal structure
- Quick to use

### Generated YMD

**File**: `prompts/simple_task.ymd`

```yaml
{# Expected variables:
   - task: string - Task description
#}

meta:
  id: simple_task
  kind: task
  version: 1.0.0
  title: Simple Task Assistant

user: |
  {{ task }}
```

### Required Components
None (minimal YMD)

### Usage Example
```python
variables = {
    "task": "Explain how binary search works"
}
```

---

## Example 5: Conditional/Adaptive Prompt

### Requirements
- Adapt behavior based on context
- Different roles for different scenarios
- Dynamic includes

### Generated YMD

**File**: `prompts/adaptive_assistant.ymd`

```yaml
{# Expected variables:
   - experience_level: string - "beginner" | "intermediate" | "expert"
   - task_type: string - "learning" | "debugging" | "design"
   - user_request: string - User's request
#}

meta:
  id: adaptive_assistant
  kind: adaptive
  version: 1.0.0
  title: Context-Adaptive Assistant

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
  {{ user_request }}
```

### Required Components
- `roles/mentor.pmd`
- `roles/senior_dev.pmd`
- `roles/expert.pmd`
- `tasks/teaching_mode.pmd`
- `tasks/debugging_mode.pmd`
- `tasks/general_mode.pmd`

---

## Example 6: Multi-Language Support

### Requirements
- Support multiple programming languages
- Language-specific checklists
- Dynamic content

### Generated YMD

**File**: `prompts/multi_language_review.ymd`

```yaml
{# Expected variables:
   - language: string - Programming language (python, javascript, go, etc.)
   - code: string - Code to review
#}

meta:
  id: multi_language_review
  kind: review
  version: 1.0.0
  title: Multi-Language Code Reviewer

system: |
  {% include "roles/polyglot_developer.pmd" %}

language_specific: |
  {% include "languages/{{ language }}_guidelines.pmd" %}

review_focus: |
  {% include "checklists/universal_quality.pmd" %}
  {% include "checklists/{{ language }}_specific.pmd" %}

expected_output: |
  {% include "formats/review_comment.pmd" %}

user: |
  Review this {{ language }} code:
  ```{{ language }}
  {{ code }}
  ```
```

### Required Components
- `roles/polyglot_developer.pmd`
- `languages/python_guidelines.pmd` (and others)
- `checklists/universal_quality.pmd`
- `checklists/python_specific.pmd` (and others)
- `formats/review_comment.pmd`

---

## Example 7: Complex Multi-Stage Workflow

### Requirements
- Multiple phases (preparation, execution, validation)
- Different content per phase
- Comprehensive workflow

### Generated YMD

**File**: `prompts/complex_workflow.ymd`

```yaml
{# Expected variables:
   - project_context: string - Project background
   - requirements: string - What needs to be done
   - quality_threshold: string - Quality standards
#}

meta:
  id: complex_workflow
  kind: workflow
  version: 1.0.0
  title: Multi-Stage Development Workflow

system: |
  {% include "roles/senior_architect.pmd" %}

project_context: |
  {{ project_context }}

preparation_phase: |
  {% include "workflow/preparation.pmd" %}

execution_phase: |
  {% include "workflow/execution.pmd" %}

validation_phase: |
  {% include "workflow/validation.pmd" %}

quality_criteria: |
  Quality threshold: {{ quality_threshold }}
  {% include "checklists/quality_gates.pmd" %}

expected_output: |
  {% include "formats/workflow_deliverable.pmd" %}

user: |
  Requirements:
  {{ requirements }}
```

### Required Components
- `roles/senior_architect.pmd`
- `workflow/preparation.pmd`
- `workflow/execution.pmd`
- `workflow/validation.pmd`
- `checklists/quality_gates.pmd`
- `formats/workflow_deliverable.pmd`

---

## Example 8: Testing Prompt with Categories

### Requirements
- Different test types
- Coverage criteria
- Test generation

### Generated YMD

**File**: `prompts/test_generator.ymd`

```yaml
{# Expected variables:
   - language: string - Programming language
   - code: string - Code to test
   - test_types: list - Types of tests (unit, integration, e2e)
   - coverage_target: int - Coverage percentage goal
#}

meta:
  id: test_generator
  kind: testing
  version: 1.0.0
  title: Comprehensive Test Generator

system: |
  {% include "roles/test_engineer.pmd" %}

test_philosophy: |
  {% include "testing/test_philosophy.pmd" %}

test_categories: |
  {% for test_type in test_types %}
  ### {{ test_type }} Tests
  {% include "testing/{{ test_type }}_guidelines.pmd" %}
  {% endfor %}

coverage_requirements: |
  Target coverage: {{ coverage_target }}%
  {% include "testing/coverage_criteria.pmd" %}

expected_output: |
  {% include "formats/test_suite.pmd" %}

user: |
  Generate tests for:
  ```{{ language }}
  {{ code }}
  ```
```

### Required Components
- `roles/test_engineer.pmd`
- `testing/test_philosophy.pmd`
- `testing/unit_guidelines.pmd`
- `testing/integration_guidelines.pmd`
- `testing/e2e_guidelines.pmd`
- `testing/coverage_criteria.pmd`
- `formats/test_suite.pmd`

---

## Common Patterns Summary

### Minimal Pattern (Example 4)
- Just `meta` + `user`
- No includes
- Single simple task

### Standard Pattern (Examples 1-3)
- `meta` + `system` + domain sections + `expected_output` + `user`
- Multiple includes
- Complete workflow

### Conditional Pattern (Example 5)
- Uses `{% if %}` blocks
- Dynamic includes based on variables
- Adaptive behavior

### Parameterized Pattern (Example 6)
- Variables in include paths
- `{% include "path/{{ variable }}.pmd" %}`
- Supports many variations

### Multi-Stage Pattern (Example 7)
- Phase-based sections
- Separate includes per phase
- Complex workflows

### Iteration Pattern (Example 8)
- Uses `{% for %}` loops
- Dynamic repetition
- List-based processing
