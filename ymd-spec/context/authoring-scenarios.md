# Authoring Scenarios & Solutions

**Purpose**: Common scenarios users encounter when creating YMD/PMD files with solutions.

**For workflow**: See @../prompts/author-guide.md

---

## Scenario 1: First-Time User

### Situation
User has never created YMD/PMD before and wants to start simple.

### Approach
Start minimal, teach fundamentals progressively.

### Conversation

```
You: "Welcome! Let's start with the basics. YMD/PMD is for creating modular AI prompts:
      - YMD = Complete prompt with metadata
      - PMD = Reusable component

      For your first prompt, let's keep it simple. What should the AI help with?"

User: "Help me review code"

You: "Perfect! We'll create a simple code review YMD. The minimum you need:

      meta:
        id: my_code_reviewer
        kind: review
        version: 1.0.0
        title: My Code Reviewer

      user: |
        Review this code:
        {{ code }}

      That's it! As you get comfortable, we can add:
      - A reviewer persona (roles/senior_dev.pmd)
      - Review checklists (checklists/quality.pmd)
      - Output format (formats/review_comment.pmd)

      Ready to create it?"
```

### Outcome
User gets working YMD immediately, learns incrementally.

---

## Scenario 2: Converting Existing Prompt

### Situation
User has a large existing prompt as plain text, wants to convert to YMD/PMD.

### Approach
Analyze, map, extract reusable parts.

### Conversation

```
User: "I have this 200-line prompt I want to convert"
You: "Great! Let me analyze it... [reads]

      I see these parts:
      1. Lines 1-40: Expert developer persona
      2. Lines 41-120: Python-specific guidelines
      3. Lines 121-150: Security checklist
      4. Lines 151-200: Output format specification

      This maps to YMD/PMD like this:

      YMD (code_review.ymd):
      ```yaml
      meta: [...]
      system: {% include "roles/python_expert.pmd" %}
      guidelines: {% include "languages/python_guidelines.pmd" %}
      security: {% include "checklists/security.pmd" %}
      expected_output: {% include "formats/review_comment.pmd" %}
      user: {{ user_input }}
      ```

      PMDs to create:
      - roles/python_expert.pmd (lines 1-40)
      - languages/python_guidelines.pmd (lines 41-120)
      - checklists/security.pmd (lines 121-150)
      - formats/review_comment.pmd (lines 151-200)

      Benefits:
      - Reuse python_guidelines in other prompts
      - Reuse security checklist anywhere
      - Easier to maintain (update once, affects all uses)

      Want me to do the conversion?"
```

### Outcome
Existing prompt becomes modular, reusable components extracted.

---

## Scenario 3: Debugging Circular Dependency

### Situation
User gets "Circular include detected" error.

### Approach
Trace the chain, identify cycle, propose solution.

### Conversation

```
User: "I'm getting 'Circular include detected' error"
You: "Let's debug this systematically. Can you share the files involved?"
User: [shares main.ymd, a.pmd, b.pmd]

You: "Found it! Let me trace the include chain:

      main.ymd includes a.pmd
        a.pmd includes b.pmd
          b.pmd includes a.pmd ← Back to a.pmd! Circular!

      Looking at the content, I see a.pmd and b.pmd both need the same
      'core principles' content. That's what's causing the circle.

      Solution: Extract shared content

      1. Create shared/core_principles.pmd with the common content
      2. Both a.pmd and b.pmd include shared/core_principles.pmd
      3. Remove the circular include

      New structure:
      main.ymd includes a.pmd
        a.pmd includes shared/core_principles.pmd
        a.pmd includes b.pmd
          b.pmd includes shared/core_principles.pmd

      No more circle! Want me to help refactor?"
```

### Outcome
Circular dependency resolved, better structure achieved.

---

## Scenario 4: Choosing Between Inline and Include

### Situation
User unsure whether to put content inline or create separate PMD.

### Approach
Apply decision criteria, explain trade-offs.

### Conversation

```
User: "Should I put this role definition inline or in a separate PMD?"
You: "Let's think through it using these criteria:

      Create separate PMD if:
      ✅ Content is >10 lines (yours is 30)
      ✅ Might reuse in other prompts (senior dev role - very likely!)
      ✅ Standard component type (roles are standard)

      Keep inline if:
      ❌ Very short (<10 lines)
      ❌ Unique to this one prompt only
      ❌ Simple variable usage

      For your case:
      - 30 lines = substantial
      - Senior dev role = highly reusable
      - Standard role category

      Recommendation: Create roles/senior_developer.pmd

      Benefits:
      - Reuse in other review prompts
      - Update once, affects all uses
      - Keeps YMD thin and readable

      Your YMD becomes:
      system: |
        {% include 'roles/senior_developer.pmd' %}

      Much cleaner!"
```

### Outcome
User makes informed decision, understands criteria for future.

---

## Scenario 5: Complex Multi-Stage Workflow

### Situation
User needs to create prompt for complex workflow with multiple phases.

### Approach
Use custom sections, organized composition.

### Conversation

```
User: "I need a prompt for software project review with prep, execution, and validation phases"
You: "For multi-stage workflows, I recommend custom sections organized by phase.
      This makes the structure self-documenting.

      Structure:

      ```yaml
      meta:
        id: project_review_workflow
        kind: workflow
        version: 1.0.0
        title: Multi-Stage Project Review

      system: |
        {% include 'roles/senior_architect.pmd' %}

      preparation_phase: |
        {% include 'workflow/preparation.pmd' %}

      execution_phase: |
        {% include 'workflow/code_review.pmd' %}
        {% include 'workflow/architecture_review.pmd' %}

      validation_phase: |
        {% include 'workflow/validation.pmd' %}

      quality_gates: |
        {% include 'checklists/quality_gates.pmd' %}

      expected_output: |
        {% include 'formats/review_report.pmd' %}
      ```

      PMDs to create:
      - roles/senior_architect.pmd
      - workflow/preparation.pmd
      - workflow/code_review.pmd
      - workflow/architecture_review.pmd
      - workflow/validation.pmd
      - checklists/quality_gates.pmd
      - formats/review_report.pmd

      This gives you:
      - Clear phase separation
      - Self-documenting structure
      - Reusable workflow components

      Sound good?"
```

### Outcome
Complex workflow organized clearly with custom sections.

---

## Scenario 6: Supporting Multiple Languages

### Situation
User wants one prompt that works for multiple programming languages.

### Approach
Use parameterized includes pattern.

### Conversation

```
User: "I want code review for Python, JavaScript, and Go"
You: "Perfect use case for the Parameterized Pattern!
      Instead of creating 3 separate YMDs, use one with dynamic includes:

      ```yaml
      meta:
        id: multi_language_review
        kind: review
        version: 1.0.0
        title: Multi-Language Code Reviewer

      system: |
        {% include 'roles/polyglot_developer.pmd' %}

      language_guidelines: |
        {% include 'languages/{{ language }}_guidelines.pmd' %}

      review_focus: |
        {% include 'checklists/universal_quality.pmd' %}
        {% include 'checklists/{{ language }}_specific.pmd' %}

      user: |
        Review this {{ language }} code:
        ```{{ language }}
        {{ code }}
        ```
      ```

      PMDs to create:
      - languages/python_guidelines.pmd
      - languages/javascript_guidelines.pmd
      - languages/go_guidelines.pmd
      - checklists/python_specific.pmd
      - checklists/javascript_specific.pmd
      - checklists/go_specific.pmd

      To add new language (e.g., Rust):
      1. Create languages/rust_guidelines.pmd
      2. Create checklists/rust_specific.pmd
      3. That's it! No YMD changes needed.

      Super scalable!"
```

### Outcome
Scalable multi-language support with minimal YMD changes.

---

## Scenario 7: Too Deep Composition

### Situation
User created 7-level deep composition tree, hard to follow.

### Approach
Flatten structure, reduce indirection.

### Conversation

```
User: "My composition is getting confusing"
You: "Let me check... [analyzes]

      Current depth: 7 levels

      YMD → A → B → C → D → E → F → G

      Recommended max: 5 levels

      Looking at your structure, I see:
      - Levels 5-6-7 could be combined
      - Level E and F are very small (5 lines each)

      Refactored structure:

      YMD → A → B → C → D-E-F-Combined

      Now: 5 levels (much better!)

      Changes:
      1. Merge E.pmd + F.pmd + G.pmd → E-Combined.pmd
      2. Update D.pmd to include E-Combined.pmd
      3. Delete old E.pmd, F.pmd, G.pmd

      Benefits:
      - Easier to understand
      - Fewer files to manage
      - Same functionality

      Want me to help with the merge?"
```

### Outcome
Flattened structure, improved clarity.

---

## Scenario 8: PMD vs YMD Confusion

### Situation
User trying to add metadata to PMD file.

### Approach
Clarify distinction, explain concept.

### Conversation

```
User: "How do I add version metadata to my PMD?"
You: "Great question! This touches on a core concept:

      **PMDs don't have metadata**

      Here's why:

      YMD = Orchestrator
      - Has identity (id, version)
      - Entry point
      - Gets versioned and tracked

      PMD = Component
      - Building block
      - No independent identity
      - Inherits context from what includes it

      Think of it like code:
      ```python
      # main.py (like YMD)
      version = '1.0.0'  # Has version

      def main():
          from helpers import task  # (like PMD)
          task()  # helpers.py doesn't need its own version
      ```

      If you need versioning, you want a YMD, not a PMD.

      Did you mean to create a YMD instead?"

User: "Oh! Yes, I want a complete prompt with version."
You: "Perfect! Let's create a YMD that includes your content as a PMD..."
```

### Outcome
User understands YMD/PMD distinction, creates correct file type.

---

## Scenario 9: Optimizing Existing Structure

### Situation
User has working YMD/PMD but wants to improve it.

### Approach
Review, identify opportunities, suggest improvements.

### Conversation

```
User: "Can you review my structure for improvements?"
You: "Sure! Let me analyze... [reviews files]

      Current state: ⭐⭐⭐ (Good, but can improve)

      Strengths:
      - ✅ Good naming
      - ✅ No circular dependencies
      - ✅ Appropriate sections

      Improvement opportunities:

      1. Extract duplication (Priority: High)
         - security_guidelines content appears in 3 PMDs
         - → Extract to shared/security_guidelines.pmd
         - Saves: ~60 lines of duplication

      2. Slim down YMD (Priority: Medium)
         - 35 lines of inline content in 'context' section
         - → Extract to context/project_context.pmd
         - Improves: Readability, reusability

      3. Better categorization (Priority: Low)
         - api_patterns.pmd is in shared/
         - → Move to principles/api_patterns.pmd
         - Benefit: Clearer organization

      Want help implementing these?"
```

### Outcome
Structured improvement plan, prioritized actions.

---

## Scenario 10: Creating Reusable Component Library

### Situation
Team wants to build shared PMD library for consistency.

### Approach
Plan structure, establish conventions, create templates.

### Conversation

```
User: "We want a shared PMD library for our team"
You: "Excellent! Let's set this up properly:

      1. Directory Structure:
      ```
      company-prompts/
      ├── roles/
      │   ├── senior_engineer.pmd
      │   ├── product_manager.pmd
      │   └── data_scientist.pmd
      ├── checklists/
      │   ├── code_quality.pmd
      │   ├── security.pmd
      │   └── performance.pmd
      ├── formats/
      │   ├── review_comment.pmd
      │   ├── technical_spec.pmd
      │   └── test_report.pmd
      └── company/
          ├── engineering_principles.pmd
          └── communication_standards.pmd
      ```

      2. Team Conventions:
      - Naming: snake_case, descriptive
      - Variables: Always document
      - Reviews: Required for PMD changes
      - Versioning: Track in commit messages

      3. Starter Templates:

      Role template:
      ```markdown
      {# Role: [Name]
         Purpose: [...]
         Expected variables: [...]
      #}

      You are a **[title]** with [details].
      ...
      ```

      4. Usage Guide:
      - Document each PMD's purpose
      - Provide usage examples
      - Maintain changelog

      Want me to create the starter files?"
```

### Outcome
Team has organized, documented PMD library with conventions.

---

## Common Patterns Across Scenarios

### Pattern: Clarify Then Create
1. Ask questions to understand
2. Propose structure
3. Get confirmation
4. Generate files

### Pattern: Show Trade-offs
1. Present options
2. Explain pros/cons
3. Recommend best for context
4. Support user's choice

### Pattern: Iterative Improvement
1. Start simple
2. Add complexity gradually
3. Refine through feedback
4. Optimize when working

### Pattern: Teach by Example
1. Show concrete example
2. Explain why it works
3. Connect to user's case
4. Encourage trying it
