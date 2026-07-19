/-  *docs, *gemtext, docket, m=markdown
/+  *docs, *toc, styles=base16-styles, default-agent, dbug, agentio
/%  toc-mark-core  %toc
/%  clue-mark-core  %clue
/%  css-mark-core  %css
/$  gmi-docu   %gmi   %docu
/$  udon-docu  %udon  %docu
/$  txt-docu   %txt   %docu
/$  html-docu  %html  %docu
/$  md-docu    %md    %docu
::
|%
+$  versioned-state
  $%  state-0
      state-1
  ==
::
+$  state-0  [%0 dark=_|]
+$  state-1
  $:  %1
      dark=_|
      cached=(map @t @uv)
      watched=(set desk)
  ==
::
+$  cache-file  [mime=@t data=octs]
::
+$  card  card:agent:gall
--
::
=|  state-1
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
  =/  [cache-cards=(list card) new-cache=(map @t @uv)]
    (refresh-cache:hc cached)
  :_  this(cached new-cache)
  %+  weld
    ^-  (list card)
    :~  [%pass /bind %arvo %e %connect `/'docs' %docs]
        ~(tire pass:io /tire)
        [%pass /docket %agent [our.bowl %docket] %watch /charges]
    ==
  cache-cards
::
++  on-load
  |=  old-vase=vase
  ^-  (quip card _this)
  =/  old  !<(versioned-state old-vase)
  =.  state
    ?-  -.old
      %0  [%1 dark.old ~ ~]
      %1  old
    ==
  =^  cards=(list card)  cached
    (refresh-cache:hc cached)
  =?  cards  ?=(%0 -.old)
    %+  weld
      ^-  (list card)
      :~  ~(tire pass:io /tire)
          [%pass /docket %agent [our.bowl %docket] %watch /charges]
      ==
    cards
  [cards this]
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
        =/  [cache-cards=(list card) new-cache=(map @t @uv)]
          (refresh-theme:hc cached)
        [(weld cache-cards (go-to-index p.req)) this(cached new-cache)]
      :_  this(dark %.y)
      ~[(~(poke-self pass:io /self) [mark vase])]
    ::
        %light
      ?.  dark
        =/  [cache-cards=(list card) new-cache=(map @t @uv)]
          (refresh-theme:hc cached)
        [(weld cache-cards (go-to-index p.req)) this(cached new-cache)]
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
      [%x %font %source-sans-3-upright ~]
    ``woff2+!>(.^(octs %cx /(scot %p our.bowl)/docs/(scot %da now.bowl)/app/docs/fonts/source-sans-3-upright/woff2))
      [%x %font %source-sans-3-italic ~]
    ``woff2+!>(.^(octs %cx /(scot %p our.bowl)/docs/(scot %da now.bowl)/app/docs/fonts/source-sans-3-italic/woff2))
      [%x %font %sourcecodepro-regular ~]
    ``woff2+!>(.^(octs %cx /(scot %p our.bowl)/docs/(scot %da now.bowl)/app/docs/fonts/sourcecodepro-regular/woff2))
      [%x %font %sourcecodepro-semibold ~]
    ``woff2+!>(.^(octs %cx /(scot %p our.bowl)/docs/(scot %da now.bowl)/app/docs/fonts/sourcecodepro-semibold/woff2))
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
  ?+  wire  (on-arvo:def [wire sign-arvo])
      [%bind ~]
    ?.  ?=([%eyre %bound *] sign-arvo)
      (on-arvo:def [wire sign-arvo])
    ~?  !accepted.sign-arvo
      %eyre-rejected-docs-binding
    `this
  ::
      [%tire ~]
    ?>  ?=([%clay %tire *] sign-arvo)
    ?-  -.p.sign-arvo
        %&
      =/  live=(set desk)
        %-  ~(gas in *(set desk))
        %+  murn  ~(tap by p.p.sign-arvo)
        |=  [dsk=desk =zest:clay *]
        ?.(=(%live zest) ~ `dsk)
      =/  watch-cards=(list card)  (watch-cards:hc watched live)
      =.  watched  live
      =/  [cache-cards=(list card) new-cache=(map @t @uv)]
        (refresh-cache:hc cached)
      [(weld watch-cards cache-cards) this(cached new-cache)]
    ::
        %|
      =/  =wave:tire:clay  p.p.sign-arvo
      ?-  -.wave
          %zest
        =/  live=(set desk)
          ?:  =(%live zest.wave)
            (~(put in watched) desk.wave)
          (~(del in watched) desk.wave)
        =/  watch-cards=(list card)  (watch-cards:hc watched live)
        =.  watched  live
        =/  [cache-cards=(list card) new-cache=(map @t @uv)]
          (refresh-desk:hc cached desk.wave)
        [(weld watch-cards cache-cards) this(cached new-cache)]
      ::
          ?(%wait %warp)
        [~ this]
      ==
    ==
  ::
      [%clay @ @ *]
    ?>  ?=(%writ +<.sign-arvo)
    =/  dsk=desk  i.t.wire
    ?.  (~(has in watched) dsk)  [~ this]
    ?>  ?=(?(%t %x) i.t.t.wire)
    =/  car=care:clay  i.t.t.wire
    =/  pax=path  t.t.t.wire
    =/  [cache-cards=(list card) new-cache=(map @t @uv)]
      (refresh-changes:hc cached dsk (~(put in *(set (pair care:clay path))) [car pax]))
    =/  watch-cards=(list card)
      ?:  (wide-change:hc dsk car pax)
        (watch-desk:hc dsk)
      ?.  (~(has in (watch-paths:hc dsk)) [car pax])  ~
      [(watch-path:hc dsk car pax) ~]
    [(weld watch-cards cache-cards) this(cached new-cache)]
  ==
::
++  on-agent
  |=  [=wire =sign:agent:gall]
  ^-  (quip card _this)
  ?.  ?=([%docket ~] wire)  (on-agent:def wire sign)
  ?+    -.sign  (on-agent:def wire sign)
      %watch-ack  [~ this]
      %fact
    ?>  =(%charge-update p.cage.sign)
    =/  update=charge-update:docket
      !<(charge-update:docket q.cage.sign)
    ?-  -.update
      %initial
        =/  [cache-cards=(list card) new-cache=(map @t @uv)]
          (refresh-cache:hc cached)
        [cache-cards this(cached new-cache)]
      %add-charge
        =/  [cache-cards=(list card) new-cache=(map @t @uv)]
          (refresh-desk:hc cached desk.update)
        [cache-cards this(cached new-cache)]
      %del-charge
        =/  [cache-cards=(list card) new-cache=(map @t @uv)]
          (refresh-desk:hc cached desk.update)
        [cache-cards this(cached new-cache)]
    ==
  ::
      %kick
    :_  this
    [%pass /docket %agent [our.bowl %docket] %watch /charges]~
  ==
++  on-fail   on-fail:def
++  on-leave  on-leave:def
--
::
|_  =bowl:gall
+*  io    ~(. agentio bowl)
    pass  pass:io
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
:: construct an authenticated Eyre cache entry for a rendered page
::
++  cache-entry
  |=  file=cache-file
  ^-  cache-entry:eyre
  =/  hed=response-header:http
    :-  200
    :~  ['Content-Type' mime.file]
        ['Content-Length' (crip ((d-co:co 1) p.data.file))]
    ==
  =/  payload=simple-payload:http  [hed `data.file]
  [& %payload payload]
:: eagerly render the styles, index and every indexed document
::
++  cache-pages
  ^-  (map @t cache-file)
  =/  idx=octs
    (as-octs:mimes:html (crip (en-xml:html index)))
  =/  pages=(map @t cache-file)
    %-  ~(gas by *(map @t cache-file))
    :~  ['/docs' 'text/html' idx]
        ['/docs/' 'text/html' idx]
        ['/docs/assets/style/var.css' 'text/css' (as-octs:mimes:html ?:(dark dark:css light:css))]
        ['/docs/assets/style/index.css' 'text/css' (as-octs:mimes:html index:css)]
        ['/docs/assets/style/page.css' 'text/css' (as-octs:mimes:html page:css)]
        ['/docs/assets/style/err.css' 'text/css' (as-octs:mimes:html err:css)]
    ==
  %-  ~(gas by pages)
  %-  zing
  %+  turn  ~(tap by desk-map)
  |=  [dsk=desk *]
  ~(tap by (desk-pages dsk))
:: render every indexed page belonging to one live desk
::
++  desk-pages
  |=  dsk=desk
  ^-  (map @t cache-file)
  ?.  (~(has by desk-map) dsk)  ~
  %-  malt
  ^-  (list [@t cache-file])
  ^-  (list [@t cache-file])
  =/  utoc=(unit [? =toc])  (read-toc dsk)
  ?~  utoc  ~
  %+  murn  toc.u.utoc
  |=  =ent
  ^-  (unit [@t cache-file])
  ?.  ?=(%fil -.ent)  ~
  ?>  ?=(^ pa.ent)
  =/  pa=path  (flop t.pa.ent)
  =/  url=@t  (crip (spud [%docs dsk pa]))
  =/  dat=octs
    (as-octs:mimes:html (crip (en-xml:html (make-doc dsk pa))))
  `[url 'text/html' dat]
:: reconcile freshly rendered pages with the URLs already cached in Eyre
::
++  refresh-cache
  |=  old=(map @t @uv)
  ^-  [(list card) (map @t @uv)]
  =/  pages=(map @t cache-file)  cache-pages
  =/  fresh=(map @t @uv)
    %-  ~(run by pages)
    |=  file=cache-file
    (mug file)
  =/  updates=(list card)
    %+  murn  ~(tap by pages)
    |=  [url=@t file=cache-file]
    =/  old-hash=(unit @uv)  (~(get by old) url)
    ?:  ?&(?=(^ old-hash) =(u.old-hash (~(got by fresh) url)))  ~
    `(~(arvo pass /cache) %e %set-response url `(cache-entry file))
  =/  removed=(set @t)
    (~(dif in ~(key by old)) ~(key by fresh))
  =/  deletes=(list card)
    %+  turn  ~(tap in removed)
    |=(url=@t (~(arvo pass /cache) %e %set-response url ~))
  [(weld updates deletes) fresh]
:: replace only the theme-dependent stylesheet after a mode change
::
++  refresh-theme
  |=  old=(map @t @uv)
  ^-  [(list card) (map @t @uv)]
  =/  url=@t  '/docs/assets/style/var.css'
  =/  file=cache-file
    ['text/css' (as-octs:mimes:html ?:(dark dark:css light:css))]
  =/  hash=@uv  (mug file)
  =/  fresh=(map @t @uv)  (~(put by old) url hash)
  =/  old-hash=(unit @uv)  (~(get by old) url)
  ?:  ?&(?=(^ old-hash) =(u.old-hash hash))  [~ fresh]
  =/  card=card
    (~(arvo pass /cache) %e %set-response url `(cache-entry file))
  [[card ~] fresh]
:: reconcile a partial set of rendered pages and explicitly removable URLs
::
++  refresh-pages
  |=  [old=(map @t @uv) pages=(map @t cache-file) remove=(set @t)]
  ^-  [(list card) (map @t @uv)]
  =/  updates=(list card)
    %+  murn  ~(tap by pages)
    |=  [url=@t file=cache-file]
    =/  hash=@uv  (mug file)
    =/  old-hash=(unit @uv)  (~(get by old) url)
    ?:  ?&(?=(^ old-hash) =(u.old-hash hash))  ~
    `(~(arvo pass /cache) %e %set-response url `(cache-entry file))
  =/  fresh=(map @t @uv)
    %+  roll  ~(tap by pages)
    |=  [[url=@t file=cache-file] out=(map @t @uv)]
    (~(put by out) url (mug file))
  =.  fresh  (~(uni by fresh) old)
  =/  gone=(set @t)  (~(dif in remove) ~(key by pages))
  =/  deletes=(list card)
    %+  turn  ~(tap in gone)
    |=(url=@t (~(arvo pass /cache) %e %set-response url ~))
  =.  fresh
    %+  roll  ~(tap in gone)
    |=  [url=@t out=(map @t @uv)]
    (~(del by out) url)
  [(weld updates deletes) fresh]
:: rebuild the index and all cached pages belonging to one desk
::
++  refresh-desk
  |=  [old=(map @t @uv) dsk=desk]
  ^-  [(list card) (map @t @uv)]
  =/  idx=cache-file
    ['text/html' (as-octs:mimes:html (crip (en-xml:html index)))]
  =/  pages=(map @t cache-file)
    (~(put by (desk-pages dsk)) '/docs/' idx)
  =.  pages  (~(put by pages) '/docs' idx)
  =/  prefix=tape  (weld "/docs/" (weld (trip dsk) "/"))
  =/  remove=(set @t)
    %-  silt
    %+  murn  ~(tap in ~(key by old))
    |=  url=@t
    =/  txt=tape  (trip url)
    ?:  ?&  (lte (lent prefix) (lent txt))
            =(prefix (scag (lent prefix) txt))
        ==
      `url
    ~
  (refresh-pages old pages remove)
:: rebuild or remove one indexed document page
::
++  refresh-doc
  |=  [old=(map @t @uv) dsk=desk pa=path]
  ^-  [(list card) (map @t @uv)]
  =/  url=@t  (crip (spud [%docs dsk pa]))
  =/  pages=(map @t cache-file)
    ?.  (indexed dsk pa)  ~
    =/  dat=octs
      (as-octs:mimes:html (crip (en-xml:html (make-doc dsk pa))))
    (~(put by *(map @t cache-file)) url ['text/html' dat])
  =/  remove=(set @t)  (~(put in *(set @t)) url)
  (refresh-pages old pages remove)
:: classify exact %mult changes and apply only the necessary rebuilds
::
++  refresh-changes
  |=  [old=(map @t @uv) src=desk changes=(set (pair care:clay path))]
  ^-  [(list card) (map @t @uv)]
  =|  wide=(set desk)
  =|  docs=(set [desk path])
  =/  [new-wide=(set desk) new-docs=(set [desk path])]
    %+  roll  ~(tap in changes)
    |=  [[car=care:clay pax=path] wide-out=(set desk) docs-out=(set [desk path])]
    ?:  ?&  =(%docs src)
            =(%t car)
            =(/doc pax)
        ==
      [(~(uni in wide-out) ~(key by desk-map)) docs-out]
    =/  mapped=(unit [desk path])  (source-target src pax)
    ?~  mapped  [wide-out docs-out]
    =/  [dsk=desk rem=path]  u.mapped
    ?:  ?|  =(%t car)
            =(/toc rem)
            =(/clue rem)
        ==
      [(~(put in wide-out) dsk) docs-out]
    ?~  rem  [wide-out docs-out]
    ?~  t.rem  [wide-out docs-out]
    =/  rev=path  (flop rem)
    ?>  ?=(^ rev)
    =/  pa=path  (flop t.rev)
    ?.  (indexed dsk pa)  [wide-out docs-out]
    [wide-out (~(put in docs-out) [dsk pa])]
  =.  wide  new-wide
  =.  docs  new-docs
  =/  [wide-cards=(list card) wide-cache=(map @t @uv)]
    =/  desks=(list desk)  ~(tap in wide)
    =/  cards=(list card)  ~
    =/  cache=(map @t @uv)  old
    |-
    ?~  desks  [cards cache]
    =/  [next-cards=(list card) next-cache=(map @t @uv)]
      (refresh-desk cache i.desks)
    $(desks t.desks, cards (weld cards next-cards), cache next-cache)
  =/  files=(list [desk path])  ~(tap in docs)
  =/  cards=(list card)  wide-cards
  =/  cache=(map @t @uv)  wide-cache
  |-
  ?~  files  [cards cache]
  =/  [dsk=desk pa=path]  i.files
  ?:  (~(has in wide) dsk)  $(files t.files)
  =/  [next-cards=(list card) next-cache=(map @t @uv)]
    (refresh-doc cache dsk pa)
  $(files t.files, cards (weld cards next-cards), cache next-cache)
:: map a physical source path to its logical documentation desk and path
::
++  source-target
  |=  [src=desk pax=path]
  ^-  (unit [desk path])
  ?+  pax  ~
    [%doc %inc @ %doc *]
      ?.  =(%docs src)  ~
      `[i.t.t.pax t.t.t.t.pax]
    [%doc *]  `[src t.pax]
  ==
:: test whether a logical page is currently present in a desk's ToC
::
++  indexed
  |=  [dsk=desk pa=path]
  ^-  ?
  =/  utoc=(unit [? =toc])  (read-toc dsk)
  ?~  utoc  |
  %+  lien  toc.u.utoc
  |=  =ent
  ?&  ?=(%fil -.ent)
      ?=(^ pa.ent)
      =(pa (flop t.pa.ent))
  ==
:: construct the paths watched by one Clay %mult subscription
::
++  watch-paths
  |=  src=desk
  ^-  (set (pair care:clay path))
  =/  paths=(set (pair care:clay path))
    =/  initial=(list (pair care:clay path))
      ?:  .^(? %cu (scrio src /doc/toc))
        ~[[%x /doc/toc]]
      ?:  .^(? %cu (scrio src /doc/clue))
        ~[[%x /doc/clue]]
      ~[[%t /doc]]
    (silt initial)
  %-  ~(gas in paths)
  %-  zing
  %+  murn  ~(tap by desk-map)
  |=  [target=desk *]
  ^-  (unit (list (pair care:clay path)))
  =/  utoc=(unit [inc=? =toc])  (read-toc target)
  ?~  utoc  ~
  =/  physical=desk  ?:(inc.u.utoc %docs target)
  ?.  =(src physical)  ~
  =/  base=path  ?.(inc.u.utoc /doc /doc/inc/[target]/doc)
  =/  files=(list (pair care:clay path))
    %+  murn  toc.u.utoc
    |=  =ent
    ?.  ?=(%fil -.ent)  ~
    ?>  ?=(^ pa.ent)
    `[%x (weld base (flop pa.ent))]
  =/  result=(list (pair care:clay path))
    ?.  inc.u.utoc  files
    =/  index-path=path
      ?:  .^(? %cu (scrio src (snoc base %toc)))
        (snoc base %toc)
      (snoc base %clue)
    [[%x index-path] files]
  `result
:: subscribe to the exact set of documentation inputs on one desk
::
++  watch-desk
  |=  dsk=desk
  ^-  (list card)
  %+  turn  ~(tap in (watch-paths dsk))
  |=  [car=care:clay pax=path]
  (watch-path dsk car pax)
:: subscribe to one documentation input, encoding it in the response wire
::
++  watch-path
  |=  [dsk=desk car=care:clay pax=path]
  ^-  card
  =/  wir=wire  (weld /clay/[dsk]/[car] pax)
  (~(warp-our pass wir) dsk ~ %next car da+now.bowl pax)
:: cancel current per-path watches and the former whole-desk watch wire
::
++  cancel-desk
  |=  dsk=desk
  ^-  (list card)
  :-  (~(warp-our pass /clay/[dsk]) dsk ~)
  :-  (~(warp-our pass /clay/[dsk]/t/doc) dsk ~)
  %+  turn  ~(tap in (watch-paths dsk))
  |=  [car=care:clay pax=path]
  =/  wir=wire  (weld /clay/[dsk]/[car] pax)
  (~(warp-our pass wir) dsk ~)
:: whether a changed input requires rebuilding and re-watching a whole desk
::
++  wide-change
  |=  [src=desk car=care:clay pax=path]
  ^-  ?
  ?:  =(%t car)  &
  =/  mapped=(unit [desk path])  (source-target src pax)
  ?~  mapped  |
  =/  [dsk=desk rem=path]  u.mapped
  ?|  =(/toc rem)
      =(/clue rem)
  ==
:: create and cancel Clay subscriptions as the live desk set changes
::
++  watch-cards
  |=  [old=(set desk) live=(set desk)]
  ^-  (list card)
  =/  added=(set desk)  (~(dif in live) old)
  =/  removed=(set desk)  (~(dif in old) live)
  =/  adds=(list card)
    %-  zing
    %+  turn  ~(tap in added)
    |=  dsk=desk
    (watch-desk dsk)
  =/  dels=(list card)
    %-  zing
    %+  turn  ~(tap in removed)
    |=  dsk=desk
    (cancel-desk dsk)
  (weld adds dels)
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
      ;meta(name "viewport", content "width=device-width, initial-scale=1");
      ;link(rel "stylesheet", href "/docs/assets/style/var.css");
      ;link(rel "stylesheet", href "/docs/assets/style/index.css");
    ==
    ;body
      ;div.app-shell
        ;header.site-header
          ;a.brand(href "/docs")
            ;span.brand-mark: D
            ;span: Docs
          ==
          ;form(method "post")
            ;button.theme-toggle
              =type   "submit"
              =name   "mode"
              =value  ?:(dark "light" "dark")
              ;+  ;/  ?:(dark "Use light theme" "Use dark theme")
            ==
          ==
        ==
        ;main.index-main
          ;div.index-intro
            ;p.eyebrow: Library
            ;h1: Documentation
            ;p: Browse the guides, references, and manuals published by desks on this ship.
          ==
          ;div.library-grid
            ;*  make-index
          ==
        ==
      ==
    ==
  ==
:: render doc table of contents
::
++  navbar
  |=  utoc=(unit manx)
  ^-  manx
  ?~  utoc  ;aside.page-toc;
  ;aside.page-toc
    ;nav.page-toc-nav.page-toc-desktop
      ;p.toc-label: On this page
      ;+  u.utoc
    ==
    ;details.page-toc-details.page-toc-mobile
      ;summary.page-toc-summary
        ;span: On this page
        ;span.page-toc-chevron: ↓
      ==
      ;nav.page-toc-nav
        ;p.toc-label: On this page
        ;+  u.utoc
      ==
    ==
  ==
:: render header element
::
++  header
  |=  [nam=tape menu=manx]
  ^-  manx
  ;header.doc-header
    ;div.doc-topbar
      ;a.brand(href "/docs")
        ;span.brand-mark: D
        ;span: Docs
      ==
      ;+  menu
    ==
    ;div.doc-heading
      ;p.eyebrow: Document
      ;h1: {nam}
    ==
  ==
:: render desk ToC menu
::
++  dropdown
  |=  [dsk=desk dsk-nam=tape =toc]
  ^-  manx
  =/  menu  (ent-to-manx dsk toc)
  ;details.desk-menu
    ;summary
      ;span.desk-menu-label: Browse desk
      ;span.desk-menu-name: {dsk-nam}
    ==
    ;nav.desk-menu-panel
      ;div.desk-menu-heading
        ;span: {dsk-nam}
        ;a(href "/docs#{(trip dsk)}"): View in library
      ==
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
      ;meta(name "viewport", content "width=device-width, initial-scale=1");
      ;link(rel "stylesheet", href "/docs/assets/style/var.css");
      ;link(rel "stylesheet", href "/docs/assets/style/page.css");
    ==
    ;body
      ;div.app-shell
        ;+  hed
        ;div.content-grid
          ;+  toc
          ;main.document-content
            ;+  cnt
          ==
        ==
        ;+  fot
      ==
    ==
  ==
:: render doc footer element
::
++  footer
  |=  [prv=(unit (pair path tape)) nxt=(unit (pair path tape))]
  ^-  manx
  ;footer.page-footer
    ;div.pager-slot
      ;+  ?~  prv  ;/("\c2\a0")
          ;a.pager-link(href (spud p.u.prv))
            ;span.pager-direction: Previous
            ;span.pager-title: {q.u.prv}
            ;span.pager-arrow: ←
          ==
    ==
    ;div.pager-slot.next
      ;+  ?~  nxt  ;/("\c2\a0")
          ;a.pager-link(href (spud p.u.nxt))
            ;span.pager-direction: Next
            ;span.pager-title: {q.u.nxt}
            ;span.pager-arrow: →
          ==
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
      ;meta(name "viewport", content "width=device-width, initial-scale=1");
      ;link(rel "stylesheet", href "/docs/assets/style/var.css");
      ;link(rel "stylesheet", href "/docs/assets/style/err.css");
    ==
    ;body
      ;div.err
        ;p.eyebrow: Docs could not render this page
        ;h1: Something went sideways.
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
          ;a/"/docs#{(trip dsk)}": ← Return to the library
        ==
      ==
    ==
  ==
:: make the list of entries for the index page
::
++  make-index
  ^-  marl
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
  ;section.desk-card(id (trip dsk))
    ;div.desk-card-heading
      ;span.desk-glyph: D
      ;h2: {nam}
    ==
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
  |^  ^-  [(unit (pair path tape)) (unit (pair path tape))]
  =.  pa  (flop pa)
  =/  files=(list (pair path @t))  (file-paths t)
  =/  ind=(unit @)
    %+  find  ~[pa]
    (turn files |=(x=(pair path @t) p.x))
  ?~  ind  [~ ~]
  =/  prev=(unit (pair path tape))
    ?:  =(0 u.ind)  ~
    =/  ent=(pair path @t)  (snag (dec u.ind) files)
    `[[%docs dsk (flop p.ent)] (trip q.ent)]
  =/  next=(unit (pair path tape))
    ?:  =(u.ind (dec (lent files)))  ~
    =/  ent=(pair path @t)  (snag +(u.ind) files)
    `[[%docs dsk (flop p.ent)] (trip q.ent)]
  [prev next]
  ++  file-paths
    |=  =toc
    ^-  (list (pair path @t))
    %-  flop
    %+  roll  toc
    |=  [e=ent acc=(list (pair path @t))]
    ?:  ?=(%dir -.e)
      acc
    ?>  ?=(^ pa.e)
    [[t.pa.e nam.e] acc]
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
::   get from %docs desk instead.
::   if there's no toc file at all, but there are other files under /doc,
::   construct a toc from the file listing
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
  ?~  u  (bind (infer-toc dsk) (lead |))
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
:: infer a toc for a desk from its /doc folder contents in clay
::
++  infer-toc
  |=  dsk=desk
  ^-  (unit toc)
  =+  .^(arc=arch %cy (scrio dsk /doc))
  ?:  =(~ dir.arc)  ~
  %-  some
  %-  process
  ^-  (list raw)
  |^  (loop (sort ~(tap in ~(key by dir.arc)) tor))
  ::
  ++  loop
    =/  bas=path  /doc
    =/  lev=@ud   0
    |=  nex=(list @ta)
    ^-  (list raw)
    ?~  nex  ~
    =-  (weld - $(nex t.nex))
    =+  .^(arc=arch %cy (scrio dsk (snoc bas i.nex)))
    ::  files should have been handled by the code below
    ::
    ?>  =(~ fil.arc)
    ::  for all children that are files (file exts), produce the file here,
    ::  before we start delving into the children (dirs) themselves
    ::
    =/  [fiz=(list raw) dex=(list @ta)]
      %+  roll
        (sort ~(tap in ~(key by dir.arc)) tor)
      |=  [kid=@ta fiz=(list raw) dex=(list @ta)]
      =+  .^(arc=arch %cy (scrio dsk (weld bas ~[i.nex kid])))
      ?.  ?=([^ ~] arc)  [fiz (snoc dex kid)]
      [(snoc fiz [lev [i.nex kid] (to-title i.nex)]) dex]
    %+  weld  fiz
    ^-  (list raw)
    ?:  =(~ dex)  ~
    ::  add a dir entry, and delve deeper
    ::
    :-  [lev i.nex (to-title i.nex)]
    $(lev +(lev), bas (snoc bas i.nex), nex dex)
  ::
  ++  tor  ::  like +aor, but "overview" always at the top
    |=  [a=@t b=@t]
    ?:  =(a 'overview')  &
    ?:  =(b 'overview')  |
    (aor a b)
  ::
  ++  to-title  ::  change 'some-name' into 'Some Name'
    |=  nom=@ta
    ^-  @t
    ?:  =('usr' nom)  'User'
    ?:  =('dev' nom)  'Developer'
    %-  crip
    %+  roll  (trip nom)
    |=  [c=@t n=tape]
    %+  snoc  n
    ?:  =('-' c)  ' '
    =/  cap=?  |(=(~ n) =(' ' (rear n)))
    ?:(&(cap (gte c 'a') (lte c 'z')) (sub c 32) c)
  --
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
    ?:  ?=(?(%gmi %udon %txt %html %md) mar)  ~
    [~ .^(tube:clay %cc (scrio rt /[mar]/docu))]
  :: read file & perform mark conversion
  ::
  =/  docu=(each manx tang)
    ?~  tub
      ?.  ?=(?(%gmi %udon %txt %html %md) mar)
        [%.n leaf+"could not build mark conversion tube" ~]
      %-  mule
      ?-  mar
        %udon  |.((udon-docu .^(@t %cx (scrio rt pt))))
        %html  |.((html-docu .^(@t %cx (scrio rt pt))))
        %md    |.((md-docu .^(markdown:m %cx (scrio rt pt))))
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
