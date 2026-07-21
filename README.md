# Docs

`%docs` is an Urbit documentation library. It discovers documentation in live
desks, converts supported source formats to safe HTML, adds navigation and
Syntect syntax highlighting, and serves the result through Eyre's response
cache. Ship owners can keep the complete library private while publishing
selected desks through a separate public index.

Version 1.0.0 supports Markdown, Udon, Gemtext, HTML, plain text, and custom
marks that convert to `%docu`. It requires a compatible Zuse Kelvin from 408
through 410.

## Build

Install the [Mortar build tool](https://github.com/tinnus-napbus/mortar), then
build the complete desk with:

```sh
mortar build
```

The assembled desk is written to `dist`. Use `mortar build -config mortar-dev.yaml`
to assemble the reusable mark, structure, and library files in `dist-dev`.

The app's own user and developer documentation lives under `desk/doc` and is
available from the Docs library after installation.
