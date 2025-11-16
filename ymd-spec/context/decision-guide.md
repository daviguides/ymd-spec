# YMD/PMD Decision Guide

This guide helps you make design decisions when working with YMD/PMD formats.

**For format rules**, see:
- `@../spec/ymd_format.md` - YMD format specification
- `@../spec/pmd_format.md` - PMD format specification
- `@../spec/composition.md` - Composition rules

---

## When to Use Custom Sections

### Decision Tree

```
Is this a standard prompt pattern (system/instructions/user)?
├─ YES → Use standard sections
│         Example: Simple task prompts
│
└─ NO → Does your domain have specific concerns?
          ├─ YES → Use custom sections for clarity
          │         Example: api_requirements, security_checklist
          │
          └─ NO → Could it fit in standard sections with includes?
                    ├─ YES → Use standard sections + PMD includes
                    │         Example: instructions section includes multiple PMDs
                    │
                    └─ NO → Use custom sections
                              Example: Domain-specific requirements
```

### Use Standard Sections When

✅ **Your prompt fits common patterns**:
```yaml
meta:
  id: simple_task
  kind: task
  version: 1.0.0
  title: Simple Task

system: |
  {% include "roles/expert.pmd" %}

instructions: |
  {% include "tasks/analyze.pmd" %}

user: |
  {{ task_description }}
```

### Use Custom Sections When

✅ **You need domain-specific organization**:
```yaml
meta:
  id: api_designer
  kind: api
  version: 1.0.0
  title: API Designer

system: |
  {% include "roles/api_architect.pmd" %}

api_principles: |
  {% include "principles/rest.pmd" %}

security_requirements: |
  {% include "security/api_security.pmd" %}

performance_requirements: |
  - Response time: < {{ max_response_time }}ms
  - Throughput: > {{ min_throughput }} req/s

user: |
  Design API for: {{ requirement }}
```

✅ **You need clearer separation of concerns**:
```yaml
# Instead of cramming everything into "instructions"
instructions: |
  Do task 1
  Security: check X, Y, Z
  Performance: ensure A, B, C
  Output as JSON

# Use custom sections for clarity
task_steps: |
  {% include "tasks/main_steps.pmd" %}

security_validation: |
  {% include "checklists/security.pmd" %}

performance_criteria: |
  {% include "requirements/performance.pmd" %}

expected_output: |
  {% include "formats/json_response.pmd" %}
```

### Custom Section Examples by Domain

**API Design**:
- `api_principles`
- `endpoint_requirements`
- `authentication_strategy`
- `rate_limiting`

**Code Review**:
- `review_focus`
- `quality_criteria`
- `security_criteria`
- `performance_criteria`

**Documentation**:
- `target_audience`
- `documentation_structure`
- `style_guide`
- `examples_requirements`

**Testing**:
- `testing_framework`
- `test_categories`
- `coverage_requirements`
- `test_data`

---

## When to Split Components

### Decision Tree

```
Is this PMD getting large (>150 lines)?
├─ YES → Does it have distinct responsibilities?
│         ├─ YES → Split into multiple PMDs
│         │         Strategy: One PMD per responsibility
│         │
│         └─ NO → Keep as single PMD
│                   (Large but cohesive is OK)
│
└─ NO → Is this content reused in multiple places?
          ├─ YES → Extract to separate PMD
          │         Strategy: Create shared component
          │
          └─ NO → Keep inline or as single PMD
```

### Split When

✅ **Multiple distinct responsibilities**:
```markdown
<!-- ❌ BEFORE: One large PMD -->
<!-- roles/code_reviewer.pmd -->
You are a code reviewer.

## Principles
[50 lines of principles]

## Communication Style
[50 lines of communication style]

## Review Methodology
[50 lines of methodology]

<!-- ✅ AFTER: Split into focused PMDs -->
<!-- roles/code_reviewer.pmd -->
You are a code reviewer.

{% include "../shared/code_principles.pmd" %}
{% include "../shared/communication_style.pmd" %}
{% include "../shared/review_methodology.pmd" %}
```

✅ **Reused across multiple YMDs**:
```markdown
<!-- If this content appears in multiple YMDs -->
## Security Principles
- Validate all inputs
- Use parameterized queries
- Encrypt sensitive data
- Follow principle of least privilege

<!-- Extract to shared PMD -->
<!-- shared/security_principles.pmd -->
## Security Principles
- Validate all inputs
- Use parameterized queries
- Encrypt sensitive data
- Follow principle of least privilege
```

✅ **Domain-specific variations needed**:
```markdown
<!-- Instead of one large PMD with conditionals -->
{% if language == "python" %}
  [Python security rules]
{% elif language == "javascript" %}
  [JavaScript security rules]
{% endif %}

<!-- Create language-specific PMDs -->
{% include "security/{{ language }}_security.pmd" %}
```

### Keep Together When

✅ **Content is cohesive and short**:
```markdown
<!-- roles/mentor.pmd -->
You are a mentor helping junior developers.

Your approach:
- Be encouraging and supportive
- Explain concepts clearly
- Provide examples
- Ask guiding questions
```

✅ **Splitting would create too much indirection**:
```markdown
<!-- Too much splitting -->
{% include "a.pmd" %}  # 2 lines
{% include "b.pmd" %}  # 3 lines
{% include "c.pmd" %}  # 2 lines

<!-- Better: keep inline -->
[7 lines of cohesive content]
```

---

## Composition Depth Guidelines

### Decision Tree

```
How many levels deep is your composition?

1-2 levels (YMD → PMD)
├─ ✅ Ideal for most use cases
└─ Example: YMD includes roles/expert.pmd

3 levels (YMD → PMD → PMD)
├─ ✅ Good for modular designs
└─ Example: YMD → roles/senior.pmd → shared/principles.pmd

4-5 levels (YMD → PMD → PMD → PMD → PMD)
├─ ⚠️ Use with caution
├─ Ask: Could this be flattened?
└─ Example: Complex enterprise workflows

6+ levels
├─ ❌ Too deep - refactor needed
└─ Red flag: Hard to debug and maintain
```

### When to Flatten

✅ **Flatten when composition is purely for organization**:
```markdown
<!-- ❌ Over-engineered -->
YMD
└─ orchestrator.pmd
    └─ coordinator.pmd
        └─ wrapper.pmd
            └─ actual_content.pmd  # Just 10 lines

<!-- ✅ Flattened -->
YMD
└─ actual_content.pmd
```

### When to Nest

✅ **Nest when there's genuine reuse at each level**:
```markdown
<!-- ✅ Good nesting - each level reused -->
code_review.ymd
└─ roles/senior_dev.pmd         (used by multiple YMDs)
    ├─ shared/code_principles.pmd   (used by multiple roles)
    └─ shared/communication.pmd     (used by multiple roles)
```

✅ **Nest for conditional composition**:
```markdown
<!-- ✅ Good nesting - conditional logic -->
adaptive.ymd
└─ profiles/complete_expert.pmd
    ├─ roles/expert.pmd          (if expert_mode)
    ├─ roles/mentor.pmd          (if teaching_mode)
    └─ roles/reviewer.pmd        (if review_mode)
```

---

## Section Organization Strategies

### By Concern

**When to use**: Multi-faceted requirements

```yaml
meta:
  id: system_designer
  kind: design
  version: 1.0.0
  title: System Designer

# Functional concerns
functional_requirements: |
  {{ requirements }}

# Non-functional concerns
performance_requirements: |
  {{ performance }}

security_requirements: |
  {{ security }}

scalability_requirements: |
  {{ scalability }}
```

**Benefits**:
- Clear separation of concerns
- Easy to add/remove concerns
- Team members can own specific concerns

### By Phase

**When to use**: Sequential workflows

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

**Benefits**:
- Mirrors actual workflow
- Clear progression
- Easy to understand sequence

### By Stakeholder

**When to use**: Multiple perspectives needed

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

**Benefits**:
- Captures all perspectives
- Clear ownership
- Comprehensive coverage

---

## Leaf vs Composite PMD

### Decision Tree

```
Does this PMD need to include other PMDs?

NO → Create Leaf PMD
├─ Pure content
├─ No includes
└─ Example: roles/expert.pmd with just role definition

YES → Why include others?
      ├─ Aggregate related content → Create Composite PMD
      │   Example: roles/complete_profile.pmd includes multiple roles
      │
      ├─ Conditional inclusion → Create Bridge PMD
      │   Example: routes/adaptive.pmd includes based on conditions
      │
      └─ Reuse common patterns → Create Composite PMD
          Example: workflows/standard.pmd includes shared steps
```

### Leaf PMD Pattern

**When to use**:
- Self-contained content
- No dependencies on other PMDs
- Pure content delivery

```markdown
<!-- roles/expert.pmd -->
{# Expected variables: domain, years_experience #}

You are an expert in **{{ domain }}** with {{ years_experience }}+ years of experience.

Your expertise includes:
- Deep technical knowledge
- Best practices
- Common pitfalls
- Industry standards
```

### Composite PMD Pattern

**When to use**:
- Aggregating related components
- Building higher-level abstractions
- Reusing common combinations

```markdown
<!-- roles/senior_full_stack_dev.pmd -->
{# Composite role combining multiple specializations #}

You are a senior full-stack developer.

## Backend Expertise
{% include "roles/backend_expert.pmd" %}

## Frontend Expertise
{% include "roles/frontend_expert.pmd" %}

## DevOps Knowledge
{% include "roles/devops_expert.pmd" %}

## Communication Style
{% include "../shared/senior_communication.pmd" %}
```

### Bridge PMD Pattern

**When to use**:
- Conditional routing
- Dynamic composition
- Adaptive behavior

```markdown
<!-- roles/adaptive_assistant.pmd -->
{# Bridge PMD that routes to appropriate role #}

{% if experience_level == "beginner" %}
{% include "roles/mentor.pmd" %}
{% elif experience_level == "intermediate" %}
{% include "roles/senior_dev.pmd" %}
{% else %}
{% include "roles/expert.pmd" %}
{% endif %}
```

---

## Variable Definition Strategy

### Decision: Where to Define Variables

```
Who provides the variable value?

User at runtime
├─ Document in YMD with comments
└─ Pass via rendering context

YMD author
├─ Can be hardcoded in YMD
└─ Or specified as defaults

PMD defines
├─ Use Jinja2 {% set %}
└─ Scope is PMD and its includes
```

### Document in YMD

```yaml
{# Expected variables (passed at render time):
   - domain: string - Area of expertise
   - language: string - Programming language
   - strict_mode: boolean - Use strict validation
#}

meta:
  id: example
  kind: task
  version: 1.0.0
  title: Example

system: |
  Expert in {{ domain }}, using {{ language }}.
```

### Hardcode in YMD

```yaml
meta:
  id: python_code_reviewer
  kind: review
  version: 1.0.0
  title: Python Code Reviewer

system: |
  {% set language = "python" %}
  {% set strict_mode = true %}
  {% include "roles/expert.pmd" %}
```

### Define in PMD

```markdown
<!-- roles/senior_dev.pmd -->
{% set years_experience = 10 %}
{% set seniority_level = "senior" %}

You are a {{ seniority_level }} developer with {{ years_experience }}+ years of experience.
```

---

## Include Path Strategy

### Decision: Absolute vs Relative

```
❌ NEVER use absolute paths
   /absolute/path/to/file.pmd

✅ ALWAYS use relative paths
   ../path/to/file.pmd
   ./file.pmd
   folder/file.pmd
```

### Relative Path Patterns

**Same directory**:
```markdown
<!-- In components/roles/expert.pmd -->
{% include "mentor.pmd" %}
```

**Parent directory**:
```markdown
<!-- In components/roles/expert.pmd -->
{% include "../shared/principles.pmd" %}
```

**Sibling directory**:
```markdown
<!-- In components/roles/expert.pmd -->
{% include "../checklists/quality.pmd" %}
```

**Deep nesting**:
```markdown
<!-- In components/github/pr/analyzer.pmd -->
{% include "../../shared/principles.pmd" %}
{% include "../checklists/pr_checklist.pmd" %}
```

---

## Error Prevention Checklist

### Before Creating New YMD

- [ ] Does similar YMD already exist? (avoid duplication)
- [ ] Can I reuse existing PMDs? (maximize reuse)
- [ ] Are section names descriptive? (use custom if needed)
- [ ] Are all variables documented? (comment expected vars)
- [ ] Does file name match purpose? (descriptive snake_case)

### Before Creating New PMD

- [ ] Is this content reused? (if not, consider inline in YMD)
- [ ] Is responsibility single and clear? (not doing too much)
- [ ] Can I reuse existing PMDs? (compose, don't duplicate)
- [ ] Are variables documented? (comment expected vars)
- [ ] Is file name descriptive? (not generic)

### Before Deep Nesting

- [ ] Is each level genuinely reused? (not just organization)
- [ ] Is depth ≤5 levels? (deeper = harder to debug)
- [ ] Could this be flattened? (simpler is better)
- [ ] Are paths clear? (easy to follow includes)

---

## Quick Decision Flowcharts

### Should I Create a New PMD?

```
Is this content reused in multiple places?
├─ YES → Create PMD
└─ NO → Is it >50 lines?
          ├─ YES → Consider PMD (easier to maintain)
          └─ NO → Keep inline in YMD
```

### Should I Use a Custom Section?

```
Does this fit standard sections (system/instructions/user)?
├─ YES → Use standard sections
└─ NO → Will custom section make intent clearer?
          ├─ YES → Use custom section
          └─ NO → Try fitting in standard with includes
```

### Should I Split This PMD?

```
Is PMD >150 lines?
├─ YES → Does it have multiple responsibilities?
│         ├─ YES → Split by responsibility
│         └─ NO → Keep as-is (large but cohesive OK)
└─ NO → Is content reused separately?
          ├─ YES → Extract reused parts
          └─ NO → Keep as-is
```

---

## Common Mistakes to Avoid

### ❌ Over-Engineering

**Problem**:
```markdown
<!-- Too many layers for simple content -->
YMD
└─ orchestrator.pmd
    └─ coordinator.pmd
        └─ wrapper.pmd
            └─ hello_world.pmd  # "Hello world"
```

**Solution**:
```yaml
# Just inline it
user: |
  Hello world
```

### ❌ Under-Engineering

**Problem**:
```yaml
# Giant 500-line YMD with everything inline
system: |
  [200 lines of role definition]
  [150 lines of principles]
  [150 lines of examples]
```

**Solution**:
```yaml
system: |
  {% include "roles/complete_profile.pmd" %}
  {% include "shared/principles.pmd" %}
  {% include "examples/samples.pmd" %}
```

### ❌ Generic Names

**Problem**:
```
components/
├── role.pmd        # Which role?
├── checklist.pmd   # Which checklist?
└── format.pmd      # Which format?
```

**Solution**:
```
components/
├── roles/
│   └── senior_developer.pmd
├── checklists/
│   └── code_quality.pmd
└── formats/
    └── json_response.pmd
```

---

## Related Documents

**Format Specifications**:
- `@../spec/ymd_format.md` - YMD format details
- `@../spec/pmd_format.md` - PMD format details
- `@../spec/composition.md` - Composition rules

**Applied Knowledge**:
- `@./examples.md` - Complete working examples
- `@./project-guide.md` - Project organization patterns
