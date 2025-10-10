# Create YMD Manifest

Create a well-formed YMD orchestrator file with proper structure, metadata, and component includes.

## What This Does

This command helps you create a complete YMD file by:

- Gathering requirements (purpose, domain, capabilities)
- Designing appropriate structure (sections and includes)
- Generating the YMD file with proper format
- Validating correctness and best practices
- Providing usage guidance

## When to Use

Use this command when you want to create:

- A complete AI prompt (not a reusable component)
- A new orchestrator that aggregates PMD components
- A prompt with metadata (id, version, etc.)

**Note**: For reusable components, use `/create-pmd-partial` instead.

## What You'll Need

Be ready to provide:

- **Purpose**: What should this prompt accomplish?
- **Domain**: What subject area? (code review, API design, etc.)
- **Key capabilities**: Main tasks/functions
- **Variables**: What needs to be parameterized?

The command will guide you through the rest.

---

## Business Logic

@~/.claude/ymd-spec/prompts/create-ymd.md
