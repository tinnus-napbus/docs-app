Docs discovers documentation from every live desk on the ship. Publishers only
need to place supported files under `/doc`; no Docs-specific library or mark
files need to be copied into a desk when using a built-in format.

# Add documentation to a desk

The smallest useful layout is:

```text
doc.toc
doc/
  overview.md
```

With this index:

```text
/overview/md  Overview
```

The final path element in an index entry is the file's mark, so this entry reads
`/doc/overview.md`. Nested directory entries can organize any hierarchy you
need; `/usr` and `/dev` are conventions rather than requirements.

A `doc.toc` is optional. If it is absent and `/doc` contains files, Docs infers
an index from the directory tree. An explicit index is preferable when titles,
ordering, or a curated subset matter.

See [Index Files](/docs/d/docs/dev/index-file) for the complete format.

# Built-in formats

Docs reads these marks directly:

- `%md` for Markdown and common GitHub-flavored extensions.
- `%udon` for Hoon's Udon format.
- `%gmi` for Gemtext.
- `%html` for HTML.
- `%txt` for plain text rendered as a wrapping preformatted block.

Every result is converted to `%docu`, validated as a safe `+$manx`, normalized,
and then rendered. See [File Formats](/docs/d/docs/dev/file-format) for syntax,
validation, heading, and highlighting details.

# Custom formats

Other marks are supported when the publishing desk provides a Clay conversion
tube from that mark to `%docu`. The conversion must produce a `+$manx` accepted
by Docs' validator. A failed conversion or invalid node tree produces an error
page rather than serving unchecked HTML.

# Updates

Docs follows Clay's live-desk state and the Docket charge list. It watches each
indexed documentation input and invalidates only the affected page or desk when
possible. Newly requested pages are rebuilt from the latest source, so no manual
publish step is needed after committing documentation.

Whether a desk is available publicly is controlled by the ship owner, not by
the publishing desk. Publishers therefore should not assume that their docs
will be reachable without authentication.
