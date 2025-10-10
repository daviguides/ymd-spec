# YMD/PMD Format Specification

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
<a href="http://daviguides.github.io"><img src="https://img.shields.io/badge/built%20with-%E2%9D%A4%EF%B8%8F%20by%20Davi%20Guides-orange"></a>

> Official specification and Claude Code plugin for **YMD** (YAML + Markdown + Jinja2) and **PMD** (Prompt Markdown + Jinja2) formats —
> enabling structured, modular, and reusable AI prompts.

---

## What are YMD and PMD?

**YMD** and **PMD** are file formats designed for prompt engineering that combine the best of YAML, Markdown, and Jinja2 templating.

This repository serves a **triple purpose**:

- **Format Specification**: Official documentation of YMD and PMD formats for humans and LLMs
- **Claude Code Plugin**: Tools for authoring, validating, and composing YMD/PMD files
- **Reference Implementation**: Examples and patterns for structured prompts

---

## Quick Start

### One-Line Installation (Claude Code Plugin)

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/daviguides/ymd-spec/main/install.sh)"
```

The installer will:

1. Clone the latest version from GitHub
2. Copy `ymd-spec/` to `~/.claude/ymd-spec/`
3. Optionally configure `~/.claude/CLAUDE.md`
4. Clean up temporary files automatically

---

## Format Overview

### YMD: Prompt Manifests (Orchestrators)

`.ymd` files are **complete prompt definitions** with metadata and customizable sections.

**Structure**:
```yaml
# Metadata (YAML)
meta:
  id: pr_description_generator
  kind: gh_pr
  version: 0.1.0
  title: Generate GitHub Pull Request Description

# Sections (Markdown + Jinja2)
system: |
  You are a **senior maintainer** writing reviewer-friendly PR descriptions.
  {% include "gh_pr/system_goals.pmd" %}

instructions: |
  {% include "gh_pr/sections.pmd" %}

expected_output: |
  {% include "gh_pr/example.pmd" %}

user: |
  Context and diff:
  ```diff
  {{ diff }}
  ```
```

**Key features**:
- **YAML metadata grouped under `meta:`**: `id`, `kind`, `version`, `title`
- **Customizable sections**: Standard (`system`, `instructions`, `user`) or custom (`context`, `constraints`)
- **Markdown content**: Rich formatting in block scalars (`|`)
- **Jinja2 templating**: Variables `{{ }}`, includes `{% %}`, control flow
- **PMD composition**: Include reusable components

### PMD: Prompt Components (Building Blocks)

`.pmd` files are **reusable Markdown blocks** for composition.

**Structure**:
```markdown
<!-- Pure Markdown + Jinja2 (no YAML) -->

You are a **{{ role_type }}** with expertise in:
- {{ primary_language }} development
- {{ domain }} best practices

{% include "../shared/code_principles.pmd" %}
```

**Key features**:
- **No YAML**: Pure Markdown + Jinja2
- **Reusable**: Shared across multiple YMD files
- **Composable**: PMDs can include other PMDs recursively
- **Modular**: Leaf components or composite components

---

## Composition Patterns

### YMD Orchestrates PMDs

YMD files are **orchestrators** that compose PMD components:

```
GitHub PR YMD (orchestrator)
  ├─ system section
  │   └─ includes roles/maintainer.pmd
  │       └─ includes shared/principles.pmd
  ├─ instructions section
  │   ├─ includes tasks/pr_analysis.pmd
  │   └─ includes checklists/quality.pmd
  └─ user section
      └─ includes formats/diff_context.pmd
```

### PMDs Compose Recursively

PMD files can include other PMDs:

```markdown
<!-- roles/senior_dev.pmd (composite) -->
You are a senior software engineer.

{% include "../shared/code_principles.pmd" %}
{% include "../shared/communication_style.pmd" %}
```

---

## Usage

### As a Format Specification

Use YMD/PMD to structure your AI prompts:

1. **Create reusable PMD components**:
   - `roles/expert.pmd` - Role definitions
   - `checklists/security.pmd` - Verification lists
   - `formats/json_response.pmd` - Output formats

2. **Compose YMD manifests**:
   - `code_review.ymd` - Includes expert role + security checklist
   - `api_design.ymd` - Includes expert role + json_response format

3. **Benefit from modularity**:
   - Update `expert.pmd` once → affects all YMDs that include it
   - Test PMDs independently with different variables
   - Version control individual components

### As a Claude Code Plugin

Once installed, you can use YMD/PMD tools in three ways:

#### **Option 1: Slash Commands (Recommended for Sessions)**

Load YMD/PMD context for your current session:

```bash
/load-ymd-context
```

**Available Commands:**
- `/load-ymd-context` - Load complete YMD/PMD format context
- `/create-ymd-manifest` - Create new YMD file with scaffolding
- `/create-pmd-partial` - Create new PMD component
- `/validate-composition` - Validate YMD→PMD include chains

#### **Option 2: Global CLAUDE.md (Automatic)**

Reference in your `~/.claude/CLAUDE.md` for automatic loading:

```markdown
# YMD/PMD Format Support

@~/.claude/ymd-spec/context/format-guidelines.md
```

#### **Option 3: Project CLAUDE.md (Project-Specific)**

Reference in your project's `CLAUDE.md`:

```markdown
# Project Prompt Standards

## Format Specification
- **INHERITS FROM**: @./ymd-spec/context/format-guidelines.md
- **EXAMPLES**: @./ymd-spec/context/examples.md
```

### Specialized Agents

The plugin includes specialized agents:

- **ymd-author** - YMD/PMD authoring specialist
- **composition-expert** - Helps design YMD→PMD structures
- **ymd-validator** - Validates format and include chains

---

## Format Specifications

### YMD Format

**File extension**: `.ymd` or `.yamd`

**Required metadata**:
```yaml
meta:
  id: unique_identifier
  kind: prompt_type
  version: semver
  title: Human-readable title
```

**Standard sections** (common patterns):
- `system` - Role/persona definition
- `instructions` - Step-by-step tasks
- `expected_output` - Output format specification
- `developer` - Implementation notes
- `user` - User input template

**Custom sections**:
- Any valid YAML key name
- Same syntax: `section_name: |`
- Same Markdown + Jinja2 support

**Jinja2 features**:
- Variables: `{{ variable_name }}`
- Includes: `{% include "path.pmd" %}`
- Control flow: `{% if %}`, `{% for %}`
- Comments: `{# comment #}`

### PMD Format

**File extension**: `.pmd`

**Structure**:
- Pure Markdown + Jinja2
- No YAML metadata

**Patterns**:
- **Leaf PMDs**: No includes, pure content
- **Composite PMDs**: Include other PMDs recursively

**Jinja2 features**:
- Same as YMD (variables, includes, control flow)

---

## Examples

### Simple YMD with Standard Sections

```yaml
meta:
  id: code_reviewer
  kind: code_analysis
  version: 1.0.0
  title: Code Review Assistant

system: |
  You are a code review specialist.

instructions: |
  1. Analyze code quality
  2. Check for security issues
  3. Suggest improvements

user: |
  Review this code:
  ```{{ language }}
  {{ code }}
  ```
```

### YMD with Custom Sections

```yaml
meta:
  id: api_designer
  kind: api_design
  version: 1.0.0
  title: API Design Assistant

system: |
  You are an API design expert.

context: |
  This API will be used by {{ target_audience }}.

constraints: |
  - RESTful principles
  - JSON responses only
  - Maximum response time: {{ max_response_time }}ms

user: |
  Design an API for: {{ requirement }}
```

### Leaf PMD (No Includes)

```markdown
<!-- roles/expert.pmd -->
You are an expert in **{{ domain }}** with {{ years_experience }}+ years of experience.
```

### Composite PMD (With Includes)

```markdown
<!-- roles/senior_dev.pmd -->
You are a senior software engineer specializing in {{ primary_language }}.

{% include "../shared/code_principles.pmd" %}
{% include "../shared/communication_style.pmd" %}
```

---

## Why YMD/PMD?

### Benefits

- ✅ **Modularity**: Break large prompts into reusable components
- ✅ **Reusability**: Share PMDs across multiple YMD files
- ✅ **Maintainability**: Update PMD once, affects all consumers
- ✅ **Versioning**: Track changes to individual components
- ✅ **Testability**: Test PMDs independently with different variables
- ✅ **Collaboration**: Team members work on different PMDs simultaneously
- ✅ **Customization**: Sections are fully customizable, not limited to standard set

### Comparison with Alternatives

| Approach | Modularity | Type Safety | Templating | Customization |
|----------|------------|-------------|------------|---------------|
| **Plain Text** | ❌ No | ❌ No | ❌ No | ✅ Yes |
| **Markdown** | ⚠️ Limited | ❌ No | ❌ No | ✅ Yes |
| **YAML** | ⚠️ Limited | ✅ Yes | ❌ No | ✅ Yes |
| **YMD/PMD** | ✅ Yes | ✅ Yes | ✅ Yes | ✅ Yes |

---

## Related Projects

- **vscode-ymd**: VSCode extension for YMD/PMD syntax highlighting and navigation
  - GitHub: [daviguides/vscode-ymd-syntax](https://github.com/daviguides/vscode-ymd-syntax)
  - Marketplace: [YMD/PMD Syntax Highlighting](https://marketplace.visualstudio.com/items?itemName=daviguides.ymd-syntax)

- **ymd-prompt**: Python library for loading and rendering YMD/PMD files
  - GitHub: [daviguides/ymd-prompt](https://github.com/daviguides/ymd-prompt)
  - PyPI: `pip install ymd-prompt` (coming soon)

---

## Documentation

- **Full Specification**: See [docs/](./docs/) for human-readable format documentation
- **LLM Specifications**: See [ymd-spec/](./ymd-spec/) for LLM-optimized format specs
- **Examples**: See [examples/](./examples/) for practical patterns
- **Plugin Guide**: See [CLAUDE.md](./CLAUDE.md) for development guidance

---

## Contributing

Contributions are welcome! You can propose new features, refine examples, or extend the plugin.

1. Fork the repo
2. Create a feature branch
3. Submit a PR

---

## License

MIT License - See [LICENSE](./LICENSE) for details

---

## Author

Built with ❤️ by [Davi Guides](http://daviguides.github.io) - enabling structured, modular, and reusable AI prompts.
