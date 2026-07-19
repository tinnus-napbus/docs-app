/-  m=markdown
/+  md=markdown
::
|_  doc=markdown:m
  ::
  :: Turn stuff into %md
  ++  grab
    |%
      ::
      :: Assert that it's already a markdown object
      ++  noun  markdown:m
      ::
      :: Parse it from %mime (e.g., if it's `|commit`ed from Unix)
      ++  mime
        |=  [mime-type=mite data=octs]
        ^-  markdown:m
        (rash q.data markdown:de:md)
    --
  ::
  :: Turn %md into other stuff
  ++  grow
    |%
      :: It is already a noun
      ++  noun  doc
      ::
      :: Convert it to %mime so the desk can be mounted
      ++  mime
        [/text/plain (as-octs:mimes:html (crip (markdown:en:md doc)))]
    --
  ++  grad  %noun
--
