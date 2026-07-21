Docs does not require a particular subject hierarchy. The following conventions
make a desk easier to browse and maintain.

# User documentation

An overview should explain what the app does and how to begin. Include the
metadata that is useful to readers, such as:

- Publisher, developer, and contributor identities.
- License and source repository.
- Issue tracker and support group.
- Distribution ship or app link.
- Compatibility or operational requirements.

For substantial applications, separate installation, configuration, common
tasks, troubleshooting, and conceptual explanations instead of turning the
overview into a complete manual.

## Changelog

Keep newest releases first. Record the version, release date, user-visible
changes, compatibility changes, and migrations. Link to detailed upgrade notes
when a release requires more than a short explanation.

# Developer documentation

Developer docs should make integration possible without reading the entire
source tree. Depending on the desk, useful sections include:

- Agent purpose, state, and important data types.
- Accepted pokes and their marks.
- Subscription paths, fact marks, and update types.
- Scry paths, cares, parameters, and response types.
- HTTP routes or external interfaces.
- Permission and authentication requirements.
- Worked Hoon and JSON examples.

Use fenced code blocks with a language identifier whenever one is available so
Docs can apply syntax highlighting.

## API references

Organize an API reference by resource, path, or tagged-union case. For each
operation, state its input type, output or fact type, side effects, access
restrictions, and failure conditions. Examples should be complete enough to run
and should show representative responses.

## Data types

Give each important type its own heading, include the Hoon definition, and
explain invariants that the type alone cannot express. Cross-link types from the
pokes, subscriptions, and scries that use them.

# Index design

Keep the desk's most useful overview first. Prefer a shallow hierarchy until the
number of pages genuinely requires another level. Write explicit `doc.toc`
titles when filenames do not produce clear navigation labels.
