# YMD/PMD Format Specification

## Project Overview

**YMD/PMD Spec** is the official specification and Claude Code plugin for YMD and PMD formats developed by Davi Guides.

This repository serves three purposes:
1. **Format Specification**: Official documentation of YMD and PMD formats
2. **Claude Code Plugin**: Tools for authoring and validating YMD/PMD files
3. **Reference Implementation**: Examples and patterns for structured prompts

## Related Projects

- **vscode-ymd**: VSCode extension for YMD/PMD syntax highlighting ([~/work/sources/my/genai/vscode-ymd](../vscode-ymd))
- **ymd-prompt**: Python library for loading and rendering YMD/PMD files ([~/work/sources/my/genai/ymd-prompt](../ymd-prompt))

---

## Development Commands

### Installation Testing

```bash
# Test the installer script locally
bash install.sh

# Verify installation
ls ~/.claude/ymd-spec/
cat ~/.claude/CLAUDE.md
```

### Documentation Site

The documentation site is built with Jekyll:

```bash
# Navigate to docs directory
cd docs

# Serve locally (requires Jekyll)
bundle exec jekyll serve

# Access at http://localhost:4000
```

---

## Repository Architecture

### Core Components

**ymd-spec/** - The specification and context directory (SOURCE OF TRUTH)
- `spec/ymd_format.md` - Complete YMD specification for LLMs
- `spec/pmd_format.md` - Complete PMD specification for LLMs
- `spec/composition.md` - How YMD/PMD compose together
- `context/` - Guidelines, quick reference, examples
- `prompts/` - **Business logic** for commands/agents
- `cheatsheet/` - Quick lookup reference

**commands/** - Thin API entry points
- Each command references prompts in `~/.claude/ymd-spec/prompts/`
- Commands are wrappers, not business logic containers
- Example: `create-ymd-manifest.md` → `@~/.claude/ymd-spec/prompts/create-ymd.md`

**agents/** - Thin specialized contexts
- Each agent references specs/prompts in `~/.claude/ymd-spec/`
- Agents provide context, not full prompts
- Example: `ymd-author.md` → `@~/.claude/ymd-spec/prompts/author-guide.md`

**examples/** - Practical examples
- `simple/` - Basic examples (standard sections, custom sections, leaf PMDs, composite PMDs)
- `ymd-pmd/` - Complete real-world example (GitHub PR workflow from ymd-prompt)

**docs/** - Jekyll documentation site
- `_pages/ymd-format.md` - YMD specification for humans
- `_pages/pmd-format.md` - PMD specification for humans
- `_pages/composition-patterns.md` - Composition patterns
- `_pages/why-ymd-pmd.md` - Rationale and philosophy

**install.sh** - Installation script
- Copies `ymd-spec/` directory to `~/.claude/ymd-spec/`
- Optionally configures `~/.claude/CLAUDE.md`
- Handles existing installations with prompts

### Key Architectural Principles

**Single Source of Truth:**
- All specifications in `ymd-spec/*.md`
- All business logic in `ymd-spec/prompts/`
- All context in `ymd-spec/context/`
- Commands and agents are **thin wrappers** that reference the source of truth

**Thin API Layer:**
- Commands are entry points (like REST API endpoints)
- Agents are specialized contexts (like service layers)
- Business logic centralized in `prompts/` directory
- **No duplication** between commands/agents and specs/prompts

**Clear References:**
```markdown
<!-- Command example -->
@~/.claude/ymd-spec/prompts/create-ymd.md

<!-- Agent example -->
@~/.claude/ymd-spec/spec/ymd_format.md
@~/.claude/ymd-spec/prompts/author-guide.md
```

**Distribution Strategy:**
- Install script copies `ymd-spec/` to `~/.claude/ymd-spec/`
- Commands/agents reference `@~/.claude/ymd-spec/...`
- Ensures version stability and offline availability
- Single update location (ymd-spec/) for all consumers

---

## YMD and PMD Format Specifications

### YMD: Structured Prompt Manifests

**Purpose**: Orchestrator/aggregator files for complete prompts

**Structure**:
```yaml
# YAML metadata (required, grouped under meta:)
meta:
  id: unique_identifier
  kind: prompt_type
  version: semver
  title: Human-readable title

# Sections (Markdown in block scalars)
system: |
  {% include "roles/expert.pmd" %}

instructions: |
  {% include "tasks/analysis.pmd" %}

user: |
  {{ user_input }}
```

**Key characteristics**:
- YAML metadata grouped under `meta:` key at the top
- Sections with `key: |` block scalar syntax
- **Sections are fully customizable** (not limited to standard set)
- Markdown + Jinja2 inside sections
- Includes PMD partials for composition

**Standard sections** (common patterns):
- `system` - Role/persona definition
- `instructions` - Step-by-step tasks
- `expected_output` - Output format specification
- `developer` - Implementation notes
- `user` - User input template

**Custom sections** (user-defined):
- Any valid YAML key name works
- Same syntax: `section_name: |`
- Same Markdown + Jinja2 support
- Example: `context`, `constraints`, `examples`, `validation_rules`

### PMD: Modular Prompt Components

**Purpose**: Reusable building blocks for composition

**Structure**:
```markdown
<!-- Pure Markdown + Jinja2 (no YAML) -->

You are a **{{ role_type }}** with expertise in:
- {{ skill_1 }}
- {{ skill_2 }}

{% include "shared/principles.pmd" %}
```

**Key characteristics**:
- No YAML metadata
- Pure Markdown + Jinja2
- **Can include other PMDs recursively**
- Leaf PMDs (no includes) or composite PMDs (with includes)

**Composition patterns**:
```
YMD (orchestrator)
  ├─ includes PMD 1 (component)
  │   └─ includes PMD 1.1 (sub-component)
  ├─ includes PMD 2 (leaf component)
  └─ includes PMD 3 (composite component)
      └─ includes PMD 3.1 (sub-component)
```

### Jinja2 Features

**Supported syntax**:
- Variables: `{{ variable_name }}`
- Includes: `{% include "path.pmd" %}`
- Control flow: `{% if condition %}`, `{% for item in list %}`
- Comments: `{# comment #}`

**Include resolution**:
- Relative to current file's directory
- Supports nested folders: `components/roles/expert.pmd`
- Unlimited nesting depth

---

## Plugin Structure

This repository follows Claude Code plugin conventions.

**Important**: The `ymd-spec/` directory becomes active when:

1. Users run the installer which copies to `~/.claude/ymd-spec/`, OR
2. Projects explicitly reference it in their project-level `CLAUDE.md`

**Command workflow**:
```bash
# User runs command
/create-ymd-manifest

# Command file (thin wrapper)
commands/create-ymd-manifest.md:
  @~/.claude/ymd-spec/prompts/create-ymd.md

# Business logic (full prompt)
ymd-spec/prompts/create-ymd.md:
  [Complete YMD creation logic with examples and validation]
```

**Agent workflow**:
```markdown
<!-- Agent file (thin context) -->
agents/ymd-author.md:
  You are a YMD/PMD authoring specialist.

  @~/.claude/ymd-spec/prompts/author-guide.md
  @~/.claude/ymd-spec/spec/ymd_format.md
  @~/.claude/ymd-spec/spec/pmd_format.md
```

---

## Format Philosophy

### YMD = Orchestrator
- Aggregates PMD components
- Contains YAML metadata
- Defines complete prompt structure
- Customizable sections (not just standard)

### PMD = Component
- Reusable building blocks
- No YAML (pure Markdown + Jinja2)
- Can compose recursively (PMDs include PMDs)
- Leaf or composite patterns

### Composition Principles
1. **YMD orchestrates** → includes PMDs to build final prompt
2. **PMDs compose** → can include other PMDs recursively
3. **Unlimited nesting** → no depth restrictions
4. **Clear separation** → YMD has metadata, PMD is content

### Design Patterns

**Leaf PMDs** (no includes):
```markdown
<!-- roles/expert.pmd -->
You are an expert in {{ domain }}.
```

**Composite PMDs** (includes other PMDs):
```markdown
<!-- roles/senior_dev.pmd -->
You are a senior developer.

{% include "shared/principles.pmd" %}
{% include "shared/communication_style.pmd" %}
```

**YMD Orchestration** (includes PMDs):
```yaml
meta:
  id: code_review
  kind: review
  version: 1.0.0
  title: Code Review Workflow

system: |
  {% include "roles/senior_dev.pmd" %}

instructions: |
  {% include "tasks/code_review.pmd" %}
  {% include "checklists/security.pmd" %}
```

---

## Git Workflow

Current branch: **main**

When making commits:
- Use descriptive commit messages explaining WHY changes were made
- Group related changes (e.g., "Update specification and examples together")
- Tag releases using semantic versioning (e.g., `v0.1.0`, `v1.0.0`)

---

## Design Philosophy: Modularity and Composition

**Core insight**: YMD/PMD enables modular prompt engineering through clear separation of concerns.

**Benefits**:
- **Reusability**: PMDs can be shared across multiple YMDs
- **Maintainability**: Update PMD once, affects all YMDs that include it
- **Testability**: Test PMDs independently with different variables
- **Versioning**: Track changes to individual components
- **Collaboration**: Team members can work on different PMDs simultaneously

**Example workflow**:
```
1. Create reusable PMD components:
   - roles/senior_dev.pmd
   - checklists/security.pmd
   - formats/json_response.pmd

2. Compose YMD manifests:
   - code_review.ymd (includes senior_dev + security)
   - api_design.ymd (includes senior_dev + json_response)

3. Both YMDs benefit from updates to senior_dev.pmd
```

---

## Contributing to This Repository

When proposing changes:

1. **Specification changes**: Update `ymd-spec/*.md` files first
2. **Prompt changes**: Update `ymd-spec/prompts/` (business logic)
3. **Command changes**: Keep thin, reference prompts in `~/.claude/ymd-spec/prompts/`
4. **Agent changes**: Keep thin, reference specs/prompts in `~/.claude/ymd-spec/`
5. **Example changes**: Ensure examples demonstrate real-world patterns
6. **Documentation**: Keep `docs/` synchronized with specifications
7. **Installation**: Test `install.sh` on clean systems before committing

**Architecture guidelines**:
- **NO duplication** between commands/agents and specs/prompts
- **Thin wrappers** for commands/agents
- **Business logic** goes in `ymd-spec/prompts/`
- **Specifications** go in `ymd-spec/*.md`
- **Context** goes in `ymd-spec/context/`

---

## Available Tools

### Slash Commands
- `/load-ymd-context` - Load YMD/PMD format context
- `/create-ymd-manifest` - Create new YMD file
- `/create-pmd-partial` - Create new PMD file
- `/validate-composition` - Validate YMD→PMD include chains

### Specialized Agents
- **ymd-author** - YMD/PMD authoring specialist
- **composition-expert** - Composition pattern expert
- **ymd-validator** - Format and composition validator

---

## Installation Flow

```bash
# 1. Clone repository
git clone https://github.com/daviguides/ymd-spec.git

# 2. Run installer
cd ymd-spec
bash install.sh

# 3. Installer copies ymd-spec/ → ~/.claude/ymd-spec/

# 4. Commands/agents can now reference:
@~/.claude/ymd-spec/spec/ymd_format.md
@~/.claude/ymd-spec/prompts/create-ymd.md
# etc.
```

---

## Example Structure

**Simple examples** (`examples/simple/`):
- `basic.ymd` - Standard sections
- `custom-sections.ymd` - Custom sections
- `role.pmd` - Leaf PMD
- `composed-role.pmd` - Composite PMD

**Complete example** (`examples/ymd-pmd/`):
- GitHub PR description generator
- Shows real-world composition patterns
- Multiple PMD components
- Variable usage and includes

---

## Next Steps

See project README.md for:
- Installation instructions
- Usage guide
- Format specifications
- Examples and patterns
