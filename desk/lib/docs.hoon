/+  mu=manx-utils
|%
:: global tag whitelist
::
++  all-ok
  ^~
  %-  silt
  ^-  (list mane)
  :~
    %$
    %a
    %address
    %b
    %br
    %blockquote
    %code
    %del
    %div
    %em
    %h1
    %h2
    %h3
    %h4
    %h5
    %h6
    %hr
    %i
    %img
    %ins
    %li
    %ol
    %p
    %pre
    %q
    %small
    %span
    %strike
    %strong
    %sub
    %sup
    %table
    %tbody
    %td
    %th
    %thead
    %time
    %tr
    %ul
    %input
    %var
  ==
:: header contents whitelist
::
++  head-ok
  ^~
  %-  silt
  ^-  (list mane)
  :~
    %$
    %a
    %b
    %br
    %code
    %del
    %em
    %i
    %img
    %ins
    %q
    %small
    %span
    %strike
    %strong
    %sub
    %sup
    %time
    %var
  ==
:: check elements are in whitelist and well formed
::
++  check-valid
  |=  x=manx
  ^-  (unit tang)
  :: check root is div
  ::
  ?.  ?=(%div n.g.x)
    [~ leaf+"root must be <div>" ~]
  :: check header contents are ok
  ::
  ?.  %+  roll  c.x
      |=  [x=manx w=?]
      ?.  w  w
      ?.  ?=(?(%h1 %h2 %h3 %h4 %h5 %h6) n.g.x)  %.y
      (~(whitelisted mu x(n.g %$)) head-ok)
    [~ leaf+"disallowed tag in heading" ~]
  :: check table nesting and constrain inputs to Markdown task checkboxes
  ::
  =/  bad-structure=(unit tang)  (check-structure x ~)
  ?^  bad-structure  bad-structure
  :: check rest of contents are ok
  ::
  %-  ~(post-fold mu x)
  |=  [g=marx e=(unit tang)]
  ?^  e  e
  ?.  (~(has in all-ok) n.g)
    ?@  n.g
      [~ leaf+"<{(trip n.g)}> tag not allowed" ~]
    [~ leaf+"<{(trip -.n.g)}:{(trip +.n.g)}> tag not allowed" ~]
  ?+    n.g  ~
      %img
    |-
    ?~  a.g
      [~ leaf+"<img> tag without src attribute" ~]
    ?:  ?=(%src n.i.a.g)
      ~
    $(a.g t.a.g)
  ::
      %$
    ?.  ?|(?=(@ a.g) ?=(^ t.a.g) !=(n.i.a.g %$))
      ~
    [~ leaf+"malformed content" ~]
  ==
:: check the structure of elements with restricted content models
::
++  check-structure
  |=  [x=manx parent=(unit mane)]
  ^-  (unit tang)
  :: table elements may only occur in their expected parent
  ::
  ?.  (parent-child-ok parent n.g.x)
    [~ leaf+"element is not allowed in its table container" ~]
  :: table containers must themselves have the expected parent
  ::
  ?.  (element-parent-ok n.g.x parent)
    [~ leaf+"table element has an invalid parent" ~]
  :: table cells contain the same safe inline elements as headings
  ::
  ?.  (cell-contents-ok x)
    [~ leaf+"disallowed tag in table cell" ~]
  :: inputs are void elements with type=checkbox and optional checked/disabled
  ::
  ?.  (input-node-ok x)
    [~ leaf+"only empty Markdown checkbox inputs are allowed" ~]
  :: recurse through children
  ::
  %+  roll  c.x
  |=  [kid=manx err=(unit tang)]
  ?^  err  err
  (check-structure kid `n.g.x)
:: restrict direct children of table containers
::
++  parent-child-ok
  |=  [parent=(unit mane) child=mane]
  ^-  ?
  ?~  parent  %.y
  ?+  u.parent  %.y
    %table  ?=(?(%thead %tbody) child)
    %thead  ?=(%tr child)
    %tbody  ?=(%tr child)
    %tr     ?=(?(%th %td) child)
  ==
:: restrict table elements to the corresponding container
::
++  element-parent-ok
  |=  [child=mane parent=(unit mane)]
  ^-  ?
  ?.  ?=(?(%thead %tbody %tr %th %td %input) child)  %.y
  ?~  parent  %.n
  ?-  child
    %thead  =(%table u.parent)
    %tbody  =(%table u.parent)
    %tr     ?=(?(%thead %tbody) u.parent)
    %th     =(%tr u.parent)
    %td     =(%tr u.parent)
    %input  =(%li u.parent)
  ==
:: table cells use the safe inline-content whitelist
::
++  cell-contents-ok
  |=  x=manx
  ^-  ?
  ?.  ?=(?(%th %td) n.g.x)  %.y
  (~(whitelisted mu x(n.g %$)) head-ok)
:: validate the whole input node, including its void content model
::
++  input-node-ok
  |=  x=manx
  ^-  ?
  ?.  ?=(%input n.g.x)  %.y
  ?^  c.x  %.n
  (input-attrs-ok a.g.x)
:: validate the complete attribute set of a Markdown task checkbox
::
++  input-attrs-ok
  |=  attrs=mart
  =/  am  (~(gas by *(map mane tape)) attrs)
  :: reject duplicate attributes before checking the permitted set
  ?.  =((lent attrs) ~(wyt by am))  %.n
  ?.  (~(has by am) %type)  %.n
  ?.  =("checkbox" (~(got by am) %type))  %.n
  =/  checked=(unit tape)   (~(get by am) %checked)
  =/  disabled=(unit tape)  (~(get by am) %disabled)
  ?.  ?~(checked %.y =("true" u.checked))  %.n
  ?.  ?~(disabled %.y =("disabled" u.disabled))  %.n
  =/  expected=@  1
  =.  expected  ?~(checked expected +(expected))
  =.  expected  ?~(disabled expected +(expected))
  =(expected ~(wyt by am))
:: strip attributes except where necessary
::
++  strip-attrs
  |=  x=manx
  ^-  manx
  %-  ~(apply-elem mu x)
  |=  g=marx
  ^-  marx
  ?+    n.g  g(a ~)
      %$
    =/  am  (~(gas by *(map mane tape)) a.g)
    ?.  (~(has by am) %$)  g(a ~)
    g(a [%$ (~(got by am) %$)]~) 
      %img
    =/  am  (~(gas by *(map mane tape)) a.g)
    =|  a=mart
    =.  a  ?.  (~(has by am) %src)  a
           [[%src (~(got by am) %src)] a]
    =.  a  ?.  (~(has by am) %alt)  a
           [[%alt (~(got by am) %alt)] a]
    g(a a)
  ::
      %a
    =/  am  (~(gas by *(map mane tape)) a.g)
    ?.  (~(has by am) %href)  g(a ~)
    =/  out=mart  [[%href (~(got by am) %href)] ~]
    =.  out  ?.  (~(has by am) %title)  out
             [[%title (~(got by am) %title)] out]
    g(a out)
  ::
      %code
    =/  am  (~(gas by *(map mane tape)) a.g)
    ?.  (~(has by am) %class)
      g(a ~)
    =/  lng=(unit @t)
      %+  rust
        (~(got by am) %class)
      ;~(sfix (jest 'language-') (star next))
    ?~  lng
      g(a ~)
    g(a [%class (~(got by am) %class)]~)
  ::
      %pre
    =/  am  (~(gas by *(map mane tape)) a.g)
    ?.  (~(has by am) %class)
      g(a [%class "docs-code-block"]~)
    =/  lng=(unit @t)
      %+  rust
        (~(got by am) %class)
      ;~(sfix (jest 'language-') (star next))
    ?~  lng
      g(a [%class "docs-code-block"]~)
    g(a [%class "docs-code-block {(~(got by am) %class)}"]~)
  ::
      %ol
    =/  am  (~(gas by *(map mane tape)) a.g)
    ?.  (~(has by am) %start)  g(a ~)
    =/  num=(unit tape)  (rust (~(got by am) %start) (plus nud))
    ?~  num  g(a ~)
    g(a [%start (~(got by am) %start)]~)
  ::
      ?(%th %td)
    =/  am  (~(gas by *(map mane tape)) a.g)
    ?.  (~(has by am) %align)  g(a ~)
    =/  align=tape  (~(got by am) %align)
    ?.  ?|(=(align "") =(align "left") =(align "center") =(align "right"))
      g(a ~)
    g(a [%align align]~)
  ::
      %ul
    =/  am  (~(gas by *(map mane tape)) a.g)
    ?.  ?&((~(has by am) %class) =("task-list" (~(got by am) %class)))
      g(a ~)
    g(a [%class "task-list"]~)
  ::
      %input
    =/  am  (~(gas by *(map mane tape)) a.g)
    =|  out=mart
    =.  out  [[%type "checkbox"] out]
    =.  out  ?.  (~(has by am) %checked)  out
             [[%checked "true"] out]
    =.  out  [[%disabled "disabled"] out]
    g(a out)
  ==
:: extract readable heading text, substituting image alt text for the image
::
++  heading-text
  |=  x=manx
  ^-  tape
  ?:  =(%img n.g.x)
    =/  attrs  (~(gas by *(map mane tape)) a.g.x)
    (fall (~(get by attrs) %alt) "")
  ?:  =(%$ n.g.x)
    ?~  a.g.x  ""
    ?.  =(%$ n.i.a.g.x)  ""
    v.i.a.g.x
  %-  zing
  (turn c.x heading-text)
:: lowercase, collapse punctuation to one hyphen, and trim edge hyphens
::
++  slugify
  |=  text=tape
  ^-  tape
  %+  scan  (cass text)
  %+  ifix  [(star ;~(less aln next)) (star next)]
  %-  star
  ;~  pose
    aln
    ;~(sfix (cold '-' (plus ;~(less aln next))) ;~(simu next (easy ~)))
  ==
:: make an id for a section
::
:: apply section headers and produce marl for ToC
::
++  do-headers
  |=  x=manx
  |^  ^-  [marl manx]
  =|  c=marl
  =|  tocs=marl
  =|  ids=(set [tape @ud])
  |-
  ?~  c.x
    [(flop tocs) x(c (flop c))]
  ?.  ?=(?(%h1 %h2 %h3 %h4 %h5 %h6) n.g.i.c.x)
    $(c.x t.c.x, c [i.c.x c])
  =/  nid=[txt=tape num=@ud]
    =/  txt=tape  (make-id i.c.x)
    =/  num=@ud  0
    |-
    ?:  (~(has in ids) [txt num])
      $(num +(num))
    [txt num]
  =.  a.g.i.c.x
    :_  ~  :-  %id
    ?:  =(0 num.nid)  txt.nid
    "{txt.nid}-{(a-co:co num.nid)}"
  %=  $
    c.x   t.c.x
    c     [i.c.x c]
    ids   (~(put in ids) nid)
    tocs  ?.(?=(?(%h1 %h2 %h3) n.g.i.c.x) tocs [i.c.x tocs])
  ==
  ::
  ++  make-id
    |=  x=manx
    ^-  tape
    =/  slug=tape  (slugify (heading-text x))
    ?~  slug  "section"
    slug
  --
:: turn a list of processed h1-3 headers into a ToC
::
++  make-toc
  |=  l=marl
  ^-  (unit manx)
  |^
  =/  [h2=marl h3=marl out=marl]
    %+  roll  l
    |=  [x=manx h2=marl h3=marl out=marl]
    ?+    n.g.x  !!
        %h3
      [h2 [(to-a x) h3] out]
    ::
        %h2
      ?~  h3
        [[(to-a x) h2] ~ out]
      [[(to-a x) (lift (flop h3)) h2] ~ out]
    ::
        %h1
      ?~  h3
        ?~  h2
          ``[(to-a x) out]
        ``[(to-a x) (lift (flop h2)) out]
      ?~  h2
        ``[(to-a x) (lift ~[(lift (flop h3))]) out]
      ``[(to-a x) (lift (flop [(lift (flop h3)) h2])) out]
    ==
  ?~  h2
    ?~  h3
      (output (flop out))
    (output (flop [(lift ~[(lift (flop h3))]) out]))
  ?~  h3
    (output (flop [(lift (flop h2)) out]))
  (output (flop [(lift (flop [(lift (flop h3)) h2])) out]))
  ::
  ++  output
    |=  c=marl
    ^-  (unit manx)
    ?~  c  ~
    :-  ~
    ;ul
      ;*  c
    ==
  ::
  ++  lift
    |=  c=marl
    ^-  manx
    ;li
      ;ul
        ;*  c
      ==
    ==
  ::
  ++  to-a
    |=  x=manx
    ^-  manx
    ?>  ?=(^ a.g.x)
    ?>  ?=(%id n.i.a.g.x)
    =/  txt=tape  (heading-text x)
    ;li
      ;a(href ['#' v.i.a.g.x])
        ;+  ?:  =(txt "")
              ;span: Section
            ;span: {txt}
      ==
    ==
  --
--
