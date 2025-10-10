# Create PMD Partial

Create a reusable PMD component file (pure Markdown + Jinja2) with single responsibility.

## What This Does

This command helps you create a PMD component by:

- Determining component type (leaf vs composite)
- Choosing appropriate category (roles, checklists, formats, etc.)
- Generating the PMD file with correct format
- Validating structure (NO metadata!)
- Providing usage guidance

## When to Use

Use this command when you want to create:

- A reusable component (not a complete prompt)
- Content to be included by YMD or other PMDs
- Role definitions, checklists, formats, or shared content

**Note**: For complete prompts, use `/create-ymd-manifest` instead.

## What You'll Need

Be ready to provide:

- **Purpose**: What is this component's single responsibility?
- **Category**: Where should it live? (roles/, checklists/, formats/, shared/)
- **Type**: Leaf (content) or Composite (aggregator)?
- **Variables**: What variables does it use?

The command will guide you through the rest.

## Important Rules

**PMD files must**:
- ❌ Have NO `meta:` section (only YMD has metadata)
- ✅ Be pure Markdown + Jinja2
- ✅ Have single, clear responsibility
- ✅ Document expected variables

---

## Business Logic

@~/.claude/ymd-spec/prompts/create-pmd.md
