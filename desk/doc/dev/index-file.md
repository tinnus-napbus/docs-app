Each desk may include a `doc.toc` file at its root to define document titles,
ordering, and hierarchy.

# Format

Each non-empty line contains a path and a title separated by at least one space:

```text
/overview/md          Overview
/guides               Guides
  /getting-started/md Getting Started
  /configuration/md   Configuration
/reference            Reference
  /api/md              API Reference
```

A path with one element is a directory entry. A path with two elements is a
file entry whose second element is its mark. For example,
`/getting-started/md` beneath `/guides` refers to
`/doc/guides/getting-started.md`.

The `/doc` root is implicit and must not appear in the index.

# Hierarchy and ordering

Indentation determines nesting. Each level is exactly two spaces. Directory
entries establish the path inherited by the file and directory entries below
them.

Entries are displayed in index order. The same flattened file order controls
the previous and next buttons on document pages. Titles appear on cards, in the
desk menu, in page headers, and in previous and next links.

Malformed indentation is normalized where possible, but using consistent
two-space levels makes the intended hierarchy unambiguous.

# Automatic indexes

When a desk has no `doc.toc` or legacy `doc.clue`, Docs inspects `/doc` and
constructs an index from its files and directories. It applies these rules:

- Every discovered file is included.
- Entries are ordered alphabetically, with `overview` first.
- Hyphens in filenames become spaces.
- Generated titles use title case; `usr` and `dev` become **User** and
  **Developer**.

Automatic indexing is convenient for simple desks. Use `doc.toc` to omit files,
choose human-written titles, or control ordering.

# Legacy indexes

Existing `doc.clue` indexes remain supported and are converted to the current
table-of-contents representation. New desks should use `doc.toc`.
