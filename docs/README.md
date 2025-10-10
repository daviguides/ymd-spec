# YMD-Spec Documentation Site

This directory contains the Jekyll-based documentation website for YMD/PMD format specifications.

## Structure

```
docs/
├── _config.yml          # Jekyll configuration
├── _includes/           # Reusable includes (headers, footers, etc.)
├── _layouts/            # Page layouts
├── _pages/              # Documentation pages
│   ├── quick-start.md
│   ├── specifications.md
│   ├── examples.md
│   └── ... (more pages)
├── _sass/              # Stylesheets
├── assets/             # Images, CSS, JS
├── Gemfile             # Ruby dependencies
├── index.md            # Homepage
└── README.md           # This file
```

## Development

### Prerequisites

- Ruby >= 2.7
- Bundler

### Setup

```bash
cd docs
bundle install
```

### Local Development

Run Jekyll locally:

```bash
bundle exec jekyll serve
```

Then visit: `http://localhost:4000`

### Build

Build static site:

```bash
bundle exec jekyll build
```

Output will be in `_site/` directory.

## Adding Content

### New Page

1. Create file in `_pages/`:
```markdown
---
layout: default
title: My Page
nav_order: 5
---

# My Page

Content here...
```

2. Jekyll will automatically add it to navigation.

### New Section

Create subdirectory in `_pages/`:
```
_pages/
└── advanced/
    ├── index.md
    ├── topic1.md
    └── topic2.md
```

## Customization

### Navigation Order

Set `nav_order` in frontmatter:
```yaml
---
nav_order: 3
---
```

### Layout

Default layout is `default`. Create custom layouts in `_layouts/`.

### Styling

Modify SASS files in `_sass/` or add custom CSS in `assets/css/`.

## Deployment

### GitHub Pages

1. Push to GitHub
2. Enable GitHub Pages in repository settings
3. Select `docs/` as source directory

### Manual Deploy

Build site and deploy `_site/` directory to your hosting.

## Documentation Structure

### Homepage (`index.md`)
- Overview of YMD/PMD
- Key features
- Quick example
- Links to main sections

### Quick Start (`_pages/quick-start.md`)
- Installation
- First YMD/PMD files
- Using Claude Code
- Common patterns

### Specifications (`_pages/specifications.md`)
- Complete YMD format reference
- Complete PMD format reference
- Composition rules
- Validation rules
- Naming conventions

### Examples (`_pages/examples.md`)
- Simple examples
- Real-world use cases
- Pattern demonstrations
- Variable propagation

### Best Practices
(To be added)
- Structure guidelines
- Organization patterns
- Common pitfalls
- Optimization tips

### Cheatsheet
(To be added)
- Quick reference
- Syntax lookup
- Common patterns

## Links to Update

When updating documentation, check these locations:

1. Internal page links (use Liquid tags):
```markdown
[Link Text]({% raw %}{% link _pages/page.md %}{% endraw %})
```

2. External links (GitHub, etc.)

3. Code examples (keep in sync with specs)

## Contributing

When adding or updating documentation:

1. Follow existing structure
2. Use consistent formatting
3. Test locally before committing
4. Update navigation if needed
5. Keep examples synchronized with specs

## Notes

- Uses Jekyll "Just the Docs" theme (or custom theme)
- Markdown with Liquid templating
- YAML frontmatter for page metadata
- All code examples use `{% raw %}` tags for Jinja2 syntax
