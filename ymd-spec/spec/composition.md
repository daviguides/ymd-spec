# YMD/PMD Composition Specification (For LLMs)

## Purpose

This specification defines how **YMD** (orchestrators) and **PMD** (components) compose together to build structured, modular prompts.

## Core Composition Principles

### 1. YMD = Orchestrator
- **Aggregates** PMD components
- **Contains** metadata (`meta:`)
- **Defines** complete prompt structure
- **Includes** PMDs to build final output

### 2. PMD = Component
- **Building blocks** for YMDs
- **No metadata** (pure Markdown + Jinja2)
- **Can include** other PMDs recursively
- **Leaf or composite** patterns

### 3. Unlimited Nesting
- PMDs can include PMDs
- PMDs can include PMDs that include PMDs
- No depth restriction (but recommend max 5 levels)
- Watch for circular includes

### 4. Variable Flow
- YMD defines variables
- Variables flow down to included PMDs
- PMDs can use variables from parent context
- PMDs can define new variables for their includes

## Composition Patterns

### Pattern 1: Simple Composition (YMD → PMD)

**YMD orchestrator**:
```yaml
meta:
  id: simple_prompt
  kind: task
  version: 1.0.0
  title: Simple Task

system: |
  {% include "roles/expert.pmd" %}

user: |
  {{ task_description }}
```

**PMD component** (`roles/expert.pmd`):
```markdown
You are an expert in {{ domain }}.
```

**Rendered output** (with `domain="Python"`):
```
system:
You are an expert in Python.

user:
Analyze this code...
```

### Pattern 2: Multi-Level Composition (YMD → PMD → PMD)

**YMD orchestrator**:
```yaml
meta:
  id: code_review
  kind: review
  version: 1.0.0
  title: Code Review

system: |
  {% include "roles/senior_dev.pmd" %}
```

**Composite PMD** (`roles/senior_dev.pmd`):
```markdown
You are a senior software engineer.

{% include "../shared/principles.pmd" %}
{% include "../shared/communication_style.pmd" %}
```

**Leaf PMD** (`shared/principles.pmd`):
```markdown
Follow these core principles:
- {{ principle_1 }}
- {{ principle_2 }}
```

**Composition tree**:
```
YMD: code_review.ymd
  └─ system section
      └─ includes roles/senior_dev.pmd (composite)
          ├─ includes shared/principles.pmd (leaf)
          └─ includes shared/communication_style.pmd (leaf)
```

### Pattern 3: Multiple Includes in Section

**YMD orchestrator**:
```yaml
meta:
  id: comprehensive_review
  kind: review
  version: 1.0.0
  title: Comprehensive Code Review

system: |
  {% include "roles/senior_dev.pmd" %}

instructions: |
  {% include "checklists/code_quality.pmd" %}
  {% include "checklists/security.pmd" %}
  {% include "checklists/performance.pmd" %}

expected_output: |
  {% include "formats/review_comment.pmd" %}
```

**Composition tree**:
```
YMD: comprehensive_review.ymd
  ├─ system section
  │   └─ includes roles/senior_dev.pmd
  ├─ instructions section
  │   ├─ includes checklists/code_quality.pmd
  │   ├─ includes checklists/security.pmd
  │   └─ includes checklists/performance.pmd
  └─ expected_output section
      └─ includes formats/review_comment.pmd
```

### Pattern 4: Parameterized Composition

**YMD orchestrator**:
```yaml
meta:
  id: language_specific_review
  kind: review
  version: 1.0.0
  title: Language-Specific Code Review

system: |
  {% include "roles/expert.pmd" %}

instructions: |
  {% include "checklists/{{ language }}_specific.pmd" %}
```

**With variables**:
```yaml
language: python
domain: web_development
```

**Resolved includes**:
- `roles/expert.pmd` (static)
- `checklists/python_specific.pmd` (dynamic based on `language` variable)

### Pattern 5: Conditional Composition

**YMD orchestrator**:
```yaml
meta:
  id: adaptive_review
  kind: review
  version: 1.0.0
  title: Adaptive Code Review

system: |
  {% include "roles/senior_dev.pmd" %}

instructions: |
  {% include "checklists/code_quality.pmd" %}

  {% if security_focus %}
  {% include "checklists/security_deep.pmd" %}
  {% else %}
  {% include "checklists/security_basic.pmd" %}
  {% endif %}
```

**Composition changes based on `security_focus` variable**

## Include Path Resolution

### Relative to Current File

**Rule**: Includes are resolved relative to the **file containing the include statement**.

**Example**:
```
project/
├── prompts/
│   └── main.ymd
└── components/
    ├── roles/
    │   └── expert.pmd
    └── shared/
        └── principles.pmd
```

**In `prompts/main.ymd`**:
```yaml
system: |
  {% include "../components/roles/expert.pmd" %}
```

**In `components/roles/expert.pmd`**:
```markdown
{% include "../shared/principles.pmd" %}
```

**Resolution**:
1. `main.ymd` resolves `../components/roles/expert.pmd` → `/project/components/roles/expert.pmd`
2. `expert.pmd` resolves `../shared/principles.pmd` → `/project/components/shared/principles.pmd`

### Path Rules

- ✅ Use relative paths: `./`, `../`, `folder/`
- ✅ Navigate up: `../../shared/common.pmd`
- ✅ Navigate down: `subfolder/component.pmd`
- ❌ Avoid absolute paths: `/absolute/path/file.pmd`
- ❌ Avoid system paths: `~/user/file.pmd`

## Variable Propagation

### Parent → Child Flow

Variables defined in parent context are available in included PMDs.

**YMD defines variables**:
```yaml
meta:
  id: example
  kind: task
  version: 1.0.0
  title: Example

system: |
  {% include "roles/expert.pmd" %}
```

**With variables**:
```yaml
domain: Python
years_experience: 10
```

**PMD uses variables** (`roles/expert.pmd`):
```markdown
You are an expert in {{ domain }} with {{ years_experience }} years of experience.
```

**Rendered**:
```
You are an expert in Python with 10 years of experience.
```

### Variable Scope

```
YMD (defines: domain, language, strict_mode)
  └─ includes PMD A (uses: domain, language)
      └─ includes PMD A.1 (uses: domain)

  └─ includes PMD B (uses: strict_mode)
      └─ includes PMD B.1 (uses: domain, strict_mode)
```

**All included PMDs have access to variables defined in YMD**.

### Variable Inheritance

**YMD**:
```yaml
domain: Python
language: python
```

**Composite PMD**:
```markdown
Domain: {{ domain }}

{% set local_var = "value" %}

{% include "child.pmd" %}
```

**Child PMD**:
```markdown
Can access: {{ domain }}, {{ language }}, {{ local_var }}
```

## Circular Include Detection

### Problem: Infinite Loop

```
roles/a.pmd includes roles/b.pmd
roles/b.pmd includes roles/c.pmd
roles/c.pmd includes roles/a.pmd  ← CIRCULAR!
```

**Result**: Infinite recursion

### Detection

Renderers MUST detect circular includes:

```
Error: Circular include detected
Chain: roles/a.pmd → roles/b.pmd → roles/c.pmd → roles/a.pmd
```

### Prevention

- Track include chain during rendering
- Check if file already in chain before including
- Raise error if circular dependency found

## Composition Depth

### Recommended Max Depth: 5 Levels

```
Level 1: YMD
Level 2: YMD → PMD
Level 3: YMD → PMD → PMD
Level 4: YMD → PMD → PMD → PMD
Level 5: YMD → PMD → PMD → PMD → PMD
```

**Beyond 5 levels**: Consider refactoring for clarity

### Example: Deep Composition

```
main.ymd
  └─ roles/orchestrator.pmd          (Level 2)
      └─ roles/senior.pmd            (Level 3)
          └─ shared/principles.pmd   (Level 4)
              └─ shared/core.pmd     (Level 5)
```

**Warning**: Deep nesting harder to debug

## Composition Strategies

### Strategy 1: Flat Composition

**Characteristics**:
- YMD includes PMDs directly
- PMDs are mostly leaf components
- Minimal nesting

```yaml
meta:
  id: flat_example
  kind: task
  version: 1.0.0
  title: Flat Composition

system: |
  {% include "roles/expert.pmd" %}

instructions: |
  {% include "task1.pmd" %}
  {% include "task2.pmd" %}
  {% include "task3.pmd" %}
```

**Benefits**:
- ✅ Easy to understand
- ✅ Easy to debug
- ✅ Fast rendering

**Drawbacks**:
- ❌ Less code reuse
- ❌ More duplication

### Strategy 2: Hierarchical Composition

**Characteristics**:
- YMD includes composite PMDs
- PMDs include other PMDs
- Multi-level hierarchy

```yaml
meta:
  id: hierarchical_example
  kind: task
  version: 1.0.0
  title: Hierarchical Composition

system: |
  {% include "profiles/complete_expert.pmd" %}
```

**Where `profiles/complete_expert.pmd`**:
```markdown
{% include "../roles/senior_dev.pmd" %}
{% include "../roles/mentor.pmd" %}
{% include "../roles/reviewer.pmd" %}
```

**Benefits**:
- ✅ High code reuse
- ✅ DRY principle
- ✅ Easy to update shared components

**Drawbacks**:
- ❌ Harder to trace
- ❌ More files to manage

### Strategy 3: Hybrid Composition

**Characteristics**:
- Mix of flat and hierarchical
- Leaf PMDs for simple content
- Composite PMDs for complex content

```yaml
meta:
  id: hybrid_example
  kind: task
  version: 1.0.0
  title: Hybrid Composition

system: |
  {% include "roles/complete_profile.pmd" %}  ← composite

instructions: |
  {% include "task1.pmd" %}  ← leaf
  {% include "task2.pmd" %}  ← leaf

expected_output: |
  {% include "formats/structured_response.pmd" %}  ← composite
```

**Benefits**:
- ✅ Balance between clarity and reuse
- ✅ Flexible
- ✅ Pragmatic

## Best Practices

### DO:
- ✅ Document composition structure in YMD comments
- ✅ Use descriptive PMD filenames
- ✅ Organize PMDs by category
- ✅ Keep composition depth reasonable (≤5 levels)
- ✅ Use variables for flexibility
- ✅ Test composition chains
- ✅ Use leaf PMDs for simple content
- ✅ Use composite PMDs for complex aggregation

### DON'T:
- ❌ Don't create circular includes
- ❌ Don't nest too deeply without reason
- ❌ Don't hardcode values that should be variables
- ❌ Don't duplicate content across PMDs (create shared PMD)
- ❌ Don't use absolute paths in includes
- ❌ Don't forget to document expected variables
- ❌ Don't over-engineer simple prompts

## Validation Rules

### Include Chain Validation
- ✅ All included files must exist
- ✅ No circular dependencies
- ✅ Paths resolve correctly
- ✅ Depth reasonable (warn at 5+ levels)

### Variable Validation
- ✅ All used variables defined somewhere in chain
- ✅ Variables flow correctly through includes
- ✅ No undefined variable errors (or handle gracefully)

### Structure Validation
- ✅ YMD has valid `meta:` section
- ✅ PMDs have no `meta:` section
- ✅ All Jinja2 syntax valid
- ✅ All Markdown valid

## Error Handling

### Missing Include
```
Error: Include file not found
File: prompts/main.ymd:7
Include: {% include "roles/expert.pmd" %}
Resolved path: /project/prompts/roles/expert.pmd
Does not exist

Suggestion: Check path is relative to 'prompts/main.ymd'
```

### Circular Include
```
Error: Circular include detected
Chain:
  1. prompts/main.ymd
  2. roles/a.pmd (included from main.ymd:7)
  3. roles/b.pmd (included from a.pmd:3)
  4. roles/a.pmd (included from b.pmd:5) ← CIRCULAR

Fix: Remove circular dependency between roles/a.pmd and roles/b.pmd
```

### Deep Nesting Warning
```
Warning: Include depth exceeds recommended maximum
Current depth: 7 levels
Recommended: ≤5 levels

Chain:
  1. main.ymd
  2. profile.pmd
  3. senior.pmd
  4. expert.pmd
  5. principles.pmd
  6. core.pmd
  7. foundation.pmd

Consider: Flattening composition structure for clarity
```

### Undefined Variable
```
Error: Undefined variable in composition
File: roles/expert.pmd:3
Variable: {{ domain }}
Context: "You are an expert in {{ domain }}"

Variable not defined in:
  - main.ymd
  - Rendering context

Fix: Define 'domain' variable in YMD or pass in rendering context
```

## Composition Testing

### Test Include Resolution
```python
# Test all includes resolve correctly
def test_composition_resolution():
    ymd = load_ymd("prompts/main.ymd")
    includes = discover_includes(ymd)

    for include in includes:
        assert file_exists(include.resolved_path)
```

### Test No Circular Dependencies
```python
# Test no circular includes
def test_no_circular_includes():
    ymd = load_ymd("prompts/main.ymd")

    try:
        render(ymd)
    except CircularIncludeError as e:
        pytest.fail(f"Circular include detected: {e.chain}")
```

### Test Variable Coverage
```python
# Test all variables defined
def test_variable_coverage():
    ymd = load_ymd("prompts/main.ymd")
    required_vars = discover_variables(ymd)
    provided_vars = get_provided_variables(ymd)

    undefined = required_vars - provided_vars
    assert not undefined, f"Undefined variables: {undefined}"
```

## Related Specifications

- **YMD Format**: See `ymd_format.md`
- **PMD Format**: See `pmd_format.md`
- **Quick Reference**: See `context/quick-reference.md`
- **Examples**: See `context/examples.md`
