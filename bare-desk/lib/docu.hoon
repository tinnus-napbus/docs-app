/-  *gemtext
|%
:: mark conversion functions
::
++  to-docu
  |%
  :: convert %gmi mark to %docu mark
  ::
  ++  gmi
    |=  gem=(list gmni)
    ^-  manx
    |^
    =/  res  (reel gem process)
    ;div
      ;*  ?~  acc.res  out.res
          [(make-list acc.res) out.res]
    ==
    :: Convert each gmni type to manx
    :: and accumulate
    ::
    ++  process
      |=  [g=gmni acc=(list @t) out=marl]
      ?-    -.g
          %list  [[text.g acc] out]
      ::
          %text
        :-  ~
        ?:  =('' text.g)
          ?~(acc out [(make-list acc) out])
        :_  ?~(acc out [(make-list acc) out])
        ^-  manx
        ;p: {(trip text.g)}
      ::
          %link
        :-  ~
        :_  ?~(acc out [(make-list acc) out])
        ^-  manx
        ;p
          ;a/"{(trip link.g)}"
            ;+  ;/  ?~  text.g
                    (trip link.g)
                  (trip u.text.g)
          ==
        ==
      ::
          %code
        :-  ~
        :_  ?~(acc out [(make-list acc) out])
        ^-  manx
        ?~  alt.g
          ;pre: {(trip text.g)}
        ;pre(class (lang u.alt.g)): {(trip text.g)}
      ::
          %quot
        :-  ~
        :_  ?~(acc out [(make-list acc) out])
        ^-  manx
        ;blockquote: {(trip text.g)}
      ::
          %head
        :-  ~
        :_  ?~(acc out [(make-list acc) out])
        ^-  manx
        ?-  lvl.g
          %1  ;h1: {(trip text.g)}
          %2  ;h2: {(trip text.g)}
          %3  ;h3: {(trip text.g)}
        ==
      ==
    :: convert codeblock alt-text to
    :: language class
    ::
    ++  lang
      |=  =@t
      ^-  tape
      %+  scan  (cass (trip t))
      %+  funk  "language-"
      (star ;~(pose aln (cold '-' next)))
    :: assemble individual bullet points
    ::
    ++  make-list
      |=  items=(list @t)
      ^-  manx
      ;ul
        ;*  %+  turn  items
            |=  =@t
            ^-  manx
            ;li: {(trip t)}
      ==
    --
  ::
  :: convert a %txt mark to a %docu mark
  ::
  ++  txt
    |=  tex=wain
    ^-  manx
    ;div
      ;pre.language-plaintext
        ;+  ;/  (trip (of-wain:format tex))
      ==
    ==
  --
--
