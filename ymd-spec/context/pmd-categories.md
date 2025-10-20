# PMD Component Categories

**Purpose**: Standard categories for organizing PMD components and when to use each.

**For PMD specification**: See @../pmd_format_spec.md
**For PMD examples**: See @./pmd-examples.md

---

## Category 1: Roles (`roles/`)

### Purpose
Define personas, expertise levels, and responsibilities for the AI assistant.

### When to Use
- Need specific expertise (senior dev, architect, mentor, etc.)
- Defining AI persona/character
- Setting tone and approach
- Establishing credibility

### Common Files
- `senior_developer.pmd` - Experienced engineer persona
- `expert.pmd` - Domain expert persona
- `mentor.pmd` - Teaching/guidance persona
- `api_architect.pmd` - API design specialist
- `technical_writer.pmd` - Documentation specialist
- `security_expert.pmd` - Security-focused persona
- `devops_engineer.pmd` - DevOps specialist

### Typical Content
- Experience description
- Areas of expertise
- Approach to tasks
- Communication style
- Responsibilities

### Template Structure
```markdown
{# Role: [Name] #}

You are a **[title]** with [experience] experience in [domain].

## Your Expertise
- [Area 1]
- [Area 2]
- [Area 3]

## Your Approach
[How you work]

## Your Communication Style
[How you communicate]
```

---

## Category 2: Checklists (`checklists/`)

### Purpose
Validation criteria, review points, quality gates, and systematic checks.

### When to Use
- Need systematic validation
- Quality assurance
- Review processes
- Compliance checks
- Best practice verification

### Common Files
- `code_quality.pmd` - Code quality checklist
- `security_review.pmd` - Security validation
- `performance_review.pmd` - Performance checks
- `api_design_checklist.pmd` - API design validation
- `accessibility_checklist.pmd` - Accessibility requirements
- `test_coverage_checklist.pmd` - Testing criteria

### Typical Content
- Categorized check items
- Validation criteria
- Quality gates
- Best practices
- Compliance requirements

### Template Structure
```markdown
{# Checklist: [Name] #}

## [Category 1]
- [ ] [Check item 1]
- [ ] [Check item 2]

## [Category 2]
- [ ] [Check item 1]
- [ ] [Check item 2]
```

---

## Category 3: Formats (`formats/`)

### Purpose
Output format specifications, templates, and structure definitions.

### When to Use
- Defining expected output structure
- Consistent formatting requirements
- Template specifications
- Response format standards

### Common Files
- `review_comment.pmd` - Code review format
- `api_specification.pmd` - API spec template
- `json_response.pmd` - JSON output format
- `markdown_documentation.pmd` - Docs format
- `test_report.pmd` - Test results format
- `error_report.pmd` - Error reporting format

### Typical Content
- Section structure
- Required fields
- Format examples
- Output templates
- Formatting rules

### Template Structure
```markdown
{# Format: [Name] #}

Return your response in the following format:

## [Section 1]
[Template or description]

## [Section 2]
[Template or description]

```[language]
[Code template if applicable]
``  `
```

---

## Category 4: Shared (`shared/`)

### Purpose
Common reusable content that doesn't fit other categories or is used across multiple categories.

### When to Use
- Content used by multiple roles
- Common principles/guidelines
- Shared methodologies
- Cross-cutting concerns

### Common Files
- `principles.pmd` - Core principles
- `communication_style.pmd` - Communication guidelines
- `technical_expertise.pmd` - Tech skills description
- `best_practices.pmd` - General best practices
- `review_methodology.pmd` - Review approach
- `problem_solving_approach.pmd` - Problem-solving framework

### Typical Content
- Principles and guidelines
- Methodologies
- Common approaches
- Reusable descriptions
- Cross-role content

### Template Structure
```markdown
{# Shared: [Name] #}

## [Concept/Principle Name]

[Description and guidelines]
```

---

## Category 5: Domain-Specific (`[domain]/`)

### Purpose
Organize content by business domain, technology, or specialized area.

### When to Use
- Technology-specific content (languages, frameworks)
- Business domain logic
- Specialized knowledge areas
- Platform-specific rules

### Common Domains

#### Languages (`languages/`)
- `python_guidelines.pmd`
- `javascript_best_practices.pmd`
- `go_idioms.pmd`
- `rust_patterns.pmd`

#### Frameworks (`frameworks/`)
- `fastapi_patterns.pmd`
- `react_best_practices.pmd`
- `django_conventions.pmd`
- `nextjs_patterns.pmd`

#### Security (`security/`)
- `api_security.pmd`
- `web_security.pmd`
- `authentication_guidelines.pmd`
- `data_protection.pmd`

#### Principles (`principles/`)
- `rest_principles.pmd`
- `solid_principles.pmd`
- `clean_code_principles.pmd`
- `design_patterns.pmd`

#### Testing (`testing/`)
- `unit_test_guidelines.pmd`
- `integration_test_patterns.pmd`
- `e2e_test_practices.pmd`
- `test_philosophy.pmd`

### Typical Content
- Domain-specific rules
- Technology conventions
- Best practices
- Common patterns
- Platform guidelines

---

## Decision Guide: Choosing a Category

### Use `roles/` if:
- ✅ Defining AI persona/character
- ✅ Setting expertise level
- ✅ Establishing approach
- ✅ Creating identity

### Use `checklists/` if:
- ✅ Systematic validation needed
- ✅ Quality criteria defined
- ✅ Review process structured
- ✅ Compliance required

### Use `formats/` if:
- ✅ Output structure matters
- ✅ Template needed
- ✅ Consistent format required
- ✅ Response specification needed

### Use `shared/` if:
- ✅ Content crosses categories
- ✅ Used by multiple roles
- ✅ Common methodology
- ✅ Doesn't fit elsewhere

### Use domain folders (`languages/`, `frameworks/`, etc.) if:
- ✅ Technology-specific
- ✅ Domain-specialized
- ✅ Platform-dependent
- ✅ Clear grouping exists

---

## Organization Best Practices

### Directory Structure Example
```
components/
├── roles/
│   ├── senior_developer.pmd
│   ├── api_architect.pmd
│   └── mentor.pmd
├── checklists/
│   ├── code_quality.pmd
│   ├── security_review.pmd
│   └── performance_review.pmd
├── formats/
│   ├── review_comment.pmd
│   ├── api_specification.pmd
│   └── test_report.pmd
├── shared/
│   ├── principles.pmd
│   ├── communication_style.pmd
│   └── review_methodology.pmd
├── languages/
│   ├── python_guidelines.pmd
│   ├── javascript_patterns.pmd
│   └── go_idioms.pmd
└── security/
    ├── api_security.pmd
    └── authentication_guidelines.pmd
```

### Naming Conventions
- **Descriptive**: `senior_developer.pmd` not `dev.pmd`
- **snake_case**: `code_quality.pmd` not `CodeQuality.pmd`
- **Specific**: `python_guidelines.pmd` not `language.pmd`
- **Purpose-clear**: Name should indicate content

### When to Create New Category
- ✅ 3+ PMDs would go there
- ✅ Clear conceptual grouping
- ✅ Doesn't fit existing categories well
- ✅ Will grow over time

---

## Anti-Patterns

### ❌ Too Many Categories
**Problem**: 20+ top-level folders with 1-2 files each
**Solution**: Consolidate similar categories

### ❌ Unclear Categorization
**Problem**: Hard to decide where PMD belongs
**Solution**: Simplify to standard categories

### ❌ Deep Nesting
**Problem**: `components/roles/senior/backend/python/django/expert.pmd`
**Solution**: Flatten structure, use descriptive names

### ❌ Mixed Concerns
**Problem**: `roles_and_checklists/mixed_content.pmd`
**Solution**: Separate by category, single responsibility

---

## Category Migration

When a PMD outgrows its category:

1. **Identify**: PMD has multiple responsibilities
2. **Split**: Extract different aspects
3. **Categorize**: Each piece to appropriate category
4. **Create Composite**: If needed, aggregate with composite PMD

Example:
```
# Before
roles/comprehensive_reviewer.pmd (100 lines, mixed)

# After
roles/senior_developer.pmd (40 lines)
shared/review_methodology.pmd (30 lines)
shared/communication_style.pmd (20 lines)
roles/comprehensive_reviewer.pmd (15 lines, composite)
```

---

## Quick Reference

| Category | Purpose | Common Use | Example Files |
|----------|---------|------------|---------------|
| roles/ | Personas | Define AI identity | senior_dev.pmd |
| checklists/ | Validation | Quality checks | code_quality.pmd |
| formats/ | Templates | Output structure | review_comment.pmd |
| shared/ | Common | Cross-cutting | principles.pmd |
| languages/ | Tech-specific | Language rules | python_guidelines.pmd |
| frameworks/ | Platform | Framework patterns | fastapi_patterns.pmd |
| security/ | Protection | Security rules | api_security.pmd |
| principles/ | Guidelines | Design rules | rest_principles.pmd |
| testing/ | QA | Test practices | unit_test_guidelines.pmd |
