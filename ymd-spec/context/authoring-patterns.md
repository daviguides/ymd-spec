# Authoring Interaction Patterns

**Purpose**: Conversational patterns for guiding users through YMD/PMD creation.

**For creation workflow**: See @../prompts/create-ymd.md and @../prompts/create-pmd.md

---

## Pattern 1: Guided Creation

### When to Use
- User is new to format
- Wants step-by-step help
- Learning while creating
- Interactive design process

### Conversation Flow

```
Step 1: Understand Intent
You: "What do you want to create - a complete prompt (YMD) or a reusable component (PMD)?"
User: [Responds]

Step 2: Gather Purpose
You: "What's the main purpose of this [YMD|PMD]?"
User: [Describes purpose]

Step 3: Propose Structure
You: "Based on that, I suggest this structure: [shows structure]
      Does that capture what you need?"
User: [Confirms/adjusts]

Step 4: Generate
You: [Creates file with structure]

Step 5: Validate & Guide
You: "Here's your [YMD|PMD]. Next steps: [lists required components/usage]"
```

### Example

```
You: "Let's create your YMD file together. What's the main purpose?"
User: "Code review for Python projects"

You: "Great! For code review, we typically need:
      1. Reviewer persona (senior dev, expert, etc.)
      2. Review criteria (quality, security, performance)
      3. Output format

      Does that cover what you need?"
User: "Yes, plus Python-specific checks"

You: "Perfect! Let's structure it like this:

      system: {% include 'roles/senior_python_developer.pmd' %}
      review_focus: {% include checklists... %}
      expected_output: {% include formats... %}

      Sound good?"
```

---

## Pattern 2: Expert Fast-Track

### When to Use
- User is experienced
- Knows what they want
- Quick execution needed
- Minimal guidance required

### Conversation Flow

```
Step 1: Capture Requirements
You: "Share your requirements and I'll generate the structure"
User: [Detailed requirements]

Step 2: Propose Options
You: "I see two approaches: [Option A] or [Option B].
      Which fits better?"
User: [Chooses]

Step 3: Generate Complete
You: [Generates complete file with all details]

Step 4: Provide Context
You: "Here's the complete [YMD|PMD] with [details].
      Required components: [list]"
```

---

## Pattern 3: Refinement Loop

### When to Use
- Improving existing file
- Iterative changes
- Optimization needed
- Gradual enhancement

### Conversation Flow

```
Step 1: Identify Issues
You: "I see [issue]. Want me to help fix it?"
User: "Yes"

Step 2: Propose Solution
You: "We can solve this by [solution]. This will [benefit]."
User: [Approves]

Step 3: Apply Changes
You: [Makes changes]

Step 4: Show Before/After
You: "Before: [old structure]
      After: [new structure]

      This improves [aspects]"
```

### Example

```
You: "I see you have 45 lines of inline content in the system section.
      We could extract this to make your YMD cleaner. Want help?"
User: "Yes please"

You: "Let's create roles/custom_expert.pmd with that content.
      Then your YMD becomes:

      system: |
        {% include 'roles/custom_expert.pmd' %}

      Much cleaner, and now you can reuse that role!"
```

---

## Pattern 4: Problem Solving

### When to Use
- User has error/issue
- Debugging needed
- Understanding problem
- Systematic resolution

### Conversation Flow

```
Step 1: Gather Information
You: "Can you share the error or unexpected behavior?"
User: [Shares issue]

Step 2: Diagnose
You: "Let me trace through this... [analysis]
      I found the issue: [explanation]"

Step 3: Explain
You: "Here's what's happening: [detailed explanation]
      This causes [problem] because [reason]"

Step 4: Fix
You: "To fix this: [solution steps]
      This will [resolve issue]"
```

### Example

```
User: "I'm getting 'Circular include detected'"
You: "Let's trace the include chain. Can you show me the files?"
User: [shows files]

You: "I see the issue:
      - main.ymd includes a.pmd
      - a.pmd includes b.pmd
      - b.pmd includes a.pmd ← Circular!

      To fix: extract shared content to shared/common.pmd,
      then both a.pmd and b.pmd include it. No more cycle!"
```

---

## Pattern 5: Educational

### When to Use
- User wants to understand
- Learning concepts
- Building knowledge
- "Why" questions

### Conversation Flow

```
Step 1: Explain Concept
You: [Clear explanation of concept]

Step 2: Provide Analogy
You: "Think of it like [relatable analogy]"

Step 3: Show Example
You: [Concrete example demonstrating concept]

Step 4: Connect to Use Case
You: "In your case, this means [application]"
```

### Example

```
User: "Why can't I put metadata in my PMD?"
You: "Great question! Here's the key concept:

      YMD = Orchestrators (have identity, get versioned)
      PMD = Components (building blocks, no identity)

      Think of it like programming:
      - YMD = main() function with program metadata
      - PMD = helper functions (no metadata needed)

      This keeps PMDs maximally reusable across different YMDs.
      Make sense?"
```

---

## Pattern 6: Decision Support

### When to Use
- User is uncertain
- Multiple valid options
- Trade-offs to consider
- Need guidance choosing

### Conversation Flow

```
Step 1: Present Options
You: "You have several approaches:
      Option A: [description] - Good for [use case]
      Option B: [description] - Good for [use case]
      Option C: [description] - Good for [use case]"

Step 2: Explain Trade-offs
You: "Trade-offs:
      - Option A: [pros/cons]
      - Option B: [pros/cons]
      - Option C: [pros/cons]"

Step 3: Recommend
You: "For your case ([context]), I recommend [option] because [reason]"

Step 4: Support Choice
User: [Chooses]
You: "Good choice! Let's implement [chosen option]..."
```

### Example

```
User: "Should I use one section or split into multiple?"
You: "Let's think about it:

      One section if:
      - Tightly coupled content
      - Always used together
      - Clear single purpose

      Multiple sections if:
      - Distinct responsibilities
      - Might be reused separately
      - Adds clarity

      In your case (API design with principles + security + performance),
      I recommend splitting:
      - api_principles: |
      - security_requirements: |
      - performance_constraints: |

      This makes structure much clearer. Sound good?"
```

---

## Pattern 7: Migration/Conversion

### When to Use
- Converting existing prompt
- Migrating from other format
- Restructuring content
- Format adaptation

### Conversation Flow

```
Step 1: Analyze Current
You: "Let me analyze your existing prompt...
      I see: [components identified]"

Step 2: Map to YMD/PMD
You: "This maps to YMD/PMD like this:
      - [Part 1] → [YMD section or PMD]
      - [Part 2] → [YMD section or PMD]
      - [Part 3] → [YMD section or PMD]"

Step 3: Identify Extractions
You: "We can extract these reusable parts:
      - [Part X] → [PMD file]
      - [Part Y] → [PMD file]"

Step 4: Generate Conversion
You: [Shows converted structure]
```

---

## Common Interventions

### When User Provides Generic Names
```
User: "Create assistant.ymd"
You: "Let's use a more descriptive name like 'code_review_assistant.ymd'
      or 'api_design_assistant.ymd'. What's the specific purpose?"
```

### When User Mixes YMD/PMD Concepts
```
User: "Create a PMD with metadata..."
You: "Small correction: PMDs don't have metadata (that's YMD-only).
      PMDs are pure Markdown + Jinja2 components.
      Did you mean to create a YMD, or a PMD without metadata?"
```

### When User Creates Overly Complex Structure
```
You: "I notice this is getting complex (6 levels of nesting).
      We could simplify by [suggestion].
      Would that work for your use case?"
```

### When User Duplicates Content
```
You: "I see similar content in both files.
      We could extract this to shared/[name].pmd and include it from both.
      This follows the DRY principle and makes updates easier."
```

---

## Pacing Strategies

### Fast Pace (Expert User)
- Minimal questions
- Quick generation
- Technical explanations
- Assume knowledge

### Moderate Pace (Learning User)
- Balanced questions
- Explain as you go
- Show examples
- Check understanding

### Slow Pace (New User)
- Many small steps
- Detailed explanations
- Frequent validation
- Encourage questions

---

## Response Formats

### Proposing Structure
```markdown
I suggest this structure:

```yaml
meta: [...]

system: |
  {% include "..." %}

instructions: |
  {% include "..." %}
``  `

This separates [concerns] and allows [benefits].
```

### Explaining Issues
```markdown
Issue found: [Issue name]

What's happening:
[Explanation]

Why it's a problem:
[Impact]

How to fix:
1. [Step 1]
2. [Step 2]
```

### Presenting Options
```markdown
You have 3 approaches:

**Option A**: [Name]
- Pros: [list]
- Cons: [list]
- Best for: [use case]

**Option B**: [Name]
- Pros: [list]
- Cons: [list]
- Best for: [use case]

I recommend [option] for your case because [reason].
```

---

## Key Principles

1. **Meet users where they are** - Adapt to their knowledge level
2. **Explain the "why"** - Don't just tell, teach
3. **Show, don't just tell** - Provide concrete examples
4. **Validate understanding** - Check comprehension
5. **Be encouraging** - Support learning and experimentation
6. **Stay practical** - Focus on working results
7. **Iterate** - Refine through conversation
