|%
+$  gmni
  $%  [%text text=@t]
      [%link link=@t text=(unit @t)]
      [%code alt=(unit @t) text=@t]
      [%head lvl=?(%1 %2 %3) text=@t]
      [%quot text=@t]
      [%list text=@t]
  ==
++  encode
  |=  in=(list gmni)
  ^-  @t
  %+  roll  in
  |=  [=gmni out=@t]
  ?-    -.gmni
      %text  ;:((cury cat 3) out text.gmni '\0a')
      %quot  ;:((cury cat 3) out '> ' text.gmni '\0a')
      %list  ;:((cury cat 3) out '* ' text.gmni '\0a')
      %link
    ?~  text.gmni
      ;:((cury cat 3) out '=> ' link.gmni '\0a')
    ;:((cury cat 3) out '=> ' link.gmni ' ' u.text.gmni '\0a')
      %head
    ?-  lvl.gmni
      %1  ;:((cury cat 3) out '# ' text.gmni '\0a')
      %2  ;:((cury cat 3) out '## ' text.gmni '\0a')
      %3  ;:((cury cat 3) out '### ' text.gmni '\0a')
    ==
      %code
    ?~  alt.gmni
      ;:((cury cat 3) out '```\0a' text.gmni '\0a```\0a')
    ;:((cury cat 3) out '```' u.alt.gmni '\0a' text.gmni '\0a```\0a')
  ==
++  decode
  |=  in=cord
  |^  ^-  (list gmni)
  %+  rash  in
  (star ;~(pose quote bullet link codeblock header plain))
  ::
  ++  tab       (jest '\09')
  ++  crlf      (jest '\0d\0a')
  ++  lf        (jest '\0a')
  ++  white     ;~(pose ace tab)
  ++  le        ;~(pose crlf lf)
  ++  plus-line
    (plus ;~(less le-or-end next))
  ++  star-line
    (star ;~(less le-or-end next))
  ++  le-or-end
    ;~  plug
      (star white)
      ;~(pose le ;~(less next (easy ~)))
    ==
  ++  url-text
    %-  plus
    ;~  pose
      ;~(pose aln hep cab dot sig)
      (mask "/?:#%&+!$'()*,;=@[]")
    ==
  ::
  ++  plain
    ;~  less
      ;~(less next (easy ~))
      (stag %text ;~(sfix (cook crip star-line) le-or-end))
    ==
  ::
  ++  quote
    %+  stag  %quot
    %+  ifix
      [;~(plug gar (star white)) le-or-end]
    (cook crip plus-line)
  ::
  ++  bullet
    %+  stag  %list
    %+  ifix
      [;~(plug tar (plus white)) le-or-end]
    (cook crip plus-line)
  ::
  ++  header
    %+  stag  %head
    ;~  plug
      ;~  pose
        (cold %3 (jest '###'))
        (cold %2 (jest '##'))
        (cold %1 hax)
      ==
      %+  ifix
        [(star white) le-or-end]
      (cook crip (plus ;~(less le-or-end next)))
    ==
  ::
  ++  link
    %+  stag  %link
    ;~  pfix
      ;~(plug tis gar (plus white))
      ;~  plug
        (cook crip url-text)
        ;~  pose
          (cold ~ le-or-end)
          (stag ~ (ifix [(plus white) le-or-end] (cook crip plus-line)))
        ==
      ==
    ==
  ::
  ++  codeblock
    %+  stag  %code
    %+  ifix
      :-  ;~(plug (jest '```') (star white))
      ;~  pose
        ;~(plug le (jest '```') star-line le-or-end)
        ;~(less next (easy ~))
      ==
    ;~  plug
      ;~  pose
        (cold ~ le-or-end)
        (stag ~ ;~(sfix (cook crip plus-line) le-or-end))
      ==
      %+  cook  crip
      %-  star
      ;~  less
        ;~  pose
          ;~(plug le (jest '```') star-line le-or-end)
          ;~(less next (easy ~))
        ==
        ;~(pose (cold '\0a' crlf) next)
      ==
    ==
  --
++  gmi-to-manx-list
  |=  in=(list gmni)
  |^  ^-  [(list tape) (list manx)]
  =|  refs=(list tape)
  =|  out=(list manx)
  |-
  ?~  in
    [(flop refs) (flop out)]
  =+
    ?-  -.i.in
      %text  (plain in refs out)
      %head  (header in refs out)
      %list  (bullets in refs out)
      %quot  (quotes in refs out)
      %link  (link in refs out)
      %code  (codeblock in refs out)
    ==
  $(in -<, refs ->-, out ->+)
  ::
  +$  args
    $:  in=(list gmni)
        refs=(list tape)
        out=(list manx)
    ==
  ::
  ++  codeblock
    |=  args
    ^-  args
    ?~  in  !!
    ?>  ?=(%code -.i.in)
    :+  t.in
      refs
    :_  out
    ;pre
      ;code: {(trip text.i.in)}
    ==
  ::
  ++  plain
    |=  args
    ^-  args
    ?~  in  !!
    ?>  ?=(%text -.i.in)
    :+  t.in
      refs
    :_  out
    ;p: {(trip text.i.in)}
  ::
  ++  link
    |=  args
    ^-  args
    ?~  in  !!
    ?>  ?=(%link -.i.in)
    :+  t.in
      refs
    :_  out
    ;a/"{(trip link.i.in)}"
      ;+  ?~  text.i.in
            ;p: {(trip link.i.in)}
          ;p: {(trip u.text.i.in)}
    ==
  ::
  ++  quotes
    |=  args
    ^-  args
    =|  items=(list manx)
    |-
    ?~  in
      :+  in
        refs
      :_  out
      ;div.quote
        ;*  (flop items)
      ==
    ?.  ?=(%quot -.i.in)
      :+  in
        refs
      :_  out
      ;div.quote
        ;*  (flop items)
      ==
    %=    $
        in  t.in
        items
      :_  items
      ;p:  {(trip text.i.in)}
    ==
  ::
  ++  bullets
    |=  args
    ^-  args
    =|  items=(list manx)
    |-
    ?~  in
      :+  in
        refs
      :_  out
      ;ul
        ;*  (flop items)
      ==
    ?.  ?=(%list -.i.in)
      :+  in
        refs
      :_  out
      ;ul
        ;*  (flop items)
      ==
    %=    $
        in  t.in
        items
      :_  items
      ;li:  {(trip text.i.in)}
    ==
  ::
  ++  header
    |=  args
    ^-  args
    ?~  in  !!
    ?>  ?=(%head -.i.in)
    =|  n=@ud
    =|  suf=tape
    =/  ref=tape
      %+  scan
        (cass (trip text.i.in))
      (plus ;~(pose (cold '-' ;~(less aln next)) next))
    |-
    =/  ref-suf  (weld ref suf)
    ?~  (find ~[ref-suf] refs)
      :+  t.in
        [ref-suf refs]
      :_  out
      ?-  lvl.i.in
        %1  ;h1(id "{ref-suf}"): {(trip text.i.in)}
        %2  ;h2(id "{ref-suf}"): {(trip text.i.in)}
        %3  ;h3(id "{ref-suf}"): {(trip text.i.in)}
      ==
    $(n +(n), suf (weld "-" (a-co:co n)))
  --
::
++  gmi-join
  |=  [ali=(urge:clay gmni) bob=(urge:clay gmni)]
  ^-  (unit (urge:clay gmni))
  |^
  =.  ali  (clean ali)
  =.  bob  (clean bob)
  |-  ^-  (unit (urge:clay gmni))
  ?~  ali  `bob
  ?~  bob  `ali
  ?-    -.i.ali
      %&
    ?-    -.i.bob
        %&
      ?:  =(p.i.ali p.i.bob)
        %+  bind  $(ali t.ali, bob t.bob)
        |=(cud=(urge:clay gmni) [i.ali cud])
      ?:  (gth p.i.ali p.i.bob)
        %+  bind  $(p.i.ali (sub p.i.ali p.i.bob), bob t.bob)
        |=(cud=(urge:clay gmni) [i.bob cud])
      %+  bind  $(ali t.ali, p.i.bob (sub p.i.bob p.i.ali))
      |=(cud=(urge:clay gmni) [i.ali cud])
    ::
        %|
      ?:  =(p.i.ali (lent p.i.bob))
        %+  bind  $(ali t.ali, bob t.bob)
        |=(cud=(urge:clay gmni) [i.bob cud])
      ?:  (gth p.i.ali (lent p.i.bob))
        %+  bind  $(p.i.ali (sub p.i.ali (lent p.i.bob)), bob t.bob)
        |=(cud=(urge:clay gmni) [i.bob cud])
      ~
    ==
  ::
      %|
    ?-  -.i.bob
        %|
      ?.  =(i.ali i.bob)
        ~
      %+  bind  $(ali t.ali, bob t.bob)
      |=(cud=(urge:clay gmni) [i.ali cud])
    ::
        %&
      ?:  =(p.i.bob (lent p.i.ali))
        %+  bind  $(ali t.ali, bob t.bob)
        |=(cud=(urge:clay gmni) [i.ali cud])
      ?:  (gth p.i.bob (lent p.i.ali))
        %+  bind  $(ali t.ali, p.i.bob (sub p.i.bob (lent p.i.ali)))
        |=(cud=(urge:clay gmni) [i.ali cud])
      ~
    ==
  ==
  ++  clean
    |=  wig=(urge:clay gmni)
    ^-  (urge:clay gmni)
    ?~  wig  ~
    ?~  t.wig  wig
    ?:  ?=(%& -.i.wig)
      ?:  ?=(%& -.i.t.wig)
        $(wig [[%& (add p.i.wig p.i.t.wig)] t.t.wig])
      [i.wig $(wig t.wig)]
    ?:  ?=(%| -.i.t.wig)
      $(wig [[%| (welp p.i.wig p.i.t.wig) (welp q.i.wig q.i.t.wig)] t.t.wig])
    [i.wig $(wig t.wig)]
  --
--
