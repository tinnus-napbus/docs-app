/-  syntect
/+  highlighter=syntect
|%
+$  block
  $:  class=(unit tape)
      language=@t
      text=@t
  ==
::
:: highlight every structurally simple preformatted code block
::
++  highlight
  |=  page=manx
  ^-  manx
  =/  blocks=(list block)  (collect page)
  ?~  blocks  page
  =/  requests=(list [language=@t source=@t])
    (turn blocks |=(block=block [language.block text.block]))
  =/  results=(list result:syntect)
    (highlight-many:highlighter requests)
  =/  [out=manx remaining=(list result:syntect)]
    (transform page results)
  ?>  ?=(~ remaining)
  out
:: collect marked code blocks in postorder
::
++  collect
  |=  page=manx
  ^-  (list block)
  =/  blocks=(list block)
    %-  zing
    (turn c.page collect)
  =/  block=(unit block)  (extract page)
  ?~  block  blocks
  (snoc blocks u.block)
:: transform marked code blocks using postordered results
::
++  transform
  |=  [page=manx results=(list result:syntect)]
  ^-  [manx (list result:syntect)]
  =/  [kids=marl remaining=(list result:syntect)]
    (transform-children c.page results)
  =.  page  page(c kids)
  =/  block=(unit block)  (extract page)
  ?~  block  [page remaining]
  ?~  remaining  [page remaining]
  [(apply-block u.block i.remaining) t.remaining]
:: transform a list of child nodes while threading results
::
++  transform-children
  |=  [children=marl results=(list result:syntect)]
  ^-  [marl (list result:syntect)]
  ?~  children  [~ results]
  =/  [head=manx after-head=(list result:syntect)]
    (transform i.children results)
  =/  [tail=marl after-tail=(list result:syntect)]
    $(children t.children, results after-head)
  [[head tail] after-tail]
:: extract the highlighting inputs from a structurally simple code block
::
++  extract
  |=  node=manx
  ^-  (unit block)
  ?.  ?=(%pre n.g.node)  ~
  ?.  (code-block a.g.node)  ~
  ?~  c.node
    `(make-block a.g.node ~ "")
  ?:  ?=(%$ n.g.i.c.node)
    ?~  a.g.i.c.node  ~
    ?.  ?=(%$ n.i.a.g.i.c.node)  ~
    `(make-block a.g.node ~ v.i.a.g.i.c.node)
  ?.  ?=(%code n.g.i.c.node)  ~
  ?^  t.c.node  ~
  ?~  c.i.c.node
    `(make-block a.g.node `a.g.i.c.node "")
  ?^  t.c.i.c.node  ~
  ?.  ?=(%$ n.g.i.c.i.c.node)  ~
  ?~  a.g.i.c.i.c.node  ~
  ?.  ?=(%$ n.i.a.g.i.c.i.c.node)  ~
  `(make-block a.g.node `a.g.i.c.node v.i.a.g.i.c.i.c.node)
:: construct the normalized inputs for one code block
::
++  make-block
  |=  [pre-attrs=mart code-attrs=(unit mart) source=tape]
  ^-  block
  =/  class=(unit tape)
    =/  code-class=(unit tape)
      ?~  code-attrs  ~
      (language-class u.code-attrs)
    ?^  code-class  code-class
    (language-class pre-attrs)
  =/  language=@t
    ?~  class  'plaintext'
    (crip (slag 9 u.class))
  [class language (crip source)]
:: apply one precomputed result, falling back to theme-default plain code
::
++  apply-block
  |=  [block=block result=result:syntect]
  ^-  manx
  ?.  ?=(%& -.result)
    (add-language-class (plain-manx:highlighter text.block) class.block)
  =/  applied=manx-result:syntect
    (apply-manx:highlighter text.block p.result)
  ?.  ?=(%& -.applied)
    (add-language-class (plain-manx:highlighter text.block) class.block)
  (add-language-class p.applied class.block)
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
