# YMD/PMD Project Organization Guide

This guide provides practical guidance on organizing YMD/PMD projects, naming conventions, and file structure patterns.

**For format syntax and rules**, see:
- `@../spec/ymd_format.md` - YMD format specification
- `@../spec/pmd_format.md` - PMD format specification
- `@../spec/composition.md` - Composition rules

---

## File Organization Patterns

### Basic Project Structure

```
project/
├── prompts/              # YMD orchestrator files
│   ├── code_review.ymd
│   ├── api_design.ymd
│   └── documentation.ymd
│
└── components/           # PMD component files
    ├── roles/           # Persona definitions
    │   ├── expert.pmd
    │   ├── senior_dev.pmd
    │   └── mentor.pmd
    │
    ├── checklists/      # Validation checklists
    │   ├── code_quality.pmd
    │   ├── security.pmd
    │   └── performance.pmd
    │
    ├── formats/         # Output format templates
    │   ├── json_response.pmd
    │   ├── markdown_doc.pmd
    │   └── review_comment.pmd
    │
    └── shared/          # Common reusable content
        ├── principles.pmd
        ├── communication_style.pmd
        └── core_values.pmd
```

### Domain-Specific Organization

For projects with multiple domains:

```
project/
├── prompts/
│   ├── github/
│   │   ├── pr_review.ymd
│   │   └── issue_analysis.ymd
│   │
│   └── api/
│       ├── rest_design.ymd
│       └── graphql_design.ymd
│
└── components/
    ├── github/
    │   ├── roles/
    │   │   └── maintainer.pmd
    │   ├── checklists/
    │   │   └── pr_checklist.pmd
    │   └── formats/
    │       └── pr_description.pmd
    │
    └── api/
        ├── principles/
        │   ├── rest_principles.pmd
        │   └── graphql_principles.pmd
        └── formats/
            └── api_spec.pmd
```

### Enterprise/Large-Scale Structure

For large projects with many teams:

```
project/
├── prompts/
│   ├── code_review/
│   │   ├── frontend.ymd
│   │   ├── backend.ymd
│   │   └── infrastructure.ymd
│   │
│   ├── documentation/
│   │   ├── api_docs.ymd
│   │   └── user_guides.ymd
│   │
│   └── testing/
│       ├── unit_tests.ymd
│       └── integration_tests.ymd
│
└── components/
    ├── shared/           # Cross-domain shared components
    │   ├── roles/
    │   ├── principles/
    │   └── styles/
    │
    ├── frontend/         # Frontend-specific components
    │   ├── frameworks/
    │   ├── checklists/
    │   └── patterns/
    │
    ├── backend/          # Backend-specific components
    │   ├── languages/
    │   ├── databases/
    │   └── apis/
    │
    └── infrastructure/   # Infra-specific components
        ├── cloud/
        ├── security/
        └── monitoring/
```

---

## Naming Conventions

### File Names

**YMD files** (orchestrators):
- Format: `snake_case.ymd`
- Be descriptive and specific
- Indicate purpose clearly

```
✅ Good Examples:
- code_review_assistant.ymd
- api_design_restful.ymd
- github_pr_analyzer.ymd
- documentation_generator_api.ymd

❌ Bad Examples:
- cr.ymd                    # Too abbreviated
- assistant.ymd             # Too generic
- codeReview.ymd            # Not snake_case
- code-review.ymd           # Hyphens (use underscores)
```

**PMD files** (components):
- Format: `snake_case.pmd`
- Describe content clearly
- Include category in name if needed

```
✅ Good Examples:
- senior_developer_role.pmd
- code_quality_checklist.pmd
- json_response_format.pmd
- rest_api_principles.pmd

❌ Bad Examples:
- role.pmd                  # Too generic
- checklist.pmd             # Which checklist?
- format.pmd                # Which format?
- sd.pmd                    # Too abbreviated
```

### Directory Names

**Use plural forms for categories**:
```
✅ Good:
- roles/
- checklists/
- formats/
- principles/
- examples/

❌ Bad:
- role/
- checklist/
- format/
```

**Use lowercase**:
```
✅ Good:
- shared/
- github/
- api_design/

❌ Bad:
- Shared/
- GitHub/
- APIDesign/
```

### Identifier Naming (in YMD meta)

**YMD `meta.id`**:
```yaml
✅ Good:
meta:
  id: code_review_assistant        # Clear, specific
  id: github_pr_analyzer            # Domain + purpose
  id: api_design_restful            # Category + style

❌ Bad:
meta:
  id: assistant                     # Too generic
  id: cr                            # Too abbreviated
  id: codeReviewAssistant          # Not snake_case
```

**YMD `meta.kind`**:
```yaml
✅ Good:
meta:
  kind: review                      # Clear category
  kind: api_design                  # Specific type
  kind: documentation               # Purpose

❌ Bad:
meta:
  kind: prompt                      # Too generic
  kind: task                        # Too vague
```

**Section names**:
```yaml
✅ Good:
review_focus: |
security_requirements: |
api_principles: |
test_categories: |

❌ Bad:
reviewFocus: |          # Not snake_case
review-focus: |         # Hyphens
section1: |             # Non-descriptive
```

**Variable names**:
```jinja2
✅ Good:
{{ user_profile }}
{{ max_retry_attempts }}
{{ primary_language }}
{{ target_audience }}

❌ Bad:
{{ userProfile }}       # Not snake_case
{{ maxRetries }}        # CamelCase
{{ lang }}              # Too abbreviated
{{ data }}              # Too generic
```

---

## Project Scaling Strategies

### Small Projects (1-5 prompts)

**Structure**:
```
project/
├── prompts/
│   └── *.ymd           # All YMDs in root
└── components/
    └── *.pmd           # Simple flat structure
```

**When to use**:
- Single domain
- Few use cases
- Small team
- Proof of concept

### Medium Projects (5-20 prompts)

**Structure**:
```
project/
├── prompts/
│   └── *.ymd
└── components/
    ├── roles/
    ├── checklists/
    ├── formats/
    └── shared/
```

**When to use**:
- Single domain with multiple use cases
- Growing component library
- Need organization by category

### Large Projects (20+ prompts)

**Structure**:
```
project/
├── prompts/
│   ├── domain_a/
│   ├── domain_b/
│   └── shared/
└── components/
    ├── shared/
    ├── domain_a/
    └── domain_b/
```

**When to use**:
- Multiple domains
- Large team
- Extensive component library
- Need domain separation

---

## Multi-Domain Projects

### Strategy 1: Domain Folders

```
project/
├── prompts/
│   ├── github/           # GitHub-related prompts
│   ├── api_design/       # API design prompts
│   └── documentation/    # Documentation prompts
└── components/
    ├── shared/           # Cross-domain components
    ├── github/           # GitHub-specific components
    ├── api_design/       # API-specific components
    └── documentation/    # Docs-specific components
```

**Benefits**:
- Clear domain boundaries
- Easy to navigate
- Team ownership per domain

### Strategy 2: Hybrid (Shared + Domain)

```
project/
├── prompts/
│   └── *.ymd             # All prompts in root
└── components/
    ├── shared/           # Used by multiple domains
    │   ├── roles/
    │   ├── principles/
    │   └── styles/
    │
    └── specialized/      # Domain-specific
        ├── github/
        ├── api/
        └── databases/
```

**Benefits**:
- Maximize reuse via shared/
- Specialize where needed
- Flat prompt structure for discovery

---

## Component Organization Patterns

### By Category (Recommended for most projects)

```
components/
├── roles/              # Who is the assistant
├── checklists/         # What to validate
├── formats/            # How to format output
├── principles/         # Guiding principles
├── examples/           # Sample inputs/outputs
└── shared/             # Common utilities
```

### By Domain (For multi-domain projects)

```
components/
├── github/
│   ├── roles/
│   ├── checklists/
│   └── formats/
│
└── api_design/
    ├── roles/
    ├── principles/
    └── formats/
```

### By Layer (For complex workflows)

```
components/
├── orchestrators/      # High-level coordinators
├── specialists/        # Domain experts
├── validators/         # Validation logic
├── formatters/         # Output formatting
└── utilities/          # Helper components
```

---

## Path Management

### Relative Paths Best Practices

**From YMD to components**:
```yaml
# In prompts/code_review.ymd
system: |
  {% include "../components/roles/senior_dev.pmd" %}
```

**From PMD to other PMDs** (same level):
```markdown
# In components/roles/senior_dev.pmd
{% include "expert.pmd" %}
```

**From PMD to other PMDs** (different category):
```markdown
# In components/roles/senior_dev.pmd
{% include "../shared/principles.pmd" %}
```

**From nested PMD**:
```markdown
# In components/github/roles/maintainer.pmd
{% include "../../shared/principles.pmd" %}
{% include "../checklists/pr_checklist.pmd" %}
```

### Path Debugging Tips

1. **Always relative to current file**
2. **Count directory levels**:
   - Same directory: `file.pmd`
   - Parent directory: `../file.pmd`
   - Two levels up: `../../file.pmd`
3. **Use descriptive paths**: `../shared/principles.pmd` better than `../../p.pmd`

---

## Version Control Considerations

### What to Track

✅ **Always track**:
- All `.ymd` files
- All `.pmd` files
- Documentation
- Examples

❌ **Don't track**:
- Rendered outputs (unless needed)
- Temporary files
- Local configuration overrides

### .gitignore Pattern

```gitignore
# Rendered outputs
rendered/
output/
*.rendered.md

# Temporary files
*.tmp
.DS_Store

# Editor files
.vscode/
.idea/
*.swp
```

---

## Related Documents

**Format Specifications**:
- `@../spec/ymd_format.md` - YMD format details
- `@../spec/pmd_format.md` - PMD format details
- `@../spec/composition.md` - Composition rules

**Applied Knowledge**:
- `@./examples.md` - Complete working examples
- `@./decision-guide.md` - Decision trees and guidance
