# Validate YMD/PMD Composition

Validate YMD/PMD composition structure, includes, variables, and best practices.

## What This Does

This command performs comprehensive validation across 5 layers:

1. **File Format** - Correct YMD/PMD structure, syntax
2. **Include Chain** - All includes resolve, no circular dependencies
3. **Variables** - Variables defined and documented
4. **Best Practices** - Naming, organization, structure quality
5. **Composition Quality** - Depth, reusability, patterns

## When to Use

Run this command to:

- ✅ Validate a YMD file before using
- ✅ Check composition correctness
- ✅ Identify structural issues
- ✅ Get improvement suggestions
- ✅ Verify no circular dependencies
- ✅ Analyze composition depth and complexity

## What You'll Need

Provide:

- **File path**: Path to YMD or PMD file to validate
- **Validation mode** (optional):
  - `quick` - Fast syntax and format check
  - `standard` - Comprehensive validation (default)
  - `deep` - Full analysis with quality assessment

## Output

You'll receive:

- **Validation status**: ✅ Pass / ⚠️ Warnings / ❌ Errors
- **Composition tree**: Visual structure
- **Issues by priority**: Errors → Warnings → Suggestions
- **Fix guidance**: Concrete solutions for each issue
- **Metrics**: Depth, file count, circular dependencies

---

## Business Logic

@~/.claude/ymd-spec/prompts/validate-composition.md
