Docs settings are available to signed-in users at `/docs/settings`.

# Appearance

The appearance setting applies to Docs on the ship:

- **System** follows each browser or operating system preference and is the
  default for a new installation.
- **Light** always serves the light palette.
- **Dark** always serves the dark palette.

Fonts and stylesheets are served by Docs and cached by Eyre. Saving a new theme
updates the settings page and theme-dependent stylesheets immediately.

# Public access

Public documentation is disabled by default. To publish documentation:

1. Enable **Public documentation**.
2. Select each desk whose documentation should be public.
3. Optionally supply a title and subtitle for the public library.
4. Save the publication settings.

Leaving the fields blank uses **Documentation** as the title and **Browse the
guides, references, and manuals published on this ship.** as the subtitle. Desk
selection is all-or-nothing: publishing a desk exposes every document in that
desk's index, not individual pages.

When public access is disabled, `/docs/public` returns a not-found response.
When enabled, it lists only selected desks. Document responses for unselected
desks continue to require authentication.

# Public and private entry points

The main `/docs` page performs an authentication check and immediately sends the
visitor to the correct index:

- `/docs/private` is the complete authenticated library.
- `/docs/public` is the optional unauthenticated library.

Public document pages initially link back to the public library. A signed-in
browser may upgrade those links to the private library after a successful
authentication check. No private desk names or other private metadata are
embedded in the public page to make this work.

# Saving changes

Successful saves return to the settings page and display a confirmation.
This prevents a refresh from submitting the form again. Publication changes
reuse already rendered document bodies where possible and only change the
affected cache entries and indexes.
