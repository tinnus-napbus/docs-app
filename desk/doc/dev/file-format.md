Docs converts each source file to a `%docu` `+$manx`, validates and normalizes
the node tree, generates heading fragments and an on-page table of contents,
and applies syntax highlighting before producing HTML.

# Built-in marks

## `%md`

Markdown files use the `.md` extension. The parser supports ordinary Markdown
plus common GitHub-flavored features, including:

- Tables and column alignment.
- Task lists with checked and unchecked boxes.
- Strikethrough.
- Autolinked URIs and email addresses.
- Fenced code blocks with language identifiers.
- Raw HTML that satisfies the `%docu` restrictions below.

Use the language name after an opening fence to request syntax highlighting:

````markdown
```hoon
++  add
  |=  [a=@ b=@]
  (add a b)
```
````

Unknown languages fall back to an unhighlighted preformatted block.

## `%udon`

Udon files use `.udon` and begin with `;>`. Udon supports Markdown-like
paragraphs, headings, emphasis, lists, links, images, quotes, code, horizontal
rules, hard breaks, Hoon constants, and embedded Sail. Udon does not attach a
language identifier to fenced code blocks, so they use plain highlighting.

## `%gmi`

Gemtext files use `.gmi`. Gemtext is line-oriented and supports paragraphs,
links, headings up to level three, lists, quotes, and fenced preformatted
blocks. Text following an opening fence is used as its language identifier.

## `%html`

HTML files use `.html`. The parser accepts a practical, well-formed subset of
HTML nodes. Content that cannot be parsed into a valid `%docu` tree is rejected;
Docs does not attempt browser-level error recovery.

## `%txt`

Plain `.txt` files are rendered as a wrapping preformatted block.

# `%docu` validation

Custom mark conversions and built-in parsers ultimately produce the same
`%docu` representation. Its root must be a `<div>`, and only these nodes are
accepted:

`<a>`, `<address>`, `<b>`, `<br>`, `<blockquote>`, `<code>`, `<del>`,
`<div>`, `<em>`, `<h1>` through `<h6>`, `<hr>`, `<i>`, `<img>`, `<input>`,
`<ins>`, `<li>`, `<ol>`, `<p>`, `<pre>`, `<q>`, `<small>`, `<span>`,
`<strike>`, `<strong>`, `<sub>`, `<sup>`, `<table>`, `<tbody>`, `<td>`,
`<th>`, `<thead>`, `<time>`, `<tr>`, `<ul>`, `<var>`, and text nodes.

Docs removes attributes except for the following validated cases:

- `href` and optional `title` on `<a>`.
- Required `src` and optional `alt` on `<img>`.
- A `language-*` class on `<pre>` or `<code>`.
- A numeric `start` on `<ol>`.
- `left`, `center`, `right`, or empty `align` on `<th>` and `<td>`.
- `class="task-list"` on `<ul>`.
- Markdown checkbox attributes on the restricted `<input>` form.

Tables must follow `table > thead|tbody > tr > th|td`. Table cells accept safe
inline content. An `<input>` is accepted only as an empty direct child of
`<li>`, with `type="checkbox"`, an optional `checked="true"`, and an optional
`disabled="disabled"`. Docs always emits accepted checkboxes as disabled.

# Headings and fragments

Direct `<h1>` through `<h6>` children of the root receive generated IDs. Levels
one through three also appear in the on-page table of contents.

IDs are derived from readable heading text by lowercasing letters, replacing
runs of punctuation with a single hyphen, and trimming edge hyphens. Repeated
IDs receive `-1`, `-2`, and so on; an empty heading becomes `section`.

Formatting and links contribute their visible text. An image contributes its
`alt` text when present. Images and markup are never copied into navigation,
which keeps fragments and table-of-contents labels safe and readable.
