/-  *docs, *gemtext, docket
/+  default-agent, dbug, agentio
|%
+$  card  card:agent:gall
--
%-  agent:dbug
^-  agent:gall
|_  =bowl:gall
+*  this  .
    def   ~(. (default-agent this %.n) bowl)
    io    ~(. agentio bowl)
++  on-peek
  |=  =path
  |^  ^-  (unit (unit cage))
  :^  ~  ~  %html  !>
  ^-  @t
  %-  crip
  %-  en-xml:html
  ^-  manx
  ?+    path  (on-peek:def path)
      [%x ?(%usr %dev) ~]
    =/  kind  i.t.path
    =/  manxes=(list manx)
      ?:  ?=(%usr kind)
        usr-index
      dev-index
    ;html
      ;head
        ;title
          ;+  ?:  ?=(%usr kind)
                ;/("User Docs")
              ;/("Developer Docs")
        ==
        ;meta(charset "utf-8");
        ;style:"{(trip style-index)}"
      ==
      ;body
        ;nav
          ;+  (menu kind)
          ;*  ?~  manxes
                :~
                  ;p.err
                    ;+  ?:  ?=(%usr kind)
                          ;/("No user docs found.")
                        ;/("No developer docs found.")
                  ==
                ==
              manxes
        ==
      ==
    ==
  ::
      [%x ?([%dev @ @ @ ~] [%usr @ @ ~])]
    =/  [kind=?(%usr %dev) =desk agent=@tas file=@tas]
      ?:  ?=(%usr i.t.path)
        [%usr i.t.t.path *@tas i.t.t.t.path]
      [%dev i.t.t.path i.t.t.t.path i.t.t.t.t.path]
    =/  file-path=^path
      ?:  ?=(%usr kind)
        /doc/usr/[file]/gmi
      %+  weld  /doc/dev
      ?:  =(%$ agent)
        /[file]/gmi
      /[agent]/[file]/gmi
    =|  err=tape
    =^  gmi=(list gmni)  err
      ?.  .^(? %cu (scry:io desk file-path))
        [~ "Document missing."]
      :_  ~
      .^((list gmni) %cx (scry:io desk file-path))
    =^  content=manx  err
      ?~  err
        =/  cont=(unit manx)  (content gmi)
        ?~(cont [*manx "Document empty."] [u.cont ~])
      [*manx err]
    =^  [title=@t app=@t]  err
      ?~  err
        =/  [ut=(unit @t) ua=(unit @t)]
          (meta kind desk agent file)
        ?:  ?=(%usr kind)
          ?~  ut  [*[@t @t] "Document not listed."]
          ?~  ua  [*[@t @t] "App not found."]
          [[u.ut u.ua] ~]
        ?~  ut  [*[@t @t] "Document not listed."]
        [[u.ut *@t] ~]
      [*[@t @t] err]
    =/  header=manx  (header kind desk app agent title)
    =/  toc=(unit manx)  (toc gmi)
    ;html
      ;head
        ;title
          ;+  ?~  err
                ?:  ?=(%usr kind)
                  ;/("User docs > {(trip app)} > {(trip title)}")
                ;/  %+  weld
                      "Developer docs > {<desk>} > "
                    ?:  =(%$ agent)  "{(trip title)}"
                    "{<agent>} > {(trip title)}"
              ?:  ?=(%usr kind)
                ;/("User docs > Error")
              ;/("Developer docs > Error")
        ==
        ;meta(charset "utf-8");
        ;style:"{(trip style-doc)}"
      ==
      ;body
        ;*  ?~  err
              :~  ;div.box
                    ;+  header
                    ;+  ?~  toc
                          ;/  ""
                        ;div.toc
                          ;+  u.toc
                        ==
                    ;+  content
                  ==
              ==
            :~
              ;div.err
                ;p: {err}
                ;p
                  ;+  ?:  ?=(%usr kind)
                        ;a/"/~/scry/docs/usr.html#{(trip desk)}"
                          ;+  ;/("Go back")
                        ==
                      ;a/"/~/scry/docs/dev.html#{(trip desk)}"
                        ;+  ;/("Go back")
                      ==
                ==
              ==
            ==
      ==
    ==
  ==
  ++  meta
    |=  [kind=?(%dev %usr) =desk agent=@tas file=@tas]
    ^-  [(unit @t) (unit @t)]
    ?.  .^(? %cu (scry:io desk /doc/index))
      [~ ~]
    =/  =index
      !<  index
      %+  slap  !>(~)
      %-  ream
      %-  of-wain:format
      .^(wain %cx (scry:io desk /doc/index))
    =/  title=(unit @t)
      ?:  ?=(%usr kind)
        (~(get by (malt `(list doc)`->:index)) file)
      =+  `(jar @tas doc)`(malt `(list dev)`+>:index)
      (~(get by (malt (~(get ja -) agent))) file)
    ?:  ?=(%dev kind)
      [title ~]
    =+  .^(charge-update:docket %gx (scry:io %docket /charges/noun))
    ?>  ?=(%initial -.-)
    :-  title
    ?:  =(%base desk)
      `'Urbit OS'
    =/  app=(unit charge:docket)  (~(get by initial.-) desk)
    ?~  app  ~
    `title.docket.u.app
  ++  header
    |=  [kind=?(%dev %usr) =desk app=@t agent=@tas title=@t]
    ;header
      ;h1: {(trip title)}
      ;+  ?:  ?=(%usr kind)
            ;ul
              ;li
                ;a/"/~/scry/docs/usr.html": User
              ==
              ;li
                ;a/"/~/scry/docs/usr.html#{(trip desk)}": {(trip app)}
              ==
            ==
          ;ul.devnav
            ;li
              ;a/"/~/scry/docs/dev.html": Dev
            ==
            ;li
              ;a/"/~/scry/docs/dev.html#{(trip desk)}": {<desk>}
            ==
            ;*  ?:  =(%$ agent)
                  :~  ;/  ""
                  ==
                :~
                  ;li
                    ;a/"/~/scry/docs/dev.html#{(trip desk)}": {<agent>}
                  ==
                ==
          ==
    ==
  ++  toc
    |=  gmi=(list gmni)
    |^  ^-  (unit manx)
    =/  toc  (process gmi)
    ?~  toc  ~
    :-  ~
    ;nav
      ;h2: Table of Contents
      ;ul
        ;*  %+  turn  toc
            |=  [id=tape lvl=?(%1 %2 %3) txt=tape]
            ;li(class "l{(a-co:co lvl)}")
              ;a/"{id}": {txt}
            ==
      ==
    ==
    ++  process
      |=  gmi=(list gmni)
      ^-  (list [id=tape lvl=?(%1 %2 %3) txt=tape])
      %-  flop
      %-  tail
      %+  roll  gmi
      |=  $:  =gmni
              refs=(set tape)
              out=(list [id=tape lvl=?(%1 %2 %3) txt=tape])
          ==
      ?.  ?=(%head -.gmni)
        [refs out]
      =/  name=tape  (trip text.gmni)
      =/  n=@ud  1
      =|  suf=tape
      =/  id=tape
        %+  scan
          (cass name)
        (stag '#' (plus ;~(pose (cold '-' ;~(less aln next)) next)))
      |-
      =+  id-suf=(weld id suf)
      ?.  (~(has in refs) id-suf)
        :-  (~(put in refs) id-suf)
        :_  out
        [id-suf lvl.gmni name]
      $(n +(n), suf (weld "-" (a-co:co n)))
    --
  ++  menu
    |=  kind=?(%usr %dev)
    ^-  manx
    ;header
      ;+  ?:  ?=(%usr kind)
            ;h1: User Docs
          ;h1: Developer Docs
      ;h3
        ;+  ?:  ?=(%usr kind)
              ;a/"/~/scry/docs/dev.html": [switch to developer docs]
            ;a/"/~/scry/docs/usr.html": [switch to user docs]
      ==
    ==
  ++  content
    |=  gmi=(list gmni)
    |^  ^-  (unit manx)
    =/  content  (process (collapse gmi))
    ?~  content  ~
    :-  ~
    ;main
      ;*  content
    ==
    ++  process
      |=  gmi=(list gmni)
      ^-  (list manx)
      =|  out=(list manx)
      =|  refs=(set tape)
      |-
      ?~  gmi  (flop out)
      =^  elem=manx  refs
        ?-    -.i.gmi
            %text
          :_  refs
          ?~  text.i.gmi
            ;br;
          ;p: {(trip text.i.gmi)}
        ::
            %code
          :_  refs
          ;pre: {(trip text.i.gmi)}
        ::
            %list
          :_  refs
          ;ul
            ;li: {(trip text.i.gmi)}
          ==
        ::
            %quot
          :_  refs
          ;aside
            ;p: {(trip text.i.gmi)}
          ==
        ::
            %link
          :_  refs
          ;p.link
            ;+  ?~  text.i.gmi
                  ;a/"{(trip link.i.gmi)}": {(trip link.i.gmi)}
                ;a/"{(trip link.i.gmi)}": {(trip u.text.i.gmi)}
          ==
        ::
            %head
          ::  #ensure-the-section-id-is-unique
          ::
          =/  name=tape  (trip text.i.gmi)
          =/  n=@ud  1
          =|  suf=tape
          =/  id=tape
            %+  scan
              (cass name)
            (plus ;~(pose (cold '-' ;~(less aln next)) next))
          |-
          =+  id-suf=(weld id suf)
          ?.  (~(has in refs) id-suf)
            :_  (~(put in refs) id-suf)
            ?-    lvl.i.gmi
                %1
              ;div
                ;hr;
                ;h1(id id-suf): {name}
              ==
              %2  ;h2(id id-suf): {name}
              %3  ;h3(id id-suf): {name}
            ==
          $(n +(n), suf (weld "-" (a-co:co n)))
        ==
      $(gmi t.gmi, out [elem out], refs refs)
    --
  ++  dev-index
    ^-  (list manx)
    ::  get installed desks which have docs
    ::
    =/  desks=(list desk)
      %+  skim
        %~  tap  in
        %~  key  by
        .^((map desk *) %gx (scry:io %hood /kiln/ark/noun))
      |=  =desk
      .^(? %cu (scry:io desk /doc/index))
    ::  sort desks alphabetically
    ::
    =.  desks  (sort desks |=([a=desk b=desk] (aor a b)))
    ::  render desks and remove failures
    ::
    =/  u-list=(list (unit manx))
      (turn desks dev-desk)
    =|  out=(list manx)
    |-
    ?~  u-list
      (flop out)
    %=  $
      u-list  t.u-list
      out     ?~(i.u-list out [u.i.u-list out])
    ==
  ++  dev-desk
    |=  dsk=desk
    ^-  (unit manx)
    |^
    =/  processed=(list manx)
      (process dsk)
    ?~  processed  ~
    ::  final render
    ::
    :-  ~
    ;div.desk
      ;h2(id (trip dsk)): {<dsk>}
      ;ul
        ;*  processed
      ==
    ==
    ++  process
      |=  =desk
      ^-  (list manx)
      ::  read dev manifest for desk
      ::
      =/  devs=(list dev)
        %-  tail
        %-  tail
        !<  index
        %+  slap  !>(~)
        %-  ream
        %-  of-wain:format
        .^(wain %cx (scry:io desk /doc/index))
      ::  remove empty entries
      ::
      =.  devs
        %+  skip  devs
        |=(=dev ?~(docs.dev %.y %.n))
      ::  remove entries without matching agent in clay
      ::
      =.  devs
        %+  skim  devs
        |=  =dev
        ?:  =(%$ agent.dev)  %.y
        ?~  (get-fit:clay [our.bowl desk da+now.bowl] %app agent.dev)
          %.n
        %.y
      ::  remove duplicates
      ::
      =.  devs
        =|  out=(list dev)
        =|  have=(set term)
        |-
        ?~  devs
          (flop out)
        %=  $
          devs  t.devs
          have  (~(put in have) agent.i.devs)
          out   ?:  (~(has in have) agent.i.devs)
                  out
                [i.devs out]
        ==
      ::  sort alphabetically
      ::
      =.  devs
        %+  sort  devs
        |=([a=[term *] b=[term *]] (aor -.a -.b))
      ::  separate root docs if they exist
      ::
      =^  root=(unit dev)  devs
        ?~  devs  `devs
        ?:  =(%$ agent.i.devs)
          [`i.devs t.devs]
        `devs
      ::  render agent docs
      ::
      =/  agent-manxes=(list manx)
        %+  turn  devs
        |=  [agent=term docs=(list doc)]
        ;li.agent
          ;h3: {<agent>}
          ;ul
            ;*  %+  turn  docs
                |=  [file=term title=@t]
                =/  url=tape
                  ;:  weld
                    "/~/scry/docs/dev/"
                    (trip desk)   "/"
                    (trip agent)  "/"
                    (trip file)   ".html"
                  ==
                ;li
                  ;a/"{url}"
                    ;+  ;/  "{(trip title)}"
                  ==
          ==    ==
        ==
      ::  render root docs and combine with agent docs
      ::
      ?~  root
        agent-manxes
      =/  root-manxes=(list manx)
        %+  turn  docs.u.root
        |=  [file=term title=@t]
        ;li
          ;a/"/~/scry/docs/dev/{(trip desk)}//{(trip file)}.html"
            ;+  ;/  "{(trip title)}"
          ==
        ==
      (weld root-manxes agent-manxes)
    --
  ++  usr-index
    ^-  (list manx)
    ::  get installed desks which have docs
    ::
    =/  desks=(list desk)
      %+  skim
        %~  tap  in
        %~  key  by
        .^((map desk *) %gx (scry:io %hood /kiln/ark/noun))
      |=  =desk
      .^(? %cu (scry:io desk /doc/index))
    ::  get data from %docket and make map of desks to app names
    ::
    =/  names=(map desk @t)
      =/  charges
        .^(charge-update:docket %gx (scry:io %docket /charges/noun))
      ?>  ?=(%initial -.charges)
      (~(run by initial.charges) |=(=charge:docket title.docket.charge))
    ::  remove desks without %docket entry
    ::
    =.  desks
      %+  skim  desks
      |=  =desk
      ?|  =(%base desk)
          (~(has by names) desk)
      ==
    ::  sort alphabetically by name except with %base at top
    ::
    =.  desks
      %+  sort  desks
      |=  [a=desk b=desk]
      ?:  =(%base a)  %.y
      ?:  =(%base b)  %.n
      (aor (~(got by names) a) (~(got by names) b))
    ::  render desks and remove failures
    ::
    =/  u-list=(list (unit manx))
      (turn desks usr-app)
    =|  out=(list manx)
    |-
    ?~  u-list
      (flop out)
    %=  $
      u-list  t.u-list
      out     ?~(i.u-list out [u.i.u-list out])
    ==
  ++  usr-app
    |=  =desk
    ^-  (unit manx)
    ::  read in charges from %docket
    ::
    =/  charges
      .^(charge-update:docket %gx (scry:io %docket /charges/noun))
    ?>  ?=(%initial -.charges)
    ?.  |(=(%base desk) (~(has by initial.charges) desk))
      ~
    ::  get app name and tile color from charges
    ::
    =/  [name=@t color=@ux]
      ?:  =(%base desk)
        ['Urbit OS' 0xb1.dff1]
      [title.docket color.docket]:(~(got by initial.charges) desk)
    ::  read in usr docs index
    ::
    =/  docs=(list doc)
      %-  tail
      %-  head
      !<  index
      %+  slap  !>(~)
      %-  ream
      %-  of-wain:format
      .^(wain %cx (scry:io desk /doc/index))
    ::  render entries
    ::
    =/  manxes=(list manx)
      %+  turn  docs
      |=  [file=term title=@t]
      ;li
        ;a/"/~/scry/docs/usr/{(trip desk)}/{(trip file)}.html"
          ;+  ;/  "{(trip title)}"
        ==
      ==
    ?~  manxes  ~
    ::  background color
    ::
    =/  bg=tape
      =/  [r=@ud g=@ud b=@ud]
        :+  (cut 3 [2 1] color)
          (cut 3 [1 1] color)
        (end 3 color)
      "rgba({(a-co:co r)},{(a-co:co g)},{(a-co:co b)},0.5)"
    ::  final render
    ::
    :-  ~
    ;div.app(style "background-color:{bg};")
      ;h2(id (trip desk)): {(trip name)}
      ;ul
        ;*  manxes
      ==
    ==
  ::  process inline codeblocks
  ::
  ++  inline
    |=  text=@t
    ^-  (list manx)
    %+  rash  text
    %-  plus
    ;~  pose
      %+  cook
        |=  =tape
        ;code: {tape}
      (ifix [tic tic] (plus ;~(less tic next)))
      %+  cook
        |=  =tape
        ;/  tape
      (plus ;~(less (ifix [tic tic] (plus ;~(less tic next))) next))
    ==
  ::  collapse more than one empty line to only one
  ::
  ++  collapse
    |=  in=(list gmni)
    =|  out=(list gmni)
    =|  prev=_|
    |-
    ?~  in
      (flop out)
    =/  current=?
      ?.  ?=(%text -.i.in)
        %.n
      ?~(text.i.in %.y %.n)
    %=  $
      in    t.in
      prev  current
      out   ?:(&(prev current) out [i.in out])
    ==
  ++  style-index
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
    * {
      margin: 0;
      padding: 0;
    }
    body {
      font-size: 1.4em;
      font-family: Inter, sans;
      width: 100vw;
      margin: 0;
      padding: 0 1rem;
      overflow-x: hidden;
      box-sizing: border-box;
    }
    header {
      flex: 1 1 auto;
      width: 100%;
      max-width: 40rem;
      display: flex;
      flex-direction: row;
      flex-wrap: wrap;
      align-items: center;
      justify-content: space-between;
      overflow: hidden;
      box-sizing: border-box;
      margin-bottom: 1rem;
    }
    header h1 {
      font-size: 2em;
      margin: 0.4rem 0;
    }
    .err {margin: 20vh 1rem;}
    .app {
      flex: 1 1 auto;
      width: 100%;
      max-width: 40rem;
      border-radius: 0.4rem;
      box-sizing: border-box;
      margin: 1rem;
      padding: 1rem;
      overflow: hidden;
      background-blend-mode: darken;
      transition: background-color 0.2s;
    }
    .app ul {
      list-style-type: none;
      margin: 1rem 0;
    }
    .app:hover {background-color: #e6e6e6 !important;}
    a {text-decoration: none;}
    header a {color: #5a5a5a;}
    header a:hover {color: #cd0000;}
    .app a {color: black;}
    .app a:hover {color: #cd0000;}
    nav {
      display: flex;
      flex-direction: column;
      align-items: center;
      overflow: hidden;
    }
    .desk {
      flex: 1 1 auto;
      width: 100%;
      max-width: 40rem;
      border-radius: 0.4rem;
      box-sizing: border-box;
      background-color: #e6e6e6;
      overflow: hidden;
      margin: 1rem;
      padding: 1rem;
    }
    .desk h2,
    .desk h3 {
      font-family: "Source Code Pro", monospace;
      margin: 0;
      padding: 0;
    }
    .desk h3 {margin: 0.4rem 0;}
    .desk > ul {
      list-style-type: none;
      padding: 0;
      margin: 1rem 0;
    }
    .desk li,
    .app li {margin: 0.3rem 0;}
    .desk li > ul {
      padding: 0 0 0 2rem;
      margin: 0;
      list-style-type: none;
    }
    .desk a {
      color: black;
      text-decoration: none;
    }
    .desk a:hover {color: #cd0000;}
    '''
  ++  style-doc
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
    @media only screen and (max-width: 92rem) {
      .toc {
        margin: auto;
        width: 100%;
        max-width: 60rem;
      }
    }
    @media only screen and (min-width: 92rem) {
      .toc {
        height: 100vh;
        position: fixed;
        top: 0;
        left: 0;
        max-width: 16rem;
        display: flex;
        justify-content: center;
        flex-direction: column;
      }
    }
    body {
      font-size: 1.2em;
      font-family: Inter, sans;
      margin: 0;
      width: 100vw;
    }
    * {
      margin-block-start: 0;
      margin-block-end: 0;
      margin-inline-start: 0;
      margin-inline-end: 0;
    }
    .box {overflow: auto;}
    .err {
      display: flex;
      flex-direction: column;
      justify-content: center;
      align-content: center;
      width: 100vw;
      height: 100vh;
    }
    .err p {
      text-align: center;
      font-size: 1.6rem;
    }
    a {
      text-decoration: none;
    }
    header a,
    .err a {
      color: #cd0000;
    }
    header a:hover,
    .err a:hover {
      color: #ff7700;
    }
    header ul {
      color: #5a5a5a;
      margin: 0;
      padding: 0;
      font-size: 1.25em;
      font-weight: bold;
      display: flex;
      list-style-type: none;
      flex-wrap: wrap;
    }
    header li:not(:first-child)::before {
      content: ">";
      padding: 0 0.2rem;
    }
    header a {padding: 0 0.2rem;}
    .devnav {
      font-family: "Source Code Pro", monospace;
    }
    main, header {
      padding: 1rem;
      margin-left: auto;
      margin-right: auto;
      width: 100%;
      max-width: 60rem;
      box-sizing: border-box;
      line-height: 1.5;
    }
    main {
      margin-top: 2rem;
      margin-bottom: 0;
    }
    main > pre,
    main > aside {
      margin: 0;
      max-width: calc(100% - 2rem);
      width: fit-content;
    }

    main ul,
    header ul,
    nav ul {
      margin: 0;
      box-sizing: border-box;
      overflow: hidden;
    }
    main li {
      width: fit-content;
      margin: 0;
      max-width: 100%;
    }
    main h1,
    main h2,
    main h3,
    main p,
    header h1,
    nav h2 {
      text-overflow: ellipsis;
      overflow: hidden;
    }
    pre {
      background-color: #e6e6e6;
      font-family: "Source Code Pro", monospace;
      border-radius: 0.3em;
      padding: 1rem;
      overflow: auto;
      line-height: normal;
    }
    aside {
      background-color: #ffe8c7;
      font-style: italic;
      border-radius: 0.3em;
      padding: 1rem;
      width: fit-content;
    }
    nav {
      padding: 1rem;
    }
    .toc {
      box-sizing: border-box;
    }
    nav h2 {
      margin: 0;
      padding: 0;
    }
    nav ul {
      list-style-type: none;
      margin: 1rem 0 0 0;
      padding: 0;
      white-space: normal;
    }
    .link {color: #cd0000;}
    .link a {color: #cd0000;}
    .link a:hover {color: #ff7700;}
    nav a {
      color: black;
    }
    nav a:hover {color: #cd0000;}
    .l3 a {color: #5a5a5a;}
    .l1 {
      font-weight: bold;
      margin: 0.4rem 0;
    }
    .l2 {
      padding-left: 1rem;
      margin: 0.3rem 0;
    }
    .l3 {
      padding-left: 2rem;
      margin: 0.1rem 0;
    }
    '''
  --
++  on-init   on-init:def
++  on-save   on-save:def
++  on-load   on-load:def
++  on-poke   on-poke:def
++  on-watch  on-watch:def
++  on-leave  on-leave:def
++  on-agent  on-agent:def
++  on-arvo   on-arvo:def
++  on-fail   on-fail:def
--
