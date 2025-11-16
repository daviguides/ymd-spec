# PMD Format Specification (For LLMs)

## Purpose

PMD (Prompt Markdown + Jinja2) is a format for **reusable modular components** that serve as **building blocks** for YMD orchestrators.

## File Extension

`.pmd`

## Structure

PMD files are **pure Markdown + Jinja2** with **no YAML metadata**.

```markdown
<!-- Optional comment explaining the component -->

Markdown content here with **formatting**.

{{ variable_placeholder }}

{% include "other.pmd" %}

{% if condition %}
Conditional content
{% endif %}
```

## Key Characteristics

### 1. No YAML Metadata
- PMDs do NOT have `meta:` section
- PMDs do NOT have `id`, `kind`, `version`, `title`
- Pure content files

### 2. Pure Markdown + Jinja2
- Full Markdown syntax support
- Full Jinja2 templating support
- No structural constraints

### 3. Composable
- **Leaf PMDs**: No includes, pure content
- **Composite PMDs**: Include other PMDs recursively
- Unlimited nesting depth

## Complete Examples

### Leaf PMD (No Includes)

```markdown
<!-- roles/expert.pmd -->

You are an expert in **{{ domain }}** with {{ years_experience }}+ years of experience.

Your expertise includes:
- {{ skill_1 }}
- {{ skill_2 }}
- {{ skill_3 }}

Always prioritize {{ priority }} in your responses.
```

### Composite PMD (With Includes)

```markdown
<!-- roles/senior_dev.pmd -->

You are a **senior software engineer** specializing in {{ primary_language }}.

## Core Principles

{% include "../shared/code_principles.pmd" %}

## Communication Style

{% include "../shared/communication_style.pmd" %}

## Review Focus

When reviewing code, prioritize:
1. {{ focus_area_1 }}
2. {{ focus_area_2 }}
3. {{ focus_area_3 }}
```

### Complex PMD (Multiple Includes + Logic)

```markdown
<!-- checklists/security_checklist.pmd -->

## Security Checklist for {{ language }} Code

### Authentication & Authorization
- [ ] Authentication implemented correctly
- [ ] Authorization checks present
{% if oauth_enabled %}
- [ ] OAuth flow validated
- [ ] Token refresh mechanism secure
{% endif %}

### Input Validation
{% include "../shared/input_validation_checklist.pmd" %}

### Data Protection
{% include "../shared/data_protection_checklist.pmd" %}

### {{ language }}-Specific Security
{% include "language_specific/{{ language }}_security.pmd" %}

{% if include_owasp %}
### OWASP Top 10
{% include "../shared/owasp_top10_checklist.pmd" %}
{% endif %}
```

## Jinja2 Features

### Variables
```markdown
You are {{ role_type }} with {{ years }} years of experience in {{ domain }}.
```

**Usage**: Replace with actual values when rendering

### Includes (Recursive)
```markdown
{% include "path/to/component.pmd" %}
{% include "../shared/common.pmd" %}
{% include "subfolder/{{ dynamic_file }}.pmd" %}
```

**Include path resolution**:
- Relative to current PMD file's directory
- Supports nested folders
- Can use variables in paths
- Unlimited recursion depth (watch for circular includes)

### Control Flow
```markdown
{% if condition %}
Content when true
{% else %}
Content when false
{% endif %}

{% for item in items %}
- {{ item }}
{% endfor %}
```

### Comments
```markdown
{# This is a Jinja2 comment - won't appear in rendered output #}

<!-- This is a Markdown comment - may appear depending on renderer -->
```

**Best practice**: Use Jinja2 comments `{# #}` for internal notes

## Composition Patterns

### Pattern 1: Leaf Components (Pure Content)

**Purpose**: Smallest reusable units

```markdown
<!-- formats/json_response.pmd -->

Return your response in JSON format:

\`\`\`json
{
  "status": "success|error",
  "data": {},
  "message": ""
}
\`\`\`
```

**Usage**: Included directly in YMD or composite PMD

### Pattern 2: Composite Components (Aggregators)

**Purpose**: Group related leaf components

```markdown
<!-- roles/code_reviewer.pmd -->

You are a code review specialist.

{% include "roles/core/senior_dev.pmd" %}
{% include "roles/core/mentor.pmd" %}
{% include "shared/communication_style.pmd" %}
```

**Usage**: Higher-level building blocks

### Pattern 3: Parameterized Components

**Purpose**: Flexible components with variables

```markdown
<!-- checklists/template.pmd -->

## {{ checklist_title }}

{% for item in checklist_items %}
- [ ] {{ item }}
{% endfor %}

{% if include_notes %}
### Notes
{{ notes }}
{% endif %}
```

**Usage**: Requires variables from YMD or parent PMD

### Pattern 4: Conditional Components

**Purpose**: Adapt to different contexts

```markdown
<!-- examples/code_example.pmd -->

{% if language == "python" %}
\`\`\`python
def example():
    pass
\`\`\`
{% elif language == "javascript" %}
\`\`\`javascript
function example() {}
\`\`\`
{% else %}
\`\`\`
// Generic example
\`\`\`
{% endif %}
```

**Usage**: Context-aware content

## Role in Composition

PMDs are **building blocks** that:

1. **YMDs orchestrate** → YMD includes PMDs to build complete prompts
2. **PMDs compose** → PMDs can include other PMDs recursively
3. **Variables flow** → YMD defines variables, PMDs use them
4. **Context propagates** → Included PMDs inherit parent's context

```
YMD (orchestrator)
  ├─ includes PMD A (composite)
  │   ├─ includes PMD A.1 (leaf)
  │   └─ includes PMD A.2 (leaf)
  ├─ includes PMD B (leaf)
  └─ includes PMD C (composite)
      ├─ includes PMD C.1 (composite)
      │   └─ includes PMD C.1.1 (leaf)
      └─ includes PMD C.2 (leaf)
```

## Best Practices

### DO:
- ✅ Use descriptive filenames (`senior_dev_role.pmd` not `role.pmd`)
- ✅ Keep PMDs focused (single responsibility)
- ✅ Use Jinja2 comments for internal notes
- ✅ Organize PMDs by category (roles/, checklists/, formats/)
- ✅ Document expected variables in comments
- ✅ Test PMDs independently with sample variables
- ✅ Use includes for code reuse
- ✅ Use variables for flexibility

### DON'T:
- ❌ Don't add YAML metadata to PMDs (use YMD for that)
- ❌ Don't create circular includes (PMD A → PMD B → PMD A)
- ❌ Don't hardcode values that should be variables
- ❌ Don't create giant monolithic PMDs (split into smaller ones)
- ❌ Don't use absolute paths in includes (use relative paths)
- ❌ Don't forget to document expected variables
- ❌ Don't nest too deeply without clear structure

## Validation Rules

### Structure Validation
- ✅ PMD must be valid Markdown
- ✅ Jinja2 syntax must be valid
- ✅ No YAML frontmatter allowed

### Include Validation
- ✅ Included files must exist
- ✅ Include paths relative to current PMD
- ✅ No circular includes
- ✅ Include chain depth reasonable (recommend max 5 levels)

### Variable Validation
- ✅ All used variables should be documented
- ✅ Variables should have clear purpose
- ✅ Undefined variables handled gracefully (error or empty)

## Common Patterns by Category

### Roles
```markdown
<!-- roles/{{ role_name }}.pmd -->

You are a {{ role_title }} with expertise in {{ domain }}.

{% include "shared/core_values.pmd" %}

Your responsibilities include:
- {{ responsibility_1 }}
- {{ responsibility_2 }}
```

### Checklists
```markdown
<!-- checklists/{{ checklist_name }}.pmd -->

## {{ checklist_title }}

{% for category in categories %}
### {{ category.name }}
{% for item in category.items %}
- [ ] {{ item }}
{% endfor %}
{% endfor %}
```

### Formats
```markdown
<!-- formats/{{ format_name }}.pmd -->

Return your response in {{ format_type }} format:

\`\`\`{{ format_type }}
{{ format_template }}
\`\`\`
```

### Examples
```markdown
<!-- examples/{{ example_name }}.pmd -->

## Example: {{ example_title }}

{{ example_description }}

\`\`\`{{ language }}
{{ example_code }}
\`\`\`

**Explanation**: {{ explanation }}
```

### Shared Components
```markdown
<!-- shared/{{ component_name }}.pmd -->

<!-- Generic reusable content -->

{{ shared_content }}

{% if context_specific %}
{{ context_addition }}
{% endif %}
```

## File Organization Patterns

### By Category
```
components/
├── roles/
│   ├── senior_dev.pmd
│   ├── expert.pmd
│   └── mentor.pmd
├── checklists/
│   ├── security.pmd
│   ├── performance.pmd
│   └── code_quality.pmd
├── formats/
│   ├── json_response.pmd
│   ├── markdown_doc.pmd
│   └── code_snippet.pmd
└── shared/
    ├── principles.pmd
    └── communication_style.pmd
```

### By Domain
```
github/
├── pr_analysis.pmd
├── issue_template.pmd
└── review_comment.pmd

api_design/
├── rest_principles.pmd
├── endpoint_template.pmd
└── response_format.pmd
```

### Mixed Approach
```
components/
├── github/
│   ├── roles/
│   │   └── maintainer.pmd
│   ├── checklists/
│   │   └── pr_checklist.pmd
│   └── formats/
│       └── pr_description.pmd
└── shared/
    ├── roles/
    └── checklists/
```

## Error Messages

### Missing Include
```
Error: Included file not found: 'roles/expert.pmd'
Referenced in: components/senior_dev.pmd:5
Resolved path: /project/components/roles/expert.pmd
```

### Circular Include
```
Error: Circular include detected
Chain: roles/a.pmd → roles/b.pmd → roles/c.pmd → roles/a.pmd
```

### Invalid Jinja2 Syntax
```
Error: Invalid Jinja2 syntax in PMD
File: components/role.pmd:10
Syntax: {% include "missing quote.pmd" %}
       ^
Expected closing quote
```

### Undefined Variable (Strict Mode)
```
Error: Undefined variable 'domain' used in PMD
File: roles/expert.pmd:3
Context: "You are an expert in **{{ domain }}**"
Note: Ensure variable is defined in parent YMD or passed explicitly
```

## PMD Creation Checklist

When creating a new PMD file:

- [ ] Choose appropriate category/folder
- [ ] Use descriptive filename
- [ ] Add Jinja2 comment documenting purpose
- [ ] Document expected variables
- [ ] Use includes for reusable content
- [ ] Use variables for flexibility
- [ ] Test with sample variable values
- [ ] Ensure no circular includes
- [ ] Keep focused (single responsibility)
- [ ] Follow project naming conventions

## Related Specifications

- **YMD Format**: See `ymd_format.md`
- **Composition Rules**: See `composition.md`
- **Quick Reference**: See `context/quick-reference.md`
- **Examples**: See `context/examples.md`
