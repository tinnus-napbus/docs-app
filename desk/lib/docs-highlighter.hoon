/-  syntect
/+  mu=manx-utils, highlighter=syntect
|%
:: highlight every structurally simple preformatted code block
::
++  highlight
  |=  page=manx
  ^-  manx
  (transform page)
:: transform marked code blocks with Syntect
::
++  transform
  |=  page=manx
  ^-  manx
  %-  ~(post-apply-nodes mu page)
  |=  node=manx
  ^-  manx
  ?.  ?=(%pre n.g.node)  node
  ?.  (code-block a.g.node)  node
  ?~  c.node
    (highlight-block a.g.node ~ "")
  ?:  ?=(%$ n.g.i.c.node)
    ?~  a.g.i.c.node  node
    ?.  ?=(%$ n.i.a.g.i.c.node)  node
    (highlight-block a.g.node ~ v.i.a.g.i.c.node)
  ?.  ?=(%code n.g.i.c.node)  node
  ?^  t.c.node  node
  ?~  c.i.c.node
    (highlight-block a.g.node `a.g.i.c.node "")
  ?^  t.c.i.c.node  node
  ?.  ?=(%$ n.g.i.c.i.c.node)  node
  ?~  a.g.i.c.i.c.node  node
  ?.  ?=(%$ n.i.a.g.i.c.i.c.node)  node
  (highlight-block a.g.node `a.g.i.c.node v.i.a.g.i.c.i.c.node)
:: highlight one code block, falling back to theme-default plain code
::
++  highlight-block
  |=  [pre-attrs=mart code-attrs=(unit mart) source=tape]
  ^-  manx
  =/  class=(unit tape)
    =/  code-class=(unit tape)
      ?~  code-attrs  ~
      (language-class u.code-attrs)
    ?^  code-class  code-class
    (language-class pre-attrs)
  =/  language=@t
    ?~  class  'plaintext'
    (crip (slag 9 u.class))
  =/  text=@t  (crip source)
  =/  result=result:syntect
    (highlight:highlighter language text)
  ?.  ?=(%& -.result)
    (add-language-class (plain-manx:highlighter text) class)
  =/  applied=manx-result:syntect
    (apply-manx:highlighter text p.result)
  ?.  ?=(%& -.applied)
    (add-language-class (plain-manx:highlighter text) class)
  (add-language-class p.applied class)
:: retain a validated language-* class on the generated pre element
::
++  add-language-class
  |=  [block=manx class=(unit tape)]
  ^-  manx
  ?~  class  block
  =/  attrs=(map mane tape)
    (~(gas by *(map mane tape)) a.g.block)
  =/  old=(unit tape)  (~(get by attrs) %class)
  =/  combined=tape
    ?~  old  u.class
    "{u.old} {u.class}"
  block(a.g [[%class combined] ~])
:: extract the sole validated language-* class, if present
::
++  language-class
  |=  attrs=mart
  ^-  (unit tape)
  =/  classes=(unit tape)
    (~(get by (~(gas by *(map mane tape)) attrs)) %class)
  ?~  classes  ~
  =/  direct=(unit @t)
    (rust u.classes ;~(sfix (jest 'language-') (plus next)))
  ?^  direct  `u.classes
  =/  marked=(unit @t)
    %+  rust  u.classes
    ;~(sfix (jest 'docs-code-block language-') (plus next))
  ?~  marked  ~
  `(slag 16 u.classes)
:: identify pre elements admitted and marked by the Docs validator
::
++  code-block
  |=  attrs=mart
  ^-  ?
  =/  classes=(unit tape)
    (~(get by (~(gas by *(map mane tape)) attrs)) %class)
  ?~  classes  |
  ?|  =("docs-code-block" u.classes)
      ?=(^ (rust u.classes ;~(pfix (jest 'docs-code-block ') (plus next))))
  ==
--
