/-  *docs, *gemtext, docket
/+  *docs, *toc, styles=base16-styles, default-agent, dbug, agentio
/%  toc-mark-core  %toc
/%  clue-mark-core  %clue
/%  css-mark-core  %css
/$  gmi-docu   %gmi   %docu
/$  udon-docu  %udon  %docu
/$  txt-docu   %txt   %docu
/$  html-docu  %html  %docu
::
|%
+$  versioned-state
  $%  state-0
  ==
+$  state-0  [%0 dark=_|]
+$  card  card:agent:gall
--
::
=|  state-0
=*  state  -
::
=<
%-  agent:dbug
^-  agent:gall
|_  =bowl:gall
+*  this  .
    def   ~(. (default-agent this %.n) bowl)
    hc    ~(. +> bowl)
    io    ~(. agentio bowl)
::
++  on-init
  ^-  (quip card _this)
  :_  this
  [%pass /bind %arvo %e %connect `/'docs' %docs]~
::
++  on-load
  |=  old-vase=vase
  ^-  (quip card _this)
  =/  old  !<  ?(~ versioned-state)  old-vase
  ?~  old
    :_  this
    [%pass /bind %arvo %e %connect `/'docs' %docs]~
  [~ this(state old)]
::
++  on-save
  ^-  vase
  !>(state)
::
++  on-poke
  |=  [=mark =vase]
  |^  ^-  (quip card _this)
  ?>  (team:title our.bowl src.bowl)
  ?.  ?=(%handle-http-request mark)
    (on-poke:def [mark vase])
  =/  req  !<  (pair @ta inbound-request:eyre)  vase
  ?.  authenticated.q.req
    :_  this
    (give-response p.req [307 ['Location' '/~/login?redirect='] ~] ~)
  ?+    method.request.q.req
    :_  this
    %^    give-response
        p.req
      :-  405
      :~  ['Content-Type' 'text/html']
          ['Content-Length' '31']
          ['Allow' 'GET, POST']
      ==
    (some (as-octs:mimes:html '<h1>405 Method Not Allowed</h1>'))
  ::
      %'GET'
    =/  =path
      %+  skip
        =+  (rush url.request.q.req aurf:de-purl:html)
        ?~  -
          ^-  (list @t)
          %-  tail
          %+  rash  url.request.q.req
          ;~  sfix
            apat:de-purl:html
            yquy:de-purl:html
          ==
        q.q.p.u.-
      (cury test '')
    ?.  ?=([%docs *] path)  (on-poke:def [mark vase])
    :_  this
    ?~  t.path
      (go-to-index p.req)
    (go-to-page p.req i.t.path t.t.path)
  ::
      %'POST'
    ?~  body.request.q.req  [(go-to-index p.req) this]
    =/  query=(unit (list [k=@t v=@t]))
      (rush q.u.body.request.q.req yquy:de-purl:html)
    ?~  query  [(go-to-index p.req) this]
    ?~  u.query  [(go-to-index p.req) this]
    ?^  t.u.query  [(go-to-index p.req) this]
    ?.  ?=(%mode k.i.u.query)  [(go-to-index p.req) this]
    ?+    v.i.u.query  [(go-to-index p.req) this]
        %dark
      ?:  dark
        [(go-to-index p.req) this]
      :_  this(dark %.y)
      ~[(~(poke-self pass:io /self) [mark vase])]
    ::
        %light
      ?.  dark
        [(go-to-index p.req) this]
      :_  this(dark %.n)
      ~[(~(poke-self pass:io /self) [mark vase])]
    ==
  ==
  ::
  ++  go-to-index
    |=  id=@ta
    ^-  (list card)
    %+  make-200-response  id
    (as-octs:mimes:html (crip (en-xml:html index:hc)))
  ::
  ++  go-to-page
    |=  [id=@ta dsk=desk pa=path]
    ^-  (list card)
    %+  make-200-response  id
    (as-octs:mimes:html (crip (en-xml:html (make-doc:hc dsk pa))))
  ::
  ++  make-200-response
    |=  [id=@ta dat=octs]
    ^-  (list card)
    %^    give-response
        id
      :-  200
      :~  ['Content-Type' 'text/html']
          ['Content-Length' (crip ((d-co:co 1) p.dat))]
      ==
    [~ dat]
  ::
  ++  give-response
    |=  [id=@ta hed=response-header:http dat=(unit octs)]
    ^-  (list card)
    :~  [%give %fact ~[/http-response/[id]] %http-response-header !>(hed)]
        [%give %fact ~[/http-response/[id]] %http-response-data !>(dat)]
        [%give %kick ~[/http-response/[id]] ~]
    ==
  --
++  on-watch
  |=  =path
  ^-  (quip card _this)
  ?>  (team:title our.bowl src.bowl)
  ?>  ?=([%http-response *] path)
  `this
::
++  on-peek
  |=  =path
  ^-  (unit (unit cage))
  ?+    path  (on-peek:def path)
  ::
    [%x %style %var ~]    [~ ~ %css !>(?:(dark dark:css:hc light:css:hc))]
    [%x %style %index ~]  [~ ~ %css !>(index:css:hc)]
    [%x %style %page ~]   [~ ~ %css !>(page:css:hc)]
    [%x %style %err ~]    [~ ~ %css !>(err:css:hc)]
  ::
      [%x kind ~]
    :^  ~  ~  %html  !>
    ^-  @t
    %-  crip
    %-  en-xml:html
    ^-  manx
    index:hc
  ::
      [%x %dev @ @ ?(~ [@ ~])]
    :^  ~  ~  %html  !>
    ^-  @t
    %-  crip
    %-  en-xml:html
    ^-  manx
    =/  knd=kind  i.t.path
    =/  dsk=desk  i.t.t.path
    =/  agt=(unit @tas)
      ?:  ?=(~ t.t.t.t.path)
        ~
      [~ i.t.t.t.path]
    =/  fil=@ta
      ?:  ?=(~ t.t.t.t.path)
        i.t.t.t.path
      i.t.t.t.t.path
    (make-doc:hc dsk ?~(agt /[knd]/[fil] /[knd]/[u.agt]/[fil]))
  ::
      [%x %usr @ @ ~]
    :^  ~  ~  %html  !>
    ^-  @t
    %-  crip
    %-  en-xml:html
    ^-  manx
    =/  knd=kind  i.t.path
    =/  dsk=desk  i.t.t.path
    =/  fil=@ta   i.t.t.t.path
    (make-doc:hc dsk /[knd]/[fil])
  ==
::
++  on-arvo
  |=  [=wire =sign-arvo]
  ^-  (quip card _this)
  ?.  ?=([%bind ~] wire)
    (on-arvo:def [wire sign-arvo])
  ?.  ?=([%eyre %bound *] sign-arvo)
    (on-arvo:def [wire sign-arvo])
  ~?  !accepted.sign-arvo
    %eyre-rejected-docs-binding
  `this
::
++  on-agent  on-agent:def
++  on-fail   on-fail:def
++  on-leave  on-leave:def
--
::
|_  =bowl:gall
++  scrio  ~(scry agentio bowl)
::
++  css
  |%
  ++  dark   .^(@t %cx (scrio %docs /app/docs/css/dark/css))
  ++  light   .^(@t %cx (scrio %docs /app/docs/css/light/css))
  ++  index   .^(@t %cx (scrio %docs /app/docs/css/index/css))
  ++  page   .^(@t %cx (scrio %docs /app/docs/css/page/css))
  ++  err   .^(@t %cx (scrio %docs /app/docs/css/err/css))
  --
::
++  make-doc
  |=  [dsk=desk pa=path]
  ^-  manx
  =;  result=(each manx tang)
      ?-  -.result
        %.y  p.result
        %.n  (err dsk p.result)
      ==
  =/  utoc=(unit [inc=? =toc])  (read-toc dsk)
  ?~  utoc  [%.n leaf+"no docs found for {<dsk>}"]
  =+  meta=(doc-meta dsk pa toc.u.utoc)
  ?:  ?=(%.n -.meta)  meta
  =/  [fpath=path ttl-dsk=tape ttl-doc=tape ttl-bar=tape]  p.meta
  =/  scrl=(each scroll tang)  (read-doc inc.u.utoc dsk fpath)
  ?:  ?=(%.n -.scrl)  scrl
  :-  %.y
  %:  whole-doc
    ttl-bar
    (header ttl-doc (dropdown dsk ttl-dsk toc.u.utoc))
    (navbar toc.p.scrl)
    content.p.scrl
    (footer (prev-next toc.u.utoc dsk pa))
  ==
:: render whole index page
::
++  index
  ^-  manx
  ;html
    ;head
      ;title: Docs
      ;meta(charset "utf-8");
      ;link(rel "stylesheet", href "/~/scry/docs/style/var.css");
      ;link(rel "stylesheet", href "/~/scry/docs/style/index.css");
    ==
    ;body
      ;div
        ;header
          ;h1: Docs
          ;form(method "post")
            ;button
              =type   "submit"
              =name   "mode"
              =value  ?:(dark "light" "dark")
              ;+  ;/  ?:(dark "[light]" "[dark]")
            ==
          ==
        ==
        ;*  make-index
      ==
    ==
  ==
:: render doc table of contents
::
++  navbar
  |=  utoc=(unit manx)
  ^-  manx
  ?~  utoc  ;nav;
  ;nav
    ;div
      ;hr;
      ;h2: Table of Contents
      ;+  u.utoc
      ;hr;
    ==
  ==
:: render header element
::
++  header
  |=  [nam=tape menu=manx]
  ^-  manx
  ;header
    ;h1: {nam}
    ;+  menu
  ==
:: render desk ToC menu
::
++  dropdown
  |=  [dsk=desk dsk-nam=tape =toc]
  ^-  manx
  =/  menu  (ent-to-manx dsk toc)
  ;div.dropdown
    ;a/"/docs"
      ;h2: {dsk-nam}
    ==
    ;div.dropdown-content
      ;+  ?~  menu  ;/("")
          u.menu
    ==
  ==
:: render whole document page
::
++  whole-doc
  |=  [ttl=tape hed=manx toc=manx cnt=manx fot=manx]
  ^-  manx
  ;html
    ;head
      ;title: {ttl}
      ;meta(charset "utf-8");
      ;link(rel "stylesheet", href "/~/scry/docs/style/var.css");
      ;link(rel "stylesheet", href "/~/scry/docs/style/page.css");
    ==
    ;body
      ;div
        ;+  hed
        ;+  toc
        ;main
          ;+  cnt
        ==
        ;+  fot
      ==
    ==
  ==
:: render doc footer element
::
++  footer
  |=  [prv=path nxt=path]
  ^-  manx
  ;footer
    ;div
      ;+  ?~  prv  ;/("\c2\a0")
          ;a(href (spud prv)): ← Previous
    ==
    ;div
      ;+  ?~  nxt  ;/("\c2\a0")
          ;a(href (spud nxt)): Next →
    ==
  ==
:: render error page
::
++  err
  |=  [dsk=desk err=tang]
  ^-  manx
  ;html
    ;head
      ;title: Docs Error
      ;meta(charset "utf-8");
      ;link(rel "stylesheet", href "/~/scry/docs/style/var.css");
      ;link(rel "stylesheet", href "/~/scry/docs/style/err.css");
    ==
    ;body
      ;div.err
        ;p: The following error occurred:
        ;pre
          ;+  ;/
              ^-  tape
              %-  of-wall:format
              %-  flop
              ^-  wall
              %-  zing
              ^-  (list wall)
              (turn err (cury wash [0 40]))
        ==
        ;p
          ;a/"/docs#{(trip dsk)}": Return to index
        ==
      ==
    ==
  ==
:: make the list of entries for the index page
::
++  make-index
  ^-  marl
  %+  join  `manx`;hr;
  %+  turn
    %+  sort
      %+  skim
        %+  turn  ~(tap by desk-map)
        |=  [dsk=desk nam=(unit @t)]
        :+  dsk
          ?~(nam <dsk> (trip u.nam))
        (read-toc dsk)
      |=([desk tape u=(unit [? toc])] ?~(u %.n %.y))
    |=  $:  a=[dsk=desk nam=tape (unit [? toc])]
            b=[dsk=desk nam=tape (unit [? toc])]
        ==
    ?:  ?=(%base dsk.a)  %.y
    ?:  ?=(%base dsk.b)  %.n
    (aor (crip (cass nam.a)) (crip (cass nam.b)))
  |=  [dsk=desk nam=tape u=(unit [? =toc])]
  ^-  manx
  ?>  ?=(^ u)
  ;section(id (trip dsk))
    ;h2: {nam}
    ;+  =+  (ent-to-manx dsk toc.u.u)
        ?~  -  ;/("")  u.-
  ==
:: get doc metadata
::
::   file path, desk name, doc title and title bar title
::
++  doc-meta
  |=  [dsk=desk pa=path =toc]
  ^-  (each [path tape tape tape] tang)
  =/  u-dsk-nam=(unit (unit @t))  (~(get by desk-map) dsk)
  ?~  u-dsk-nam  [%.n leaf+"desk not installed" ~]
  =/  desk-name=tape
    ?~  u.u-dsk-nam  <dsk>
    (trip u.u.u-dsk-nam)
  =.  pa  (flop pa)
  =/  toc-map=(map path [mar=(unit mark) nam=@t])
    %-  ~(gas by *(map path [mar=(unit mark) nam=@t]))
    %+  turn  toc
    |=  =ent
    ?:  ?=(%dir -.ent)
      [pa.ent ~ nam.ent]
    ?>  ?=(^ pa.ent)
    [t.pa.ent `i.pa.ent nam.ent]
  ?.  (~(has by toc-map) pa)
    [%.n leaf+"doc not indexed" ~]
  =/  [mar=(unit mark) nam=@t]  (~(got by toc-map) pa)
  ?~  mar  [%.n leaf+"not a file" ~]
  =/  file-path=path  (flop [u.mar pa])
  =/  title=tape  (trip nam)
  ?~  pa  [%.n leaf+"file not specified" ~]
  =/  tpa  t.pa
  :-  %.y
  :^    file-path
      desk-name
    title
  |-
  ?~  tpa  (weld "Docs > {desk-name} > " title)
  %=  $
    tpa  t.tpa
    title  (weld "{(trip nam:(~(got by toc-map) tpa))} > " title)
  ==
:: calculate previous and next page for footer
::
++  prev-next
  |=  [t=toc dsk=desk pa=path]
  |^  ^-  [path path]
  =.  pa  (flop pa)
  =/  files=(list path)  (file-paths t)
  =/  ind=(unit @)  (find ~[pa] files)
  ?~  ind  [~ ~]
  =/  prev=path
    ?:  =(0 u.ind)  ~
    [%docs dsk (flop `path`(snag (dec u.ind) files))]
  =/  next=path
    ?:  =(u.ind (dec (lent files)))  ~
    [%docs dsk (flop `path`(snag +(u.ind) files))]
  [prev next]
  ++  file-paths
    |=  =toc
    ^-  (list path)
    %-  flop
    %+  roll  toc
    |=  [e=ent acc=(list path)]
    ?:  ?=(%dir -.e)
      acc
    ?>  ?=(^ pa.e)
    [t.pa.e acc]
  --
:: make map of installed desks to names
::
++  desk-map
  ^-  (map desk (unit @t))
  =/  meta-map=(map desk @t)
    =/  charges
      .^  charge-update:docket
          %gx
          (scrio %docket /charges/noun)
      ==
    ?>  ?=(%initial -.charges)
    %-  ~(run by initial.charges)
    |=(=charge:docket title.docket.charge)
  =/  desks=(list desk)
    %+  murn
      %~  tap  by
      .^(rock:tire:clay %cx (scrio %$ /tire))
    |=([=desk =zest:clay *] ?.(=(%live zest) ~ (some desk)))
  %-  ~(gas by *(map desk (unit @t)))
  (turn desks |=(d=desk [d (~(get by meta-map) d)]))
:: read a toc for a desk from clay
::
::   if it's a clue, convert to toc. If it's included,
::   get from %docs desk instead
::
++  read-toc
  |=  dsk=desk
  ^-  (unit [? toc])
  =/  u=(unit [inc=? toc=?])
    ?:  .^(? %cu (scrio dsk /doc/toc))                   [~ | &]
    ?:  .^(? %cu (scrio dsk /doc/clue))                  [~ | |]
    ?:  .^(? %cu (scrio %docs /doc/inc/[dsk]/doc/toc))   [~ & &]
    ?:  .^(? %cu (scrio %docs /doc/inc/[dsk]/doc/clue))  [~ & |]
    ~
  ?~  u  ~
  ?:  toc.u.u
    =/  res=(unit (list raw))
      ?.  inc.u.u
        (parse .^(@t %cx (scrio dsk /doc/toc)))
      (parse .^(@t %cx (scrio %docs /doc/inc/[dsk]/doc/toc)))
    ?~  res  ~
    [~ inc.u.u (process u.res)]
  :+  ~  inc.u.u
  %-  clue-to-toc
  !<  clue
  %+  slap  !>(~)
  %-  ream
  %-  of-wain:format
  ?.  inc.u.u
    .^(wain %cx (scrio dsk /doc/clue))
  .^(wain %cx (scrio %docs /doc/inc/[dsk]/doc/clue))
:: read a doc from clay, performing mark conversion to %docu
::
++  read-doc
  |=  [inc=? dsk=desk pa=path]
  ^-  (each scroll tang)
  =/  rt=@tas  ?:(inc %docs dsk)
  =/  pt=path  ?.(inc [%doc pa] [%doc %inc dsk pa])
  ?.  .^(? %cu (scrio rt pt))  [%.n leaf+"file not found" ~]
  =/  mar=mark  (rear pa)
  :: get tube from mark to docu
  ::
  =/  tub=(unit tube:clay)
    ?:  ?=(?(%gmi %udon %txt %html) mar)  ~
    [~ .^(tube:clay %cc (scrio rt /[mar]/docu))]
  :: read file & perform mark conversion
  ::
  =/  docu=(each manx tang)
    ?~  tub
      ?.  ?=(?(%gmi %udon %txt %html) mar)
        [%.n leaf+"could not build mark conversion tube" ~]
      %-  mule
      ?-  mar
        %udon  |.((udon-docu .^(@t %cx (scrio rt pt))))
        %html  |.((html-docu .^(@t %cx (scrio rt pt))))
        %txt   |.((txt-docu .^(wain %cx (scrio rt pt))))
        %gmi   |.((gmi-docu .^((list gmni) %cx (scrio rt pt))))
      ==
    (mule |.(!<(manx (u.tub .^(vase %cr (scrio rt pt))))))
  ?:  ?=(%.n -.docu)
    [%.n leaf+"mark conversion failure" p.docu]
  :: process and make table of contents
  ::
  =/  is-ok=(unit tang)  (check-valid p.docu)
  ?^  is-ok  [%.n u.is-ok]
  =^  l=marl  p.docu
    %-  do-headers
    %+  highlight
      (strip-attrs p.docu)
    ?:  dark
      gruvbox-dark-hard:styles
    atelier-forest-light:styles
  [%.y (make-toc l) p.docu]
--
