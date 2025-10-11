# Load YMD/PMD Context Prompt

**Purpose**: Load YMD/PMD format knowledge into LLM context for authoring session.

---

## Format Specifications (Normative)

The following specifications define the **WHAT** - complete format rules and syntax:

**Core Format Specifications**:
- `@~/.claude/ymd-spec/ymd_format_spec.md` - Complete YMD format specification
- `@~/.claude/ymd-spec/pmd_format_spec.md` - Complete PMD format specification
- `@~/.claude/ymd-spec/composition_spec.md` - Composition and include rules

---

## Applied Knowledge (Practical)

The following guides demonstrate the **HOW** - practical application and decision-making:

**Practical Guides**:
- `@~/.claude/ymd-spec/context/examples.md` - Complete working examples
- `@~/.claude/ymd-spec/context/project-guide.md` - Project organization and naming
- `@~/.claude/ymd-spec/context/decision-guide.md` - Decision trees and guidance

---

## Your Task Now

With this context loaded, you can now:

1. **Create YMD files** - Orchestrators with proper metadata and sections
2. **Create PMD files** - Reusable components (NO metadata!)
3. **Validate compositions** - Check structure, includes, variables
4. **Guide users** - Help design prompt structures
5. **Debug issues** - Identify and fix format problems

### Core Principles to Remember

**YMD = Orchestrator**:
- Has `meta:` section (grouped, not flat)
- Contains customizable sections (not limited to standard)
- Includes PMDs to build complete prompts
- Uses Jinja2 for variables and includes

**PMD = Component**:
- NO `meta:` section (critical difference)
- Pure Markdown + Jinja2
- Can include other PMDs recursively
- Leaf (no includes) or composite (with includes)

**Composition**:
- YMD orchestrates → includes PMDs
- PMDs compose → can include other PMDs
- Variables flow down through entire include chain
- Include paths relative to current file
- Unlimited nesting (recommend max 5 levels)

**Validation**:
- All includes must resolve
- No circular dependencies
- All variables documented
- YMD has metadata, PMD does not

---

## Context Loaded ✅

You are now equipped to work with YMD/PMD formats. You understand:

✅ **Format Distinction**
- YMD = Orchestrator with `meta:` section
- PMD = Component without `meta:` section

✅ **Section Customization**
- YMD sections are fully customizable
- Not limited to standard sections (system, instructions, user)
- Any valid YAML key can be a section

✅ **Composition Mechanics**
- YMD → PMD → PMD... (recursive composition)
- Variables propagate through includes
- Paths relative to current file
- Unlimited nesting depth

✅ **Validation Rules**
- YMD: Must have `meta:` with id, kind, version, title
- PMD: Must NOT have `meta:` section
- Composition: No circular includes, all paths resolve

✅ **Best Practices**
- Keep YMD thin (mostly includes)
- Give PMDs single responsibility
- Use descriptive filenames (snake_case)
- Document expected variables
- Organize by category or domain

✅ **Path Resolution**
- Relative to current file's directory
- Use `./`, `../`, `folder/` notation
- Never use absolute paths

✅ **Common Patterns**
- Leaf PMDs: Pure content, no includes
- Composite PMDs: Aggregate other PMDs
- Bridge PMDs: Conditional routing
- Hierarchical composition: Multi-level includes

✅ **Project Organization**
- prompts/ for YMD orchestrators
- components/ for PMD building blocks
- Organize by category (roles/, checklists/, formats/)
- Or by domain (github/, api/, docs/)

---

## You're Ready to Author YMD/PMD Files!

Use the loaded specifications and guides to:
- Design structured, modular prompts
- Create reusable component libraries
- Validate compositions and debug issues
- Guide users on best practices

When in doubt, refer to the specifications for **normative rules** and the guides for **practical patterns**.
