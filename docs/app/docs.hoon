/-  *docs, *gemtext, docket
/+  default-agent, dbug, agentio
/$  gmi-to-docu   %gmi   %docu
/$  udon-to-docu  %udon  %docu
/$  txt-to-docu   %txt   %docu
/$  html-to-docu  %html  %docu

^-  agent:gall
%-  agent:dbug
=<
|_  =bowl:gall
+*  this  .
    def   ~(. (default-agent this %.n) bowl)
    hc    ~(. +> bowl)
++  on-peek
  |=  =path
  ^-  (unit (unit cage))
  :^  ~  ~  %html  !>
  ^-  @t
  %-  crip
  %-  en-xml:html
  ^-  manx
  ?+    path  (on-peek:def path)
  ::
      [%x kind ~]
    (make-index:hc i.t.path)
  ::
      [%x %dev @ @ ?(~ [@ ~])]
    =/  knd=kind  i.t.path
    =/  dsk=desk  i.t.t.path
    =/  agt=@tas
      ?:  ?=(~ t.t.t.t.path)
        %$
      i.t.t.t.path
    =/  fil=@ta
      ?:  ?=(~ t.t.t.t.path)
        i.t.t.t.path
      i.t.t.t.t.path
    (make-doc:hc knd dsk agt fil)
  ::
      [%x %usr @ @ ~]
    =/  knd=kind  i.t.path
    =/  dsk=desk  i.t.t.path
    =/  fil=@ta   i.t.t.t.path
    (make-doc:hc knd dsk *@tas fil)
  ==
++  on-agent  on-agent:def
++  on-arvo   on-arvo:def
++  on-fail   on-fail:def
++  on-init   on-init:def
++  on-leave  on-leave:def
++  on-load   on-load:def
++  on-poke   on-poke:def
++  on-save   on-save:def
++  on-watch  on-watch:def
--
::
|_  =bowl:gall
:: construct and render index page
::
++  scrio  ~(scry agentio bowl)
++  make-index
  |=  knd=kind
  ^-  manx
  |^
  ?-    knd
      %dev
    =/  devs=(map desk ?)  dev-desk-map
    =/  sorted=(list desk)  (sort-dev-desks ~(tap in ~(key by devs)))
    =/  clues=(list [dsk=desk tit=@t col=@ux clu=clue])
      %+  turn  sorted
      |=(=desk [desk *@t *@ux (read-clue desk (~(got by devs) desk))])
    =.  clues  (turn clues clean-clue)
    (whole clues)
  ::
      %usr
    =/  usrs=(map desk [inc=? tit=@t col=@ux])  usr-app-map
    =/  sorted=(list desk)  (sort-usr-desks ~(tap by usrs))
    =/  clues=(list [dsk=desk tit=@t col=@ux clu=clue])
      %+  turn  sorted
      |=  =desk
      =/  meta=[inc=? tit=@t col=@ux]  (~(got by usrs) desk)
      [desk tit.meta col.meta (read-clue desk inc.meta)]
    (whole clues)
  ==
  :: render whole index page
  ::
  ++  whole
    |=  dsks=(list [dsk=desk tit=@t col=@ux clu=clue])
    ^-  manx
    ;html
      ;head
        ;title
          ;+  ?:  ?=(%usr knd)
                ;/("User Docs")
              ;/("Developer Docs")
        ==
        ;meta(charset "utf-8");
        ;style: {style-index}
      ==
      ;body
        ;div
          ;+  menu
          ;*  (turn dsks entry)
        ==
      ==
    ==
  :: render index page header
  ::
  ++  menu
    ^-  manx
    ;header
      ;+  ?:  ?=(%usr knd)
            ;h1: User Docs
          ;h1: Developer Docs
      ;h3
        ;+  ?:  ?=(%usr knd)
              ;a/"/~/scry/docs/dev.html": [switch to developer docs]
            ;a/"/~/scry/docs/usr.html": [switch to user docs]
      ==
    ==
  :: render an individual desk entry
  ::
  ++  entry
    |=  [dsk=desk tit=@t col=@ux clu=clue]
    ^-  manx
    ?-    knd
        %dev
      :: separate root docs if they exist
      ::
      =^  root=(list doc)  dev.clu
        ?~  dev.clu  `dev.clu
        ?:  =(%$ agent.i.dev.clu)
          [docs.i.dev.clu t.dev.clu]
        `dev.clu
      :: render desk index
      ::
      ;section.dev
        ;h2(id (trip dsk)): {(trip dsk)}
        :: render root docs if they exist
        ::
        ;+  ?~  root  ;/("")
            ;ul
              ;*  %+  turn  root
                  |=  =doc
                  =/  url=tape
                    ;:  weld
                      "/~/scry/docs/dev/"
                      (trip dsk)            "/"
                      (trip name.file.doc)  ".html"
                    ==
                  ;li
                    ;a/"{url}": {(trip title.doc)}
                  ==
            ==
        :: render agent docs if they exist
        ::
        ;+  ?~  dev.clu  ;/("")
            (agent-list dsk clu)
      ==
    ::
        %usr
      ?~  usr.clu  ;/("")
      ;section.usr(style (bg-color col))
        ;h2(id (trip dsk)): {(trip tit)}
        ;ul
          ;*  %+  turn  usr.clu
              |=  =doc
              ;li
                ;a/"/~/scry/docs/usr/{(trip dsk)}/{(trip name.file.doc)}.html"
                  ;+  ;/  "{(trip title.doc)}"
                ==
              ==
        ==
      ==
    ==
  :: produce entry background color style
  ::
  ++  bg-color
    |=  col=@ux
    ^-  tape
    =/  [r=@ud g=@ud b=@ud]
      :+  (cut 3 [2 1] col)
        (cut 3 [1 1] col)
      (end 3 col)
    %+  weld
      "border-color:#{((x-co:co 6) col)};"
    "background-color:rgba({(a-co:co r)},{(a-co:co g)},{(a-co:co b)},0.5);"
  :: render list of documents for a specific agent
  ::
  ++  agent-list
    |=  [dsk=desk clu=clue]
    ^-  manx
    ;ul
      ;*  %+  turn  dev.clu
          |=  [agent=@tas docs=(list doc)]
          ;li
             ;h3: {(trip agent)}
             ;ul
               ;*  %+  turn  docs
                   |=  =doc
                   =/  url=tape
                     ;:  weld
                       "/~/scry/docs/dev/"
                       (trip dsk)            "/"
                       (trip agent)          "/"
                       (trip name.file.doc)  ".html"
                     ==
                   ;li
                     ;a/"{url}": {(trip title.doc)}
                   ==
             ==
          ==
    ==
  --
:: construct and render a docs page
::
++  make-doc
  |=  [knd=kind dsk=desk agt=@tas fil=@ta]
  ^-  manx
  |^
  ?-    knd
      %dev
    =/  devs=(map desk ?)  dev-desk-map
    ?.  (~(has by devs) dsk)  (err knd dsk ~[leaf+"Desk not installed"])
    =/  inc=?  (~(got by devs) dsk)
    =/  clu=clue  (read-clue dsk inc)
    =/  info=(each doc tang)  (get-info knd agt fil clu)
    ?:  ?=(%.n -.info)  (err knd dsk p.info)
    =/  docs=(list doc)  (get-agent-docs agt clu)
    =/  cont=(each scroll tang)
      (read-doc knd dsk agt fil mark.file.p.info inc)
    ?:  ?=(%.n -.cont)  (err knd dsk p.cont)
    %:  whole
      (title *@t title.p.info)
      (header *@t title.p.info)
      (toc toc.p.cont)
      (content content.p.cont)
      (footer (prev-next p.info docs))
    ==
  ::
      %usr
    =/  usrs=(map desk [inc=? tit=@t col=@ux])  usr-app-map
    ?.  (~(has by usrs) dsk)  (err knd dsk ~[leaf+"App not installed"])
    =/  inc=?  inc:(~(got by usrs) dsk)
    =/  app=@t  tit:(~(got by usrs) dsk)
    =/  clu=clue  (read-clue dsk inc)
    =/  info=(each doc tang)  (get-info knd agt fil clu)
    ?:  ?=(%.n -.info)  (err knd dsk p.info)
    =/  =doc  p.info
    =/  cont=(each scroll tang)
      (read-doc knd dsk agt fil mark.file.doc inc)
    ?:  ?=(%.n -.cont)  (err knd dsk p.cont)
    %:  whole
      (title app title.doc)
      (header app title.doc)
      (toc toc.p.cont)
      (content content.p.cont)
      (footer (prev-next doc usr.clu))
    ==
  ==
  :: render error page
  ::
  ++  err
    |=  [knd=kind dsk=desk err=tang]
    ^-  manx
    ;html
      ;head
        ;title
          ;+  ?:  ?=(%usr knd)
                ;/("User docs -> Error")
              ;/("Developer docs -> Error")
        ==
        ;meta(charset "utf-8");
        ;style: {style-err}
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
                %+  turn  err
                |=  =tank
                (wash [0 40] tank)
          ==
          ;p
            ;+  ?:  ?=(%usr knd)
                  ;a/"/~/scry/docs/usr.html#{(trip dsk)}"
                    ;+  ;/("Go back")
                  ==
                ;a/"/~/scry/docs/dev.html#{(trip dsk)}"
                  ;+  ;/("Go back")
                ==
          ==
        ==
      ==
    ==
  :: render a whole docs page
  ::
  ++  whole
    |=  [tit=manx hed=manx toc=manx cnt=manx fot=manx]
    ^-  manx
    ;html
      ;head
        ;+  tit
        ;meta(charset "utf-8");
        ;style: {style-doc}
      ==
      ;body
        ;div
          ;+  hed
          ;+  toc
          ;+  cnt
          ;+  fot
        ==
      ==
    ==
  :: render title element
  ::
  ++  title
    |=  [app=@t tit=@t]
    ^-  manx
    ;title
      ;+  ?:  ?=(%usr knd)
            ;/("User docs > {(trip app)} > {(trip tit)}")
          ;/  %+  weld
              "Developer docs > {<dsk>} > "
              ?:  =(%$ agt)  "{(trip tit)}"
              "{<agt>} > {(trip tit)}"
    ==
  :: render header element
  ::
  ++  header
    |=  [app=@t tit=@t]
    ^-  manx
    ;header
      ;h1: {(trip tit)}
      ;ul
        ;li
          ;+  ?:  ?=(%usr knd)
                ;a/"/~/scry/docs/usr.html": User
              ;a/"/~/scry/docs/dev.html": Dev
        ==
        ;li
          ;+  ?:  ?=(%usr knd)
                ;a/"/~/scry/docs/usr.html#{(trip dsk)}": {(trip app)}
              ;a/"/~/scry/docs/dev.html#{(trip dsk)}": {(trip dsk)}
        ==
        ;+  ?:  ?=(%usr knd)  ;/("")
            ?:  =(%$ agt)  ;/("")
            ;li
              ;a/"/~/scry/docs/dev.html#{(trip dsk)}": {(trip agt)}
            ==
      ==
    ==
  :: render table of contents
  ::
  ++  toc
    |=  toc=(unit manx)
    ^-  manx
    ?~  toc  ;nav;
    ;nav
      ;div
        ;hr;
        ;h2: Table of Contents
        ;+  u.toc
        ;hr;
      ==
    ==
  :: render main content
  ::
  ++  content
    |=  cont=manx
    ^-  manx
    ;main
      ;+  cont
    ==
  :: render prev/next footer
  ::
  ++  footer
    |=  [prv=(unit @ta) nxt=(unit @ta)]
    =/  prev=manx
      ?~  prv  ;/("\c2\a0")
      ?:  ?=(%usr knd)
        ;a/"/~/scry/docs/usr/{(trip dsk)}/{(trip u.prv)}.html": ← Previous
      ;a/"/~/scry/docs/dev/{(trip dsk)}/{(trip agt)}/{(trip u.prv)}.html"
        ;+  ;/  "← Previous"
      ==
    =/  next=manx
      ?~  nxt  ;/("\c2\a0")
      ?:  ?=(%usr knd)
        ;a/"/~/scry/docs/usr/{(trip dsk)}/{(trip u.nxt)}.html": Next →
      ;a/"/~/scry/docs/dev/{(trip dsk)}/{(trip agt)}/{(trip u.nxt)}.html"
        ;+  ;/  "Next →"
      ==
    ;footer
      ;div
        ;+  prev
      ==
      ;div
        ;+  next
      ==
    ==
  --
:: get usr desks, making sure they're installed
:: %docket apps, have clues, and note whether they're
:: included with docs app
::
++  usr-app-map
  ^-  (map desk [inc=? tit=@t col=@ux])
  :: get %docket apps with title and colour
  ::
  =/  meta-map=(map desk [tit=@t col=@ux])
    =/  charges
      .^  charge-update:docket
          %gx
          (scrio %docket /charges/noun)
      ==
    ?>  ?=(%initial -.charges)
    %-  ~(run by initial.charges)
    |=(=charge:docket [title color]:docket.charge)
  :: add %base desk entry
  ::
  =.  meta-map  (~(put by meta-map) [%base 'Urbit OS' 0xb1.dff1])
  :: filter out those without clues
  ::
  =/  none=(list desk)
    %+  skip  ~(tap in ~(key by meta-map))
    |=  =desk
    ?:  .^(? %cu (scrio desk /doc/clue))
      %.y
    ?:  .^(? %cu (scrio %docs /doc/inc/[desk]/doc/clue))
      %.y
    %.n
  =.  meta-map
    |-
    ?~  none  meta-map
    $(none t.none, meta-map (~(del by meta-map) i.none))
  :: add loobean specifying whether docs are included with docs app
  ::
  %-  ~(urn by meta-map)
  |=  [k=desk v=[@t @ux]]
  ?:  .^(? %cu (scrio k /doc/clue))
    [%.n v]
  [%.y v]
:: get dev desks, making sure they're installed,
:: have clues, and note whether they're included
:: with docs app
::
++  dev-desk-map
  ^-  (map desk ?)
  :: get installed desks
  ::
  =/  desks=(list desk)
    %~  tap  in
    %~  key  by
    .^  (map desk *)
        %gx
        (scrio %hood /kiln/ark/noun)
    ==
  :: filter out those without clues
  ::
  =.  desks
    %+  skim  desks
    |=  =desk
    ?:  .^(? %cu (scrio desk /doc/clue))
      %.y
    ?:  .^(? %cu (scrio %docs /doc/inc/[desk]/doc/clue))
      %.y
    %.n
  :: create map saying whether docs are included with docs app
  ::
  %-  malt
  ^-  (list [desk ?])
  %+  turn  desks
  |=  =desk
  ?:  .^(? %cu (scrio desk /doc/clue))
    [desk %.n]
  [desk %.y]
:: read a clue for a desk from clay
::
++  read-clue
  |=  [=desk inc=?]
  ^-  clue
  !<  clue
  %+  slap  !>(~)
  %-  ream
  %-  of-wain:format
  ?:  inc
    .^(wain %cx (scrio %docs /doc/inc/[desk]/doc/clue))
  .^(wain %cx (scrio desk /doc/clue))
:: calculate previous and next page for footer
::
++  prev-next
  |=  [=doc docs=(list doc)]
  ^-  [(unit @ta) (unit @ta)]
  =/  ind=(unit @)  (find ~[doc] docs)
  ?~  ind  [~ ~]
  =/  prev=(unit @ta)
    ?:  =(0 u.ind)  ~
    `name.file:(snag (dec u.ind) docs)
  =/  next=(unit @ta)
    ?:  =(u.ind (dec (lent docs)))  ~
    `name.file:(snag +(u.ind) docs)
  [prev next]
:: read a doc from clay, performing mark conversion to %docu
::
++  read-doc
  |=  [knd=kind dsk=desk agt=@tas fil=@ta mar=mark inc=?]
  ^-  (each scroll tang)
  =/  root=@tas  ?:(inc %docs dsk)
  =/  =path
    ?:  inc
      ?:  ?=(%usr knd)  /doc/inc/[dsk]/usr/[fil]/[mar]
      ?:  =(%$ agt)  /doc/inc/[dsk]/dev/[fil]/[mar]
      /doc/inc/[dsk]/dev/[agt]/[fil]/[mar]
    ?:  ?=(%usr knd)  /doc/usr/[fil]/[mar]
    ?:  =(%$ agt)  /doc/dev/[fil]/[mar]
    /doc/dev/[agt]/[fil]/[mar]
  ?.  .^(? %cu (scrio root path))
    [%.n leaf+"file not found" ~]
  :: get tube from mark to docu
  ::
  =/  tub=(unit tube:clay)
    ?:  ?=(?(%gmi %udon %txt %html) mar)  ~
    :-  ~
    .^(tube:clay %cc (scrio root /[mar]/docu))

  :: read file, convert and ++clean
  ::
  =/  docu=(each manx tang)
    ?~  tub
      ?+    mar  [%.n leaf+"could not build mark conversion tube" ~]
          %gmi
        (clean (mule |.((gmi-to-docu .^((list gmni) %cx (scrio root path))))))
      ::
          %udon
        (clean (mule |.((udon-to-docu .^(@t %cx (scrio root path))))))
      ::
          %txt
        (clean (mule |.((txt-to-docu .^(wain %cx (scrio root path))))))
      ::
          %html
        (clean (mule |.((html-to-docu .^(@t %cx (scrio root path))))))
      ==
    (clean (mule |.(!<(manx (u.tub .^(vase %cr (scrio root path)))))))
  :: generate ToC and return
  ::
  ?:  ?=(%.n -.docu)
    [%.n leaf+"mark conversion failure" p.docu]
  (process-headers p.docu)
:: pull doc metadata out of clue
::
++  get-info
  |=  [knd=kind agt=@tas fil=@ta clu=clue]
  ^-  (each doc tang)
  ?-    knd
      %usr
    =|  out=(unit doc)
    |-
    ?~  usr.clu
      ?~  out
        [%.n leaf+"File not found in index" ~]
      [%.y u.out]
    ?~  out
      %=    $
          usr.clu  t.usr.clu
      ::
          out
        ?.  =(name.file.i.usr.clu fil)
          ~
        `i.usr.clu
      ==
    [%.y u.out]
  ::
      %dev
    =|  out=(unit doc)
    |-
    ?~  dev.clu
      ?~  out
        [%.n leaf+"File not indexed" ~]
      [%.y u.out]
    ?~  out
      %=    $
          dev.clu  t.dev.clu
      ::
          out
        ?.  =(agent.i.dev.clu agt)
          ~
        =|  res=(unit doc)
        |-
        ?~  docs.i.dev.clu
          res
        ?~  res
          %=    $
              docs.i.dev.clu  t.docs.i.dev.clu
          ::
              res
            ?.  =(name.file.i.docs.i.dev.clu fil)
              ~
            `i.docs.i.dev.clu
          ==
        res
      ==
    [%.y u.out]
  ==
:: get docs list for the given agent
::
++  get-agent-docs
  |=  [agt=@tas clu=clue]
  ^-  (list doc)
  =|  out=(list doc)
  |-
  ?~  dev.clu
    out
  ?~  out
    %=  $
      dev.clu  t.dev.clu
      out  ?.(=(agt agent.i.dev.clu) ~ docs.i.dev.clu)
    ==
  out
:: remove duplicates, non-installed agents, and sort
:: agent entries in dev.clue
::
++  clean-clue
  |=  [dsk=desk tit=@t col=@ux clu=clue]
  ^-  [desk @t @ux clue]
  ::  remove entries without matching agent in clay
  ::
  =.  dev.clu
    %+  skim  dev.clu
    |=  [agent=@tas docs=(list doc)]
    ?:  =(%$ agent)  %.y
    ?~  (get-fit:clay [our.bowl dsk da+now.bowl] %app agent)
      %.n
    %.y
  ::  remove empty entries
  ::
  =.  dev.clu
    %+  skip  dev.clu
    |=  [agent=@tas docs=(list doc)]
    ?~(docs %.y %.n)
  ::  remove duplicates
  ::
  =.  dev.clu
    =|  out=dev
    =|  have=(set @tas)
    |-
    ?~  dev.clu
      (flop out)
    %=  $
      dev.clu  t.dev.clu
      have     (~(put in have) agent.i.dev.clu)
      out   ?:  (~(has in have) agent.i.dev.clu)
              out
            [i.dev.clu out]
    ==
  ::  sort alphabetically
  ::
  =.  dev.clu
    %+  sort  dev.clu
    |=([a=[@tas *] b=[@tas *]] (aor -.a -.b))
  [dsk tit col clu]
:: sort dev desks alphabetically
::
++  sort-dev-desks
  |=  dsks=(list desk)
  ^-  (list desk)
  (sort dsks |=([a=desk b=desk] (aor a b)))
:: sort usr desks by name with %base at top
::
++  sort-usr-desks
  |=  dsks=(list [dsk=desk inc=? tit=@t col=@ux])
  ^-  (list desk)
  %+  turn
    %+  sort  dsks
    |=  $:  a=[dsk=desk inc=? tit=@t col=@ux]
            b=[dsk=desk inc=? tit=@t col=@ux]
        ==
    ?:  =(%base a)  %.y
    ?:  =(%base b)  %.n
    (aor tit.a tit.b)
  |=  [=desk *]
  desk
:: global tag whitelist
::
++  all-ok
  ^~
  %-  silt
  ^-  (list @tas)
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
    %strong
    %sub
    %sup
    %time
    %ul
    %var
  ==
:: header contents whitelist
::
++  head-ok
  ^~
  %-  silt
  ^-  (list @tas)
  :~
    %$
    %b
    %code
    %del
    %em
    %i
    %ins
    %q
    %small
    %span
    %strong
    %sub
    %sup
    %time
    %var
  ==
:: strip attributes and check tags are in whitelist
::
++  clean
  |=  x=(each manx tang)
  ^-  (each manx tang)
  |^
  ?:  ?=(%.n -.x)  x
  ?.  =(%div n.g.p.x)
    [%.n leaf+"root must be <div> tag" ~]
  (process p.x)
  ++  process
    |=  x=manx
    ^-  (each manx tang)
    :: fail on banned or namespaced tags
    ::
    ?^  n.g.x
      [%.n leaf+"<{(trip -.n.g.x)}:{(trip +.n.g.x)}> tag refused" ~]
    ?.  (~(has in all-ok) n.g.x)
      [%.n leaf+"<{(trip n.g.x)}> tag refused" ~]
    :: strip attributes except text, <a> href,
    :: <img> src & alt, or <pre> class=language-*
    ::
    =/  y=(each manx tang)
      ?:  =(%$ n.g.x)
        ?~  a.g.x  [%.n leaf+"empty tag" ~]
        ?:  =(%$ n.i.a.g.x)
          ?~  t.a.g.x  [%.y x]
          [%.n leaf+"malformed attributes" ~]
        [%.n leaf+"malformed attributes" ~]
      ?:  =(%a n.g.x)
        =+  matt=(malt a.g.x)
        ?:  (~(has by matt) %href)
          [%.y [n.g.x [%href (~(got by matt) %href)]~] c.x]
        [%.y [n.g.x ~] c.x]
      ?:  =(%img n.g.x)
        =+  matt=(malt a.g.x)
        ?:  (~(has by matt) %src)
          ?.  (~(has by matt) %alt)
            [%.y [n.g.x [%src (~(got by matt) %src)]~] c.x]
          :+  %.y
            :~  n.g.x
                [%src (~(got by matt) %src)]
                [%alt (~(got by matt) %alt)]
            ==
          c.x
        [%.n leaf+"<img> tag without src attribute" ~]
      ?:  =(%pre n.g.x)
        =+  matt=(malt a.g.x)
        ?:  (~(has by matt) %class)
          =+  %+  rust  (~(got by matt) %class)
              ;~(plug (jest 'language-') (star next))
          ?~  -
            [%.y [n.g.x ~] c.x]
          [%.y [n.g.x [%class (~(got by matt) %class)]~] c.x]
        [%.y [n.g.x ~] c.x]
      [%.y [n.g.x ~] c.x]
    ?:  ?=(%.n -.y)  y
    :: recursively iterate over contained elements
    ::
    ?~  c.p.y  y
    =/  z
      %+  reel  c.x
      |=  [x=manx acc=(each marl tang)]
      ?:  ?=(%.n -.acc)  acc
      =/  res  (process x)
      ?:  ?=(%.n -.res)  res
      [%.y p.res p.acc]
    ?:  ?=(%.n -.z)  z
    [%.y g.p.y p.z]
  --
:: after initial ++clean-ing, check top-level headers
:: (those directly inside the root div) contain legal
:: elements and also generate unique IDs. Additionally,
:: generate a Table of Contents from those headers.
::
++  process-headers
  |=  x=manx
  ^-  (each scroll tang)
  |^
  =/  res  (process c.x)
  ?:  ?=(%.n -.res)
    res
  [%.y (make-toc toc-raw.p.res) g.x c.p.res]
  :: types used internally. toc-raw is a flat
  :: intermediary version of the final nested
  :: html list ToC structure.
  ::
  +$  toc-raw  (list [=lvl x=manx])
  +$  lvl  ?(%1 %2 %3)
  :: render a raw ToC into a real html ToC
  ::
  ++  make-toc
    |=  =toc-raw
    ^-  (unit manx)
    ?~  toc-raw  ~
    :-  ~
    ;ul
       ;*  %+  reel  (move-up 2 (move-up 3 toc-raw))
           |=  [[=lvl x=manx] acc=marl]
           [x acc]
    ==
  :: move level 2 or 3 headers in toc-raw up a level
  :: by bundling together and wrapping in another
  :: html list. Used internally by make-toc
  ::
  ++  move-up
    |=  [depth=@ud =toc-raw]
    ^-  ^toc-raw
    =|  acc=marl
    =|  out=^toc-raw
    |-
    ?~  toc-raw
      ?~  acc
        out
      :_  out
      :-  `lvl`?:(=(depth 3) %2 %1)
      ^-  manx
      ;li
        ;ul
          ;*  ?:(=(depth 3) (flop acc) acc)
        ==
      ==
    %=    $
        toc-raw  t.toc-raw
    ::
        acc
      ?.  =(depth lvl.i.toc-raw)
        ~
      [x.i.toc-raw acc]
    ::
        out
      ?:  =(depth lvl.i.toc-raw)
        out
      ?~  acc
        [i.toc-raw out]
      :-  i.toc-raw
      :_  out
      :-  `lvl`?:(=(depth 3) %2 %1)
      ^-  manx
      ;li
        ;ul
          ;*  ?:(=(depth 3) (flop acc) acc)
        ==
      ==
    ==
  :: iterate over the top-level elements in the root div,
  :: validating headers, generate unique ids and a raw ToC.
  ::
  ++  process
    |=  l=marl
    ^-  (each [set=(set tape) =toc-raw c=marl] tang)
    =/  res
      %+  roll  l
      |=  $:  x=manx
              acc=(each [set=(set tape) =toc-raw c=marl] tang)
          ==
      ?:  ?=(%.n -.acc)  acc
      :: if not a header, just keep it as-is
      ::
      ?.  ?|  =(%h1 n.g.x)
              =(%h2 n.g.x)
              =(%h3 n.g.x)
              =(%h4 n.g.x)
              =(%h5 n.g.x)
              =(%h6 n.g.x)
          ==
        [%.y set.p.acc toc-raw.p.acc x c.p.acc]
      :: if header, process with ++loop then make sure id
      :: is unique by adding a number at the end until no
      :: collision
      ::
      =/  res=(each tape tang)  (loop [[%code a.g.x] c.x])
      ?:  ?=(%.n -.res)  res
      =/  id=tape  ?:(=("" p.res) "x" p.res)
      =/  count=@ud  1
      |-
      ?.  (~(has in set.p.acc) id)
        :^    %.y
            (~(put in set.p.acc) id)
          ?:  ?|  =(%h1 n.g.x)
                  =(%h2 n.g.x)
                  =(%h3 n.g.x)
              ==
            :_  toc-raw.p.acc
            :-  ?:  =(%h1 n.g.x)  %1
                ?:  =(%h2 n.g.x)  %2
                %3
            ^-  manx
            ;li
              ;a(href ['#' id])
                ;*  c.x
              ==
            ==
          toc-raw.p.acc
        [[[n.g.x [%id id]~] c.x] c.p.acc]
      $(count +(count), id "{p.res}-{(a-co:co count)}")
    ?:  ?=(%.n -.res)  res
    [%.y set.p.res (flop toc-raw.p.res) (flop c.p.res)]
  :: validate and assemble a (not yet unique) id for the header.
  :: used internally by ++process
  ::
  ++  loop
    |=  x=manx
    ^-  (each tape tang)
    ?^  n.g.x
      [%.n leaf+"<{(trip -.n.g.x)}:{(trip +.n.g.x)}> tag banned in headers" ~]
    ?.  (~(has in head-ok) n.g.x)
      [%.n leaf+"<{(trip n.g.x)}> tag banned in headers" ~]
    ?:  =(%$ n.g.x)
      ?~  a.g.x  [%.n leaf+"empty tag" ~]
      ?:  =(%$ n.i.a.g.x)
        ?~  t.a.g.x
          [%.y (scan (cass v.i.a.g.x) (star ;~(pose aln (cold '-' next))))]
        [%.n leaf+"malformed attributes" ~]
      [%.n leaf+"malformed attributes" ~]
    %+  reel  c.x
    |=  [x=manx acc=(each tape tang)]
    ?:  ?=(%.n -.acc)  acc
    =/  res  (loop x)
    ?:  ?=(%.n -.res)  res
    :-  %.y
    ?~  p.acc  p.res
    "{p.res}-{p.acc}"
  --
:: error style
::
++  style-err
  ^~
  %-  trip
  '''
  @font-face {
    font-family: "Inter";
    font-style: normal;
    font-weight: 400;
    font-display: swap;
    src: url("/apps/landscape/fonts/inter-regular.woff2") format("woff2");
  }
  @font-face {
    font-family: "Source Code Pro";
    src: url("/apps/landscape/fonts/sourcecodepro-regular.woff2") format("woff2");
    font-weight: 400;
    font-display: swap;
  }
  :root {
    --plain-text-color: black;
    --link-text-color: #cd0000;
    --link-text-hover-color: #ff7700;
    --mono-font: "Source Code Pro", monospace;
    --normal-font: Inter, sans;
    --code-bg: rgba(205,205,205,0.5);
  }
  body {
    font-family: var(--normal-font);
    font-size: 1.2em;
    margin: 0;
    padding: 2em;
    box-sizing: border-box;
    width: 100vw;
    height: 100vh;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
  }
  div {
    max-height: 100%;
    width: 100%;
    max-width: 40rem;
    box-sizing: border-box;
    margin: 0;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
  }
  div > p {
    margin: 0.5rem 0;
    font-size: 2em;
    text-align: center;
    flex: 0 0 auto;
  }
  a {
    text-decoration: none;
    color: var(--link-text-color);
  }
  a:hover {color: var(--link-text-hover-color)}
  pre {
    background-color: var(--code-bg);
    font-family: var(--mono-font);
    border-radius: 0.3em;
    padding: 1em;
    overflow-x: auto;
    overflow-y: auto;
    flex: 1 1 auto;
    max-width: 100%;
  }
  '''
:: index page css
::
++  style-index
  ^~
  %-  trip
  '''
  @font-face {
    font-family: "Inter";
    font-style: normal;
    font-weight: 400;
    font-display: swap;
    src: url("/apps/landscape/fonts/inter-regular.woff2") format("woff2");
  }
  @font-face {
    font-family: "Source Code Pro";
    src: url("/apps/landscape/fonts/sourcecodepro-regular.woff2") format("woff2");
    font-weight: 400;
    font-display: swap;
  }
  :root {
    --mono-font: "Source Code Pro", monospace;
    --normal-font: Inter, sans;
    --plain-text-color: black;
    --header-link-color: #5a5a5a;
    --link-color-hover: #cd0000;
    --code-bg: rgba(205,205,205,0.5);
  }
  body {
    font-family: var(--normal-font);
    font-size: 1.4em;
    width: 100%;
    margin: 0;
    padding: 1em;
    box-sizing: border-box;
  }
  div {
     max-width: 40rem;
     width: 100%;
     margin-left: auto;
     margin-right: auto;
  }
  header {
    width: 100%;
    display: flex;
    flex-direction: row;
    flex-wrap: wrap;
    align-items: center;
    justify-content: space-between;
    overflow: hidden;
    box-sizing: border-box;
    margin-bottom: 1em;
  }
  h1 {margin: 0.2em 0}
  header a {color: var(--header-link-color)}
  a {
    text-decoration: none;
    color: var(--plain-text-color);
  }
  a:hover {color: var(--link-color-hover)}
  section {
    overflow: hidden;
    margin: 1em 0;
    padding: 1em 1em 1.4em 1em;
    border-radius: 0.4rem;
    border-width: 3px;
    border-style: solid;
    box-sizing: border-box;
    border-color: var(--header-link-color);
  }
  .dev h2, .dev h3 {text-transform: capitalize}
  .usr {
    transition: background-color 0.3s;
    transition: border-color 0.3s;
  }
  .usr:hover {
    background-color: transparent !important;
    border-color: var(--header-link-color) !important;
  }
  section > :first-child {margin-top: 0}
  section > :last-child {margin-bottom: 0}
  section li {line-height: 1.5;}
  section h3 {margin: 0.6em 0}
  ul {list-style-type: none}
  '''
:: doc page css
::
++  style-doc
  ^~
  %-  trip
  '''
  @font-face {
    font-family: "Inter";
    font-style: normal;
    font-weight: 400;
    font-display: swap;
    src: url("/apps/landscape/fonts/inter-regular.woff2") format("woff2");
  }
  @font-face {
    font-family: "Source Code Pro";
    src: url("/apps/landscape/fonts/sourcecodepro-regular.woff2") format("woff2");
    font-weight: 400;
    font-display: swap;
  }
  @media only screen and (min-width: 92rem) {
    nav > div {margin: auto 0}
    nav {
      max-height: 100vh;
      height: 100vh;
      position: fixed;
      top: 0;
      left: 0;
      display: flex;
      flex-direction: column;
      max-width: 16rem;
      padding: 0 1em;
      overflow-x: hidden;
      overflow-y: auto;
      box-sizing: border-box;
    }
    nav hr {display: none}
  }

  :root {
    --plain-text-color: black;
    --toc-link-text-hover-color: #cd0000;
    --link-text-color: #cd0000;
    --link-text-hover-color: #ff7700;
    --mono-font: "Source Code Pro", monospace;
    --normal-font: Inter, sans;
    --code-bg: rgba(205,205,205,0.5);
    --code-link-bg: rgba(205,0,0,0.1);
    --code-link-border: rgba(205,0,0,0.3);
    --code-link-border-hover: rgba(255,119,0,0.5);
    --code-link-bg-hover: rgba(255,119,0,0.15);
    --code-link-text-hover: rgb(224,105,0);
    --path-separators: rgb(108,108,108);
    --quote-bg: #ffe8c7;
    --quote-left-border-bg: #ffce8a;
  }

  body {
    font-family: var(--normal-font);
    font-size: 1.2em;
    width: 100%;
    margin: 0;
    margin-bottom: 50vh;
  }
  header {margin: 1em 0 2em 0;}
  header > h1 {font-size: 2.4em; margin: 0}
  header ul {
    margin: 0.3em 0;
    padding: 0;
    font-weight: bold;
    font-size: 1.4em;
    display: flex;
    list-style-type: none;
    flex-wrap: wrap;
    text-transform: capitalize;
  }
  header li:not(:first-child)::before {
    content: ">";
    padding: 0 0.2em;
    color: var(--path-separators);
    font-size: 0.8em;
  }
  header a {padding: 0 0.2rem}
  nav ul {
    list-style-type: none;
    padding-left: 0.6em;
  }
  nav > div {padding: 1em 0}
  nav h2 {margin: 1em 0}
  nav ul {font-weight: bold}
  nav ul ul {font-weight: normal}
  nav ul ul ul {font-style: italic}
  nav li {margin-top: 0.5em}
  nav li li {margin-top: 0.3em}
  nav li li li {margin-top: 0.2em}
  nav a {color: var(--plain-text-color)}
  nav a:hover {color: var(--toc-link-text-hover-color)}
  nav a:hover code {background-color: var(--code-link-bg)}
  nav hr {margin: 2em 0}
  nav > div > :first-child {margin-top: 0}
  nav > div > :last-child {margin-bottom: 0}


  body > div {
    max-width: 60rem;
    width: calc(100% - 2rem);
    margin-left: auto;
    margin-right: auto;
    overflow-x: hidden;
  }

  a {
    text-decoration: none;
    color: var(--link-text-color);
  }
  a:hover {color: var(--link-text-hover-color)}
  main a pre, main a code {
    background-color: var(--code-link-bg);
    border: 1px solid var(--code-link-border);
  }
  main a:hover pre, main a:hover code {
    background-color: var(--code-link-bg-hover);
    border: 1px solid var(--code-link-border-hover);
    color: var(--code-link-text-hover);
  }
  p {
    line-height: 1.5;
  }
  pre {
    background-color: var(--code-bg);
    font-family: var(--mono-font);
    border-radius: 0.3em;
    padding: 1rem;
    overflow: auto;
    margin: 2em 0;
    width: fit-content;
    overflow: auto;
    max-width: 100%;
    box-sizing: border-box;
  }
  code {
    background-color: var(--code-bg);
    font-family: var(--mono-font);
    font-size: 0.9em;
    border-radius: 0.3em;
    padding: 0 0.4em;
    display: inline-block;
  }
  blockquote {
    background-color: var(--quote-bg);
    font-style: italic;
    border-radius: 0.3em;
    border: 1px solid var(--quote-left-border-bg);
    border-left: 1.2em solid var(--quote-left-border-bg);
    padding: 1em;
    margin: 2em 0;
    width: fit-content;
    overflow: auto;
    max-width: 100%;
    box-sizing: border-box;
  }
  main {margin-top: 3em;}
  main ul {list-style-type: disc}
  main li {margin: 0.8em 0}
  main li :first-child {margin-top: 0}
  main li :last-child {margin-bottom: 0}
  main > div > ul {margin: 2em 0}
  main > div > ol {margin: 2em 0}
  blockquote > ul {margin: 2em 0}
  blockquote > ol {margin: 2em 0}
  blockquote > :first-child {margin-top: 0}
  blockquote > :last-child {margin-bottom: 0}
  main > div > :first-child {margin-top: 1em}
  main > div div {margin: 1em 0}
  main > div div > :first-child {margin-top: 0}
  main > div div > :last-child {margin-bottom: 0}
  h1 {margin: 3em 0 1.4em 0}
  h2 {margin: 2.2em 0 1.3em 0}
  h3 {margin: 2.2em 0 1.2em 0}
  h4 {margin: 1.8em 0 1em 0}
  h5 {margin: 1.6em 0 1em 0}
  h6 {margin: 1.3em 0 1em 0}
  img {max-width: 100%}
  p > img:only-child {
    display: block;
    margin: 0 auto;
  }
  main hr {font-size: 2em; margin: 3em 0}
  footer {
    margin: 4em 0 0 0;
    display: flex;
    flex-wrap:wrap;
    justify-content: space-between;
    font-size: 2em;
    font-weight: bold;
  }
  '''
--
