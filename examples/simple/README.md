# Simple YMD/PMD Examples

This directory contains simple, instructional examples demonstrating YMD/PMD format basics.

## Examples Overview

### 1. Minimal YMD (`01_minimal.ymd`)
**Concept**: Absolute minimum valid YMD file
- Just metadata + user section
- No includes, no complexity
- **Learn**: Basic YMD structure

### 2. With Role (`02_with_role.ymd`)
**Concept**: YMD with system section including a PMD
- Shows how to include components
- Simple composition (YMD → PMD)
- **Learn**: Basic includes

### 3. Custom Sections (`03_custom_sections.ymd`)
**Concept**: Using custom sections beyond standard ones
- Demonstrates `context`, `constraints`, `validation_rules`
- Shows sections are fully customizable
- **Learn**: Section flexibility

### 4. Conditional (`04_conditional.ymd`)
**Concept**: Dynamic includes based on variables
- Uses Jinja2 `{% if %}` blocks
- Adapts behavior based on variables
- **Learn**: Conditional composition

### 5. Composite PMD (`05_composite_pmd.ymd`)
**Concept**: PMD that includes other PMDs
- Shows hierarchical composition
- Composite PMD pattern
- **Learn**: PMD recursion

## Component Files

### Leaf PMDs (Pure Content)
- `components/expert_role.pmd` - Expert persona
- `components/mentor_role.pmd` - Mentor persona
- `components/senior_role.pmd` - Senior persona
- `components/shared_principles.pmd` - Shared content

### Composite PMDs (Aggregators)
- `components/complete_profile.pmd` - Aggregates multiple PMDs

## Composition Patterns Demonstrated

```
Pattern 1: Minimal
minimal.ymd (just user section)

Pattern 2: Simple Include
with_role.ymd
  └─ expert_role.pmd

Pattern 3: Multiple Sections
custom_sections.ymd (multiple custom sections)

Pattern 4: Conditional
conditional.ymd
  ├─ mentor_role.pmd (if beginner)
  ├─ senior_role.pmd (if intermediate)
  └─ expert_role.pmd (if expert)

Pattern 5: Hierarchical
composite_pmd.ymd
  └─ complete_profile.pmd (composite)
      ├─ expert_role.pmd (leaf)
      └─ shared_principles.pmd (leaf)
```

## Key Concepts

### YMD Files (Orchestrators)
- ✅ Have `meta:` section (grouped)
- ✅ Include PMD components
- ✅ Define variables
- ✅ Sections are customizable

### PMD Files (Components)
- ❌ NO `meta:` section
- ✅ Pure Markdown + Jinja2
- ✅ Can be leaf (content) or composite (aggregator)
- ✅ Can include other PMDs

### Composition
- YMD includes PMDs
- PMDs can include PMDs (recursive)
- Variables flow down through includes
- Paths are relative to current file

## Learning Path

**Start here**:
1. Read `01_minimal.ymd` - Understand basic structure
2. Read `02_with_role.ymd` + `expert_role.pmd` - See simple include
3. Read `03_custom_sections.ymd` - Learn section flexibility

**Next level**:
4. Read `04_conditional.ymd` - Understand dynamic composition
5. Read `05_composite_pmd.ymd` + `complete_profile.pmd` - See PMD recursion

**Then explore**:
- `/examples/ymd-pmd/` for complete real-world example
- `/ymd-spec/context/examples.md` for detailed examples

## Usage

These examples are templates you can copy and modify:

```bash
# Copy minimal example
cp examples/simple/01_minimal.ymd my_prompt.ymd

# Edit with your requirements
# Render with ymd-prompt library or use in Claude Code
```

## Variables

Most examples expect these variables:

- `task` - The task description
- `domain` - Domain of expertise
- `experience_level` - "beginner" | "intermediate" | "expert"
- `project_name` - Project name
- `requirement` - Requirement description

Provide these when rendering the YMD files.

## Next Steps

- **Create your own**: Use these as templates
- **Validate**: Use `/validate-composition` command
- **Get help**: Use `@ymd-author` agent for guidance
- **Learn more**: Read full specs in `/ymd-spec/`
