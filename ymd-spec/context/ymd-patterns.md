# YMD Composition Patterns

**Purpose**: Common structural patterns for YMD orchestrator files and when to use them.

**For full examples**: See @./creation-examples.md

---

## Pattern 1: Minimal YMD (Simple Tasks)

### When to Use
- Single focused task
- No role/persona needed
- No complex structure
- Quick, simple prompts

### Structure
```yaml
meta:
  id: task_name
  kind: task
  version: 1.0.0
  title: Task Description

user: |
  {{ user_input }}
```

### Characteristics
- Only `meta` + `user` sections
- No includes
- Minimal variables
- 5-15 lines total

### Example Use Cases
- Simple calculations
- Basic Q&A
- Direct instructions
- Single-step tasks

---

## Pattern 2: Standard YMD (Most Prompts)

### When to Use
- Clear role/persona needed
- Specific instructions required
- Defined output format
- Most production prompts

### Structure
```yaml
meta: [...]

system: |
  {% include "roles/[role].pmd" %}

instructions: |
  {% include "tasks/[task].pmd" %}

expected_output: |
  {% include "formats/[format].pmd" %}

user: |
  {{ user_input }}
```

### Characteristics
- 4-6 sections
- 2-4 includes
- Clear separation of concerns
- 20-40 lines

### Example Use Cases
- Code review
- Content generation
- API design
- Documentation writing

---

## Pattern 3: Custom Sections (Domain-Specific)

### When to Use
- Standard sections don't fit well
- Domain has specific phases/aspects
- Need clarity through naming
- Complex domain logic

### Structure
```yaml
meta: [...]

system: |
  {% include "roles/domain_expert.pmd" %}

[domain_section_1]: |
  {% include "domain/aspect_1.pmd" %}

[domain_section_2]: |
  {% include "domain/aspect_2.pmd" %}

[domain_section_3]: |
  {% include "domain/aspect_3.pmd" %}

user: |
  {{ user_input }}
```

### Characteristics
- Custom section names
- Domain-specific organization
- Clear responsibility per section
- Self-documenting structure

### Example Use Cases
- API design (api_principles, security_requirements, performance_constraints)
- Testing (test_categories, coverage_rules, quality_gates)
- Review (review_focus, validation_criteria, feedback_format)

---

## Pattern 4: Composition-Heavy (Complex Workflows)

### When to Use
- Reusing many existing components
- Layered responsibilities
- Large, comprehensive prompts
- Maximum modularity needed

### Structure
```yaml
meta: [...]

system: |
  {% include "roles/primary_role.pmd" %}

[phase_1]: |
  {% include "workflow/phase_1_a.pmd" %}
  {% include "workflow/phase_1_b.pmd" %}

[phase_2]: |
  {% include "workflow/phase_2_a.pmd" %}
  {% include "workflow/phase_2_b.pmd" %}
  {% include "workflow/phase_2_c.pmd" %}

[phase_3]: |
  {% include "workflow/phase_3.pmd" %}

validation: |
  {% include "checklists/check_1.pmd" %}
  {% include "checklists/check_2.pmd" %}
  {% include "checklists/check_3.pmd" %}

expected_output: |
  {% include "formats/deliverable.pmd" %}

user: |
  {{ user_input }}
```

### Characteristics
- Many includes (6+)
- Multiple sections
- Thin orchestrator
- High reusability

### Example Use Cases
- Enterprise workflows
- Multi-stage processes
- Comprehensive reviews
- Complex generation tasks

---

## Pattern 5: Conditional (Adaptive Behavior)

### When to Use
- Behavior changes based on variables
- Different roles for different contexts
- Dynamic content selection
- User preference adaptation

### Structure
```yaml
meta: [...]

system: |
  {% if context_var == "value_1" %}
  {% include "roles/role_1.pmd" %}
  {% elif context_var == "value_2" %}
  {% include "roles/role_2.pmd" %}
  {% else %}
  {% include "roles/default_role.pmd" %}
  {% endif %}

instructions: |
  {% if mode == "mode_a" %}
  {% include "tasks/mode_a_tasks.pmd" %}
  {% else %}
  {% include "tasks/mode_b_tasks.pmd" %}
  {% endif %}

user: |
  {{ user_input }}
```

### Characteristics
- Uses `{% if %}` blocks
- Dynamic includes
- Variable-driven structure
- Flexible behavior

### Example Use Cases
- Experience-level adaptation (beginner/intermediate/expert)
- Task-type selection (learning/debugging/design)
- Language-specific content
- Context-aware prompts

---

## Pattern 6: Parameterized (Dynamic Paths)

### When to Use
- Support many variations
- Language-specific content
- Framework-specific rules
- Scalable to new cases

### Structure
```yaml
meta: [...]

system: |
  {% include "roles/expert.pmd" %}

language_specific: |
  {% include "languages/{{ language }}_guidelines.pmd" %}

framework_specific: |
  {% include "frameworks/{{ framework }}_patterns.pmd" %}

checklists: |
  {% include "checklists/universal.pmd" %}
  {% include "checklists/{{ language }}_specific.pmd" %}

user: |
  Review this {{ language }} code using {{ framework }}:
  {{ code }}
```

### Characteristics
- Variables in include paths
- Scales to new options easily
- Minimal YMD changes needed
- Add PMDs for new variations

### Example Use Cases
- Multi-language support
- Multi-framework support
- Platform-specific content
- Tool-specific guidelines

---

## Pattern 7: Hybrid (Mixed Approaches)

### When to Use
- Some sections need conditionals
- Some need parameterization
- Some are static
- Real-world complexity

### Structure
```yaml
meta: [...]

system: |
  {% if experience == "senior" %}
  {% include "roles/senior.pmd" %}
  {% else %}
  {% include "roles/junior.pmd" %}
  {% endif %}

language_guidelines: |
  {% include "languages/{{ language }}_guidelines.pmd" %}

review_focus: |
  {% include "checklists/code_quality.pmd" %}
  {% include "checklists/security.pmd" %}
  {% if review_performance %}
  {% include "checklists/performance.pmd" %}
  {% endif %}

expected_output: |
  {% include "formats/review_comment.pmd" %}

user: |
  {{ user_input }}
```

### Characteristics
- Combines multiple patterns
- Flexible where needed
- Static where appropriate
- Pragmatic approach

### Example Use Cases
- Most real-world prompts
- Complex requirements
- Multiple variability dimensions

---

## Decision Guide: Choosing a Pattern

### Start with Pattern 1 (Minimal) if:
- ✅ Task is simple and focused
- ✅ No persona/role needed
- ✅ No complex output format

### Use Pattern 2 (Standard) if:
- ✅ Clear role, instructions, output needed
- ✅ Standard sections fit naturally
- ✅ Moderate complexity

### Choose Pattern 3 (Custom Sections) if:
- ✅ Standard sections feel forced
- ✅ Domain has specific concepts
- ✅ Clarity benefits from naming

### Apply Pattern 4 (Composition-Heavy) if:
- ✅ Reusing many components
- ✅ Multi-phase workflow
- ✅ Maximum modularity wanted

### Select Pattern 5 (Conditional) if:
- ✅ Behavior varies by context
- ✅ 2-4 distinct modes
- ✅ Variables determine structure

### Implement Pattern 6 (Parameterized) if:
- ✅ Many similar variations (languages, frameworks)
- ✅ Scalability is important
- ✅ Adding new cases frequently

### Default to Pattern 7 (Hybrid) if:
- ✅ Complex real-world requirements
- ✅ Multiple variability needs
- ✅ Mix of static and dynamic

---

## Anti-Patterns to Avoid

### ❌ Anti-Pattern: Mega YMD
**Problem**: 200+ lines of inline content
**Solution**: Extract to PMD components, use includes

### ❌ Anti-Pattern: Overly Conditional
**Problem**: Every section has complex if/else logic
**Solution**: Create separate YMDs for different modes

### ❌ Anti-Pattern: No Abstraction
**Problem**: Everything inline, no PMD reuse
**Solution**: Extract common content to PMDs

### ❌ Anti-Pattern: Too Abstract
**Problem**: 10+ levels of includes, hard to follow
**Solution**: Flatten structure, reduce nesting

### ❌ Anti-Pattern: Inconsistent Patterns
**Problem**: Different patterns per section randomly
**Solution**: Choose one primary pattern, stick to it

---

## Pattern Evolution

Prompts often evolve through patterns:

1. **Start**: Pattern 1 (Minimal) - Prototype
2. **Grow**: Pattern 2 (Standard) - Add structure
3. **Specialize**: Pattern 3 (Custom) - Domain fit
4. **Scale**: Pattern 6 (Parameterized) - Variations
5. **Mature**: Pattern 7 (Hybrid) - Real-world complexity

This evolution is natural and healthy.

---

## Quick Reference

| Pattern | Use Case | Sections | Includes | Complexity |
|---------|----------|----------|----------|------------|
| 1. Minimal | Simple tasks | 2 | 0 | Low |
| 2. Standard | Most prompts | 4-5 | 2-4 | Medium |
| 3. Custom | Domain-specific | 4-6 | 3-5 | Medium |
| 4. Composition | Complex workflows | 6+ | 6+ | High |
| 5. Conditional | Adaptive | 3-5 | 2-4 | Medium-High |
| 6. Parameterized | Scalable | 4-5 | 3-5 | Medium |
| 7. Hybrid | Real-world | 5-8 | 4-8 | High |
