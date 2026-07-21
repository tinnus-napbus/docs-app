- Developer: `~tinnus-napbus`
- License: MIT
- App link: [`~pocwet/docs`](web+urbitgraph://~pocwet/docs)
- Source: [github.com/tinnus-napbus/docs-app](https://github.com/tinnus-napbus/docs-app)
- Issues: [github.com/tinnus-napbus/docs-app/issues](https://github.com/tinnus-napbus/docs-app/issues)

Docs collects documentation published by the live desks on your ship and makes
it available as a readable, navigable library. A desk appears in the library
when it contains a valid documentation index or files under `/doc` that Docs can
index automatically.

# Using the library

Open `/docs` to enter the appropriate library for your session. Signed-in users
are sent to the private library, which lists every live desk with documentation.
Other visitors are sent to the public library if its owner has enabled one.

Each desk card lists its documents. A document page also provides:

- A **Browse desk** menu for moving between files in the same desk.
- An **On this page** table of contents when the document contains headings.
  It remains visible beside the page on larger screens and is collapsed by
  default on mobile.
- Previous and next links following the desk's document order.
- Syntax highlighting for fenced code blocks whose language is recognized.

# Appearance

The Settings page offers light, dark, and system themes. System is the default
and follows the color preference reported by each browser. The typography,
spacing, tables, lists, code blocks, and navigation are designed for long-form
technical reading.

# Public documentation

The ship owner can optionally publish selected desks without requiring visitors
to sign in. Public visitors see only the selected desk names, titles, paths, and
documents; private library metadata is not included in public pages.

See [Settings and Public Access](/docs/d/docs/settings) for the available
controls and their defaults.
