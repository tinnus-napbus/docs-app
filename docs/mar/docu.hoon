/-  *gemtext
/+  *docs, cram
|_  dcu=(each manx tang)
++  grab
  |%
  ++  docu        dcu
  ++  htm         |=(a=manx [%.y a])
  ++  hymn        |=(a=manx [%.y a])
  ++  x-htm       |=(a=manx [%.y a])
  ++  x-htm-elem  |=(a=manx [%.y a])
::
  ++  gmi
  |=  gem=(list gmni)
  ^-  (each manx tang)
  (mule |.((gmi:to-docu gem)))
::
  ++  html
  |=  htm=@t
  ^-  (each manx tang)
  =/  res=(unit manx)  (de-xml:^html htm)
  ?~  res
    [%.n leaf+"Failed to parse HTML file" ~]
  [%.y u.res]
::
  ++  noun
    |=  non=*
    ^-  (each manx tang)
    =/  res=(unit (each manx tang))
      ((soft (each manx tang)) non)
    ?~  res
      [%.n leaf+"Failed to clam noun to docu type" ~]
    u.res
::
  ++  txt
    |=  tex=wain
    ^-  (each manx tang)
    (mule |.((txt:to-docu tex)))
::
  ++  udon
    |=  mud=@t
    ^-  (each manx tang)
    (mule |.(elm:(static:cram (ream mud))))
  --
++  grow
  |%
  ++  noun  dcu
  --
++  grad  %noun
--
