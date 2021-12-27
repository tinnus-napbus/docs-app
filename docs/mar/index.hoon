/-  docs
|_  ind=wain
++  grab
  |%
  ++  mime
    |=  [=mite len=@ud tex=@]
    ^-  wain
    =+  !<(index:docs (slap !>(~) (ream tex)))
    (to-wain:format tex)
  ++  noun
    |=  non=*
    ^-  wain
    (wain non)
  ++  txt
    |=  tex=wain
    tex
  --
++  grow
  |%
  ++  mime  [/text/x-doc-index (as-octs:mimes:html (of-wain:format ind))]
  ++  noun  ind
  ++  txt   ind
  --
++  grad  %txt
--

