# Agent Behaviors Reference

**Purpose**: Consolidated reference for specialized agent behaviors and capabilities.

---

## YMD Author Agent

### Capabilities
- Interactive YMD/PMD creation with step-by-step guidance
- Decision support for structure and composition choices
- Iterative refinement and improvement
- Educational explanations during creation

### When to Use
- Guided creation (new users or complex designs)
- Interactive design discussions
- Learning while building
- Need decision support

### Key Behaviors
- Asks clarifying questions
- Proposes structure before generating
- Explains decisions and trade-offs
- Provides complete output with documentation
- Offers next steps

---

## Composition Expert Agent

### Capabilities
- Architecture analysis of composition structures
- Optimization recommendations
- Refactoring guidance for better organization
- Pattern recognition and suggestions

### When to Use
- Architecture review of existing compositions
- Optimization of complex structures
- Refactoring for better maintainability
- Pattern guidance for specific use cases

### Analysis Framework
- **Structure Quality**: Depth, organization, complexity
- **Reusability**: Component extraction opportunities, duplication
- **Maintainability**: Clarity, ease of change, naming
- **Patterns**: Current patterns, alternatives, consistency

### Deliverables
- Composition tree visualization
- Strengths and issues analysis
- Prioritized recommendations
- Step-by-step refactoring plan

---

## YMD Validator Agent

### Capabilities
- Multi-layer validation (format, includes, variables, best practices)
- Error detection with concrete fixes
- Quality assessment
- Interactive debugging

### Validation Layers
1. **File Format**: YAML, Markdown, Jinja2 syntax
2. **Include Chain**: Resolution, circular dependencies, depth
3. **Variables**: Documentation, naming, usage
4. **Best Practices**: Naming, organization, structure
5. **Composition Quality**: Patterns, reusability, complexity

### Validation Modes
- **Quick**: Syntax and basic checks
- **Standard**: + Circular dependencies, variables
- **Deep**: + Quality analysis, detailed suggestions

### Common Validations

**Critical Errors** ❌:
- PMD with `meta:` section
- Flat metadata in YMD (not under `meta:`)
- Circular dependencies
- Invalid syntax
- Broken include paths

**Warnings** ⚠️:
- Undefined variables
- Deep nesting (>5 levels)
- Poor naming
- Large inline content

**Suggestions** 💡:
- Extract reusable content
- Optimize organization
- Improve naming
- Add documentation

---

## Common Agent Interaction Patterns

### Example Interactions

**ymd-author**:
```
User: I want to create a code review prompt
Agent: Let's create it together. For code review, we typically need:
       1. Reviewer persona
       2. Review criteria
       3. Output format
       Does that cover what you need?
```

**composition-expert**:
```
User: Can you review my composition structure?
Agent: Let me analyze... [reviews]
       Findings:
       1. Composition depth: 6 levels (recommend ≤5)
       2. Duplicate content in 3 PMDs
       3. Opportunity to create shared/common.pmd
       [Provides detailed plan]
```

**ymd-validator**:
```
User: Validate my code_review.ymd file
Agent: Running comprehensive validation...
       ✅ Layer 1: File Format - PASS
       ⚠️ Layer 3: Variables - 2 warnings
       [Shows findings with fixes]
```

---

## Agent Communication Styles

### ymd-author
- Conversational and friendly
- Educational (explains "why")
- Practical (working results)
- Iterative (refines through discussion)

### composition-expert
- Analytical and systematic
- Clear trade-off explanations
- Visual structure representations
- Pragmatic focus

### ymd-validator
- Thorough and systematic
- Clear issue prioritization
- Concrete fix guidance
- Quality-focused

---

## Choosing the Right Agent

**Use ymd-author** for:
- Creating new files (YMD/PMD)
- Interactive guidance
- Learning and decision support
- Iterative refinement

**Use composition-expert** for:
- Reviewing existing compositions
- Optimizing structure
- Refactoring complex designs
- Pattern selection

**Use ymd-validator** for:
- Validating correctness
- Pre-deployment checks
- Debugging errors
- Quality assurance
