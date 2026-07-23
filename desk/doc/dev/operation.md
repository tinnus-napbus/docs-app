Docs uses Eyre's response cache as its web-serving layer. The agent builds
static application pages eagerly and document pages lazily.

# URL layout

Built-in routes are kept separate from desk names:

- `/docs` chooses the public or private index for the visitor.
- `/docs/private` serves the authenticated index.
- `/docs/public` serves the optional public index.
- `/docs/settings` serves authenticated settings.
- `/docs/d/<desk>/<path>` serves an indexed document.
- `/docs/assets/...` serves stylesheets, fonts, and navigation code.

The `/d/` namespace prevents a desk called `settings`, `public`, or a similar
reserved name from colliding with an application route.

# Lazy rendering

Indexes, settings, fonts, scripts, and stylesheets are placed in Eyre's cache
when Docs initializes or upgrades. A document is converted, validated, syntax
highlighted, and cached on its first request. Later requests are served directly
from Eyre's native cache without running the agent again.

The first request for a document with several highlighted code blocks can take
longer because Syntect runs through UrWasm. All blocks on a page are sent through
the highlighter as one batch, and the finished HTML is then cached.

# Invalidation

Docs subscribes to Tire for live-desk changes, to Docket for charge changes, and
to the relevant Clay paths for indexed documentation. It uses those updates to:

- Rebuild library indexes when a desk appears, disappears, or changes identity.
- Invalidate an individual page when only that indexed file changes.
- Invalidate one desk when its index, liveness, or documentation layout changes.
- Refresh all built-in responses and document entries after a Docs app upgrade.

Pages remain lazy after invalidation and are regenerated on their next request.
Publication changes reuse existing document payloads where possible while
changing their authentication policy.

# Cleaning the cache

Run the following generator from the Dojo:

```hoon
:docs|clean
```

It reads Eyre's complete response cache and removes every response under
`/docs` that is not a built-in page or asset. It also removes corresponding
entries from the agent's tracked cache state. Document pages are rebuilt lazily
when next requested.

The clean poke is restricted to the local ship and is intended for recovery or
development rather than routine content publishing.
