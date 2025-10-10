# YMD/PMD Format Guidelines

Complete guidelines for working with YMD and PMD formats.

## Quick Overview

**YMD** (YAML + Markdown + Jinja2) = **Orchestrator** files with metadata + sections
**PMD** (Prompt Markdown + Jinja2) = **Component** files, pure Markdown + Jinja2

---

## YMD Format Guidelines

### Structure

```yaml
# Metadata (required, grouped under meta:)
meta:
  id: unique_identifier
  kind: prompt_type
  version: semver
  title: Human-readable title

# Sections (customizable)
section_name: |
  Markdown content with {{ variables }}
  {% include "component.pmd" %}
```

### Metadata Rules

**Required fields**:
- `meta.id` - Unique identifier (snake_case)
- `meta.kind` - Prompt type/category
- `meta.version` - Semantic versioning (MAJOR.MINOR.PATCH)
- `meta.title` - Human-readable description

**Example**:
```yaml
meta:
  id: code_reviewer
  kind: review
  version: 1.0.0
  title: Code Review Assistant
```

### Sections

**Standard sections** (common, not required):
- `system` - Role/persona definition
- `instructions` - Step-by-step tasks
- `expected_output` - Output format
- `developer` - Implementation notes
- `user` - User input template

**Custom sections** (fully supported):
- Any valid YAML key name
- Same syntax: `key: |`
- Examples: `context`, `constraints`, `examples`, `validation_rules`

**Example with custom sections**:
```yaml
meta:
  id: api_designer
  kind: api
  version: 1.0.0
  title: API Designer

context: |
  Target: {{ audience }}
  Domain: {{ domain }}

constraints: |
  - RESTful
  - JSON only
  - Max {{ timeout }}ms

validation_rules: |
  - {{ rule_1 }}
  - {{ rule_2 }}
```

### Jinja2 in YMD

**Variables**:
```yaml
user: |
  Analyze {{ code }} for {{ language }}.
```

**Includes**:
```yaml
system: |
  {% include "roles/expert.pmd" %}
```

**Control flow**:
```yaml
instructions: |
  {% if strict_mode %}
  Apply strict rules.
  {% else %}
  Apply relaxed rules.
  {% endif %}
```

---

## PMD Format Guidelines

### Structure

```markdown
<!-- Optional comment -->

Markdown content with **formatting**.

{{ variable }}

{% include "other.pmd" %}
```

### Key Rules

- ✅ Pure Markdown + Jinja2
- ✅ No YAML metadata
- ✅ No `meta:` section
- ✅ Can include other PMDs
- ✅ Leaf or composite patterns

### PMD Categories

**Roles** (`roles/`):
```markdown
You are a {{ role_type }} with {{ years }} years of experience.
```

**Checklists** (`checklists/`):
```markdown
## {{ checklist_title }}
- [ ] {{ item_1 }}
- [ ] {{ item_2 }}
```

**Formats** (`formats/`):
```markdown
Return in {{ format_type }}:

\`\`\`{{ format_type }}
{{ template }}
\`\`\`
```

**Shared** (`shared/`):
```markdown
Common reusable content.

{{ shared_content }}
```

---

## Composition Guidelines

### YMD Orchestrates PMDs

```
YMD (main.ymd)
  ├─ system: includes roles/expert.pmd
  ├─ instructions: includes tasks/analyze.pmd
  └─ user: includes formats/input.pmd
```

### PMDs Compose Recursively

```
PMD (roles/senior_dev.pmd)
  ├─ includes shared/principles.pmd
  └─ includes shared/style.pmd
```

### Composition Tree Example

```
code_review.ymd
  ├─ system section
  │   └─ roles/senior_dev.pmd
  │       ├─ shared/principles.pmd
  │       └─ shared/style.pmd
  ├─ instructions section
  │   ├─ checklists/quality.pmd
  │   └─ checklists/security.pmd
  └─ expected_output section
      └─ formats/review_comment.pmd
```

---

## Path Resolution

### Relative Paths

**Rule**: Includes are relative to **current file**.

**Example**:
```
project/
├── prompts/
│   └── main.ymd
└── components/
    ├── roles/
    │   └── expert.pmd
    └── shared/
        └── core.pmd
```

**In `prompts/main.ymd`**:
```yaml
system: |
  {% include "../components/roles/expert.pmd" %}
```

**In `components/roles/expert.pmd`**:
```markdown
{% include "../shared/core.pmd" %}
```

### Path Best Practices

- ✅ Use relative paths: `./`, `../`, `folder/`
- ❌ Avoid absolute paths: `/absolute/path`
- ❌ Avoid system paths: `~/user/path`

---

## Variable Guidelines

### Variable Definition

**In YMD**:
```yaml
# Variables can be passed during rendering
# Document expected variables:

{# Expected variables:
   - domain: string
   - language: string
   - strict_mode: boolean
#}

meta:
  id: example
  kind: task
  version: 1.0.0
  title: Example

system: |
  Expert in {{ domain }}, using {{ language }}.
```

### Variable Usage in PMD

```markdown
{# Expected variables:
   - role_type: string
   - years_experience: number
#}

You are a {{ role_type }} with {{ years_experience }} years of experience.
```

### Variable Flow

```
YMD defines: domain, language, strict_mode
  └─ PMD A uses: domain, language
      └─ PMD A.1 uses: domain
  └─ PMD B uses: strict_mode
```

Variables flow down through include chain.

---

## Best Practices

### YMD Best Practices

**DO**:
- ✅ Use descriptive `id` and `title`
- ✅ Follow semantic versioning
- ✅ Use includes for reusable content
- ✅ Use custom sections when needed
- ✅ Keep YMD thin (mostly includes)
- ✅ Document expected variables

**DON'T**:
- ❌ Don't put large content directly in YMD
- ❌ Don't duplicate across YMDs
- ❌ Don't hardcode variable values
- ❌ Don't forget version updates

### PMD Best Practices

**DO**:
- ✅ Use descriptive filenames
- ✅ Keep focused (single responsibility)
- ✅ Document expected variables
- ✅ Organize by category
- ✅ Test independently
- ✅ Use includes for reuse

**DON'T**:
- ❌ Don't add YAML metadata
- ❌ Don't create circular includes
- ❌ Don't make giant monoliths
- ❌ Don't use absolute paths

### Composition Best Practices

**DO**:
- ✅ Document composition structure
- ✅ Keep depth reasonable (≤5 levels)
- ✅ Use leaf PMDs for simple content
- ✅ Use composite PMDs for aggregation
- ✅ Test include chains
- ✅ Validate no circular dependencies

**DON'T**:
- ❌ Don't nest too deeply
- ❌ Don't create circular includes
- ❌ Don't over-engineer simple prompts

---

## File Organization

### Recommended Structure

```
project/
├── prompts/              # YMD manifests
│   ├── code_review.ymd
│   ├── api_design.ymd
│   └── documentation.ymd
├── components/           # PMD components
│   ├── roles/
│   │   ├── expert.pmd
│   │   ├── senior_dev.pmd
│   │   └── mentor.pmd
│   ├── checklists/
│   │   ├── quality.pmd
│   │   ├── security.pmd
│   │   └── performance.pmd
│   ├── formats/
│   │   ├── json_response.pmd
│   │   └── markdown_doc.pmd
│   └── shared/
│       ├── principles.pmd
│       └── style.pmd
└── examples/             # Example data
    └── sample_data.json
```

### Naming Conventions

**YMD files**:
- `snake_case.ymd`
- Descriptive: `code_review_assistant.ymd`
- Not: `cr.ymd`, `assistant.ymd`

**PMD files**:
- `snake_case.pmd`
- Descriptive: `senior_developer_role.pmd`
- Not: `role.pmd`, `sd.pmd`

**Folders**:
- Plural: `roles/`, `checklists/`, `formats/`
- By category or domain

---

## Validation Checklist

### YMD Validation

- [ ] Has `meta:` section
- [ ] All required fields present (id, kind, version, title)
- [ ] Version follows semver
- [ ] At least one section defined
- [ ] All includes exist
- [ ] No circular dependencies
- [ ] All Jinja2 syntax valid

### PMD Validation

- [ ] No `meta:` section
- [ ] Valid Markdown
- [ ] Valid Jinja2 syntax
- [ ] All includes exist
- [ ] No circular dependencies
- [ ] Expected variables documented

### Composition Validation

- [ ] All include paths resolve
- [ ] No circular includes
- [ ] Depth reasonable (≤5 levels)
- [ ] All variables defined
- [ ] Include chain tested

---

## Common Patterns

### Pattern: Simple Task

```yaml
meta:
  id: simple_task
  kind: task
  version: 1.0.0
  title: Simple Task

system: |
  {% include "roles/expert.pmd" %}

user: |
  {{ task_description }}
```

### Pattern: Comprehensive Review

```yaml
meta:
  id: comprehensive_review
  kind: review
  version: 1.0.0
  title: Comprehensive Review

system: |
  {% include "roles/senior_dev.pmd" %}

instructions: |
  {% include "checklists/quality.pmd" %}
  {% include "checklists/security.pmd" %}
  {% include "checklists/performance.pmd" %}

expected_output: |
  {% include "formats/review_comment.pmd" %}

user: |
  Review this {{ language }} code:
  \`\`\`{{ language }}
  {{ code }}
  \`\`\`
```

### Pattern: Conditional Composition

```yaml
meta:
  id: adaptive_task
  kind: task
  version: 1.0.0
  title: Adaptive Task

system: |
  {% if expert_mode %}
  {% include "roles/expert.pmd" %}
  {% else %}
  {% include "roles/assistant.pmd" %}
  {% endif %}

instructions: |
  {% include "tasks/main.pmd" %}

  {% if include_examples %}
  {% include "examples/samples.pmd" %}
  {% endif %}
```

---

## Error Handling

### Missing Include

```
Error: Include file not found
File: prompts/main.ymd:7
Include: {% include "roles/expert.pmd" %}
Resolved: /project/prompts/roles/expert.pmd

Fix: Check path is relative to prompts/main.ymd
```

### Circular Include

```
Error: Circular include detected
Chain: a.pmd → b.pmd → c.pmd → a.pmd

Fix: Remove circular dependency
```

### Undefined Variable

```
Error: Undefined variable 'domain'
File: roles/expert.pmd:3
Context: "Expert in {{ domain }}"

Fix: Define 'domain' in YMD or context
```

---

## Testing Guidelines

### Test YMD Structure

```python
def test_ymd_structure():
    ymd = load_ymd("main.ymd")
    assert ymd.meta.id
    assert ymd.meta.version
    assert len(ymd.sections) > 0
```

### Test Includes Resolve

```python
def test_includes_resolve():
    ymd = load_ymd("main.ymd")
    includes = discover_includes(ymd)
    for inc in includes:
        assert file_exists(inc.path)
```

### Test No Circular Dependencies

```python
def test_no_circular():
    ymd = load_ymd("main.ymd")
    try:
        render(ymd)
    except CircularIncludeError:
        pytest.fail("Circular include")
```

### Test Variable Coverage

```python
def test_variables():
    ymd = load_ymd("main.ymd")
    required = discover_variables(ymd)
    provided = get_variables()
    assert required <= provided
```

---

## Related Documents

- **YMD Specification**: `../ymd_format_spec.md`
- **PMD Specification**: `../pmd_format_spec.md`
- **Composition Rules**: `../composition_spec.md`
- **Quick Reference**: `./quick-reference.md`
- **Examples**: `./examples.md`
- **Section Customization**: `./section-customization.md`
- **Cheatsheet**: `../cheatsheet/ymd_pmd_cheatsheet.md`
