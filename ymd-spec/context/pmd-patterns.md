# PMD Composition Patterns

**Purpose**: Common structural patterns for PMD component files and when to use each.

**For PMD examples**: See @./pmd-examples.md
**For categories**: See @./pmd-categories.md

---

## Pattern 1: Simple Leaf PMD

### When to Use
- Single focused content
- No sub-components needed
- Direct value without aggregation
- 10-50 lines typically

### Structure
```markdown
{# [Component type]: [Name]
   Purpose: [What this does]
   Expected variables:
   - variable_1: type - description
#}

## [Main Heading]

[Content with **Markdown** formatting]

{{ variable_usage }}

[More content]
```

### Characteristics
- Pure content
- No includes
- Self-contained
- Single responsibility

### Example Use Cases
- Simple role definitions
- Basic checklists
- Format templates
- Focused guidelines

---

## Pattern 2: Comprehensive Leaf PMD

### When to Use
- Complete standalone component
- Multiple sections needed
- Detailed content
- 40-100 lines typically

### Structure
```markdown
{# [Component type]: [Name]
   Purpose: [Comprehensive description]
   Expected variables:
   - [multiple variables]
#}

## [Primary Section]

[Detailed content]

## [Secondary Section]

[More detailed content]

## [Additional Sections]

[Even more content]
```

### Characteristics
- Multiple sections
- Well-structured
- Comprehensive
- Still no includes

### Example Use Cases
- Detailed role with multiple aspects
- Comprehensive checklists
- Complex format specifications
- Multi-section guidelines

---

## Pattern 3: Simple Composite PMD

### When to Use
- Logically group 2-3 related components
- Aggregation adds value
- Minimal own content
- 5-30 lines typically

### Structure
```markdown
{# Composite: [Name]
   Purpose: Combines [list components]
   Expected variables:
   - [variables from included PMDs]
#}

[Brief introduction or context]

{% include "[component1].pmd" %}

{% include "[component2].pmd" %}

{% include "[component3].pmd" %}
```

### Characteristics
- Few includes (2-4)
- Minimal bridging content
- Clear aggregation purpose
- Thin wrapper

### Example Use Cases
- Role + communication style
- Multiple related checklists
- Grouped guidelines
- Combined principles

---

## Pattern 4: Layered Composite PMD

### When to Use
- Hierarchical organization
- Multiple layers of composition
- Complex aggregation
- 10-40 lines with structure

### Structure
```markdown
{# Layered Composite: [Name]
   Purpose: Hierarchical organization of [domain]
   Expected variables:
   - [variables from all layers]
#}

## [Layer 1]

{% include "[layer1_component1].pmd" %}
{% include "[layer1_component2].pmd" %}

## [Layer 2]

{% include "[layer2_component1].pmd" %}
{% include "[layer2_component2].pmd" %}

## [Layer 3]

{% include "[layer3_component1].pmd" %}
```

### Characteristics
- Structured sections
- Organized includes
- Clear hierarchy
- Logical grouping

### Example Use Cases
- Multi-phase workflows
- Categorized checklists
- Structured methodologies
- Layered guidelines

---

## Pattern 5: Conditional PMD

### When to Use
- Content varies by context
- 2-4 distinct modes
- Variable-driven selection
- Adaptive content

### Structure
```markdown
{# Conditional: [Name]
   Purpose: Adapts to [condition]
   Expected variables:
   - condition_var: string - Determines which content
#}

{% if condition_var == "option1" %}
## [Option 1 Content]
[Specific content for option 1]

{% elif condition_var == "option2" %}
## [Option 2 Content]
[Specific content for option 2]

{% else %}
## [Default Content]
[Default content]

{% endif %}
```

### Characteristics
- Uses `{% if %}` blocks
- Different content per condition
- Variable-driven
- Flexible behavior

### Example Use Cases
- Experience-level content (beginner/advanced)
- Language-specific examples
- Mode-specific guidelines
- Context-adaptive content

---

## Pattern 6: Template PMD

### When to Use
- Structure with variable interpolation
- Format specification
- Output templates
- Dynamic content generation

### Structure
```markdown
{# Template: [Name]
   Purpose: Template for [output type]
   Expected variables:
   - [all template variables]
#}

## {{ section_title }}

{{ section_content }}

### {{ subsection_title }}

- **{{ field_name }}**: {{ field_value }}
- **{{ another_field }}**: {{ another_value }}

```{{ code_language }}
{{ code_template }}
``  `

**Note**: {{ note_content }}
```

### Characteristics
- Heavy variable usage
- Structure-focused
- Template-like
- Output specification

### Example Use Cases
- Response formats
- Document templates
- Report structures
- Output specifications

---

## Pattern 7: Iterative PMD

### When to Use
- Repeat pattern for list items
- Process collections
- Dynamic repetition
- List-based content

### Structure
```markdown
{# Iterative: [Name]
   Purpose: Processes [list type]
   Expected variables:
   - items: list - Items to process
#}

## [Section Title]

{% for item in items %}
### {{ item.name }}

**{{ item.field1 }}**: {{ item.value1 }}
**{{ item.field2 }}**: {{ item.value2 }}

{% endfor %}
```

### Characteristics
- Uses `{% for %}` loops
- Dynamic repetition
- List processing
- Scalable to items

### Example Use Cases
- Multiple examples
- Feature lists
- Test cases
- Configuration options

---

## Pattern 8: Conditional Composite PMD

### When to Use
- Includes vary by condition
- Dynamic composition
- Flexible aggregation
- Context-specific components

### Structure
```markdown
{# Conditional Composite: [Name]
   Purpose: Composes based on [condition]
   Expected variables:
   - mode: string - Determines composition
   - [other variables]
#}

{% if mode == "comprehensive" %}
{% include "components/full_set.pmd" %}
{% include "components/extended.pmd" %}
{% elif mode == "basic" %}
{% include "components/minimal.pmd" %}
{% else %}
{% include "components/default.pmd" %}
{% endif %}

{% include "components/common.pmd" %}
```

### Characteristics
- Conditional includes
- Dynamic composition
- Shared + variable components
- Adaptive aggregation

### Example Use Cases
- Skill-level adaptation
- Feature-based inclusion
- Mode-specific workflows
- Dynamic checklists

---

## Decision Guide: Choosing a Pattern

### Start with Pattern 1 (Simple Leaf) if:
- ✅ Content is straightforward
- ✅ No sub-components exist
- ✅ 10-50 lines
- ✅ Single focus

### Use Pattern 2 (Comprehensive Leaf) if:
- ✅ Need multiple sections
- ✅ Still self-contained
- ✅ 40-100 lines
- ✅ Complete but focused

### Choose Pattern 3 (Simple Composite) if:
- ✅ Combining 2-4 components
- ✅ Logical grouping
- ✅ Minimal bridging
- ✅ Aggregation value clear

### Apply Pattern 4 (Layered Composite) if:
- ✅ Hierarchical structure
- ✅ Multiple layers
- ✅ Organized sections
- ✅ Complex but structured

### Select Pattern 5 (Conditional) if:
- ✅ Content varies by context
- ✅ 2-4 distinct modes
- ✅ Variable-driven
- ✅ Adaptive needed

### Implement Pattern 6 (Template) if:
- ✅ Format specification
- ✅ Many variables
- ✅ Structure focus
- ✅ Output template

### Use Pattern 7 (Iterative) if:
- ✅ Process lists
- ✅ Repeat patterns
- ✅ Dynamic items
- ✅ Collection-based

### Choose Pattern 8 (Conditional Composite) if:
- ✅ Dynamic composition
- ✅ Condition-based includes
- ✅ Flexible aggregation
- ✅ Mode-specific

---

## Anti-Patterns to Avoid

### ❌ Anti-Pattern: Mega PMD
**Problem**: 200+ lines in single leaf PMD
**Solution**: Split into multiple focused PMDs or create composite

### ❌ Anti-Pattern: Deep Nesting
**Problem**: PMD includes PMD includes PMD includes... (6+ levels)
**Solution**: Flatten structure, reduce indirection

### ❌ Anti-Pattern: Mixed Responsibility
**Problem**: PMD does multiple unrelated things
**Solution**: Split by responsibility, single focus

### ❌ Anti-Pattern: Duplicate Content
**Problem**: Same content in multiple PMDs
**Solution**: Extract to shared PMD, include from both

### ❌ Anti-Pattern: Overly Generic
**Problem**: PMD is so abstract it's not useful
**Solution**: Add specificity, make concrete

### ❌ Anti-Pattern: Overly Specific
**Problem**: PMD works for only one exact case
**Solution**: Add variables, increase reusability

---

## Pattern Evolution

PMDs often evolve:

1. **Start**: Pattern 1 (Simple Leaf) - Initial version
2. **Grow**: Pattern 2 (Comprehensive Leaf) - Add sections
3. **Extract**: Pattern 3 (Simple Composite) - Extract reusable parts
4. **Structure**: Pattern 4 (Layered Composite) - Add organization
5. **Adapt**: Pattern 5/8 (Conditional) - Add flexibility

This evolution is natural and healthy.

---

## Composition Depth Guidelines

**Recommended maximum**: 5 levels

```
YMD (level 0)
  ├─ PMD A (level 1)
  │   └─ PMD A1 (level 2)
  │       └─ PMD A1a (level 3)
  │           └─ PMD A1a-i (level 4)
  │               └─ PMD A1a-i-x (level 5) ← Stop here
  └─ PMD B (level 1)
```

If you exceed 5 levels, consider:
- Flattening structure
- Combining intermediate PMDs
- Rethinking organization

---

## Quick Reference

| Pattern | Type | Use Case | Includes | Typical Lines |
|---------|------|----------|----------|---------------|
| 1. Simple Leaf | Leaf | Basic content | 0 | 10-50 |
| 2. Comprehensive Leaf | Leaf | Detailed content | 0 | 40-100 |
| 3. Simple Composite | Composite | Group 2-4 | 2-4 | 5-30 |
| 4. Layered Composite | Composite | Hierarchical | 4-8 | 10-40 |
| 5. Conditional | Conditional | Variable content | 0 | 20-60 |
| 6. Template | Template | Format spec | 0 | 15-50 |
| 7. Iterative | Iterative | List processing | 0 | 10-40 |
| 8. Conditional Composite | Both | Dynamic composition | 2-6 | 10-30 |
