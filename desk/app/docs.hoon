/-  *docs, *gemtext, docket, m=markdown
/+  *docs, *toc, renderer=docs-highlighter, default-agent, dbug, agentio
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
+$  cache-file
  $:  status=@ud
      auth=?
      no-store=?
      mime=@t
      data=octs
  ==
::
+$  versioned-state
  $%  state-0
      state-1
      state-2
      state-3
      state-4
      state-5
      state-6
      state-7
      state-8
      state-9
      state-10
  ==
::
+$  theme  ?(%system %light %dark)
+$  state-0  [%0 dark=_|]
+$  state-1
  $:  %1
      dark=_|
      cached=(map @t @uv)
      watched=(set desk)
  ==
+$  legacy-render-job
  $:  url=@t
      generation=@ud
      dsk=desk
      pa=path
  ==
+$  state-2
  $:  %2
      dark=_|
      cached=(map @t @uv)
      watched=(set desk)
      generations=(map @t @ud)
      jobs=(map @t legacy-render-job)
      waiting=(map @t (list @ta))
  ==
+$  state-3
  $:  %3
      =theme
      cached=(map @t @uv)
      watched=(set desk)
      generations=(map @t @ud)
      jobs=(map @t legacy-render-job)
      waiting=(map @t (list @ta))
  ==
+$  state-4
  $:  %4
      =theme
      cached=(map @t @uv)
      watched=(set desk)
  ==
+$  state-5
  $:  %5
      =theme
      cached=(map @t @uv)
      watched=(set desk)
      public=(set desk)
      public-title=(unit @t)
      public-subtitle=(unit @t)
  ==
+$  state-6
  $:  %6
      =theme
      cached=(map @t @uv)
      watched=(set desk)
      public-enabled=?
      public=(set desk)
      public-title=(unit @t)
      public-subtitle=(unit @t)
  ==
+$  state-7
  $:  %7
      =theme
      cached=(map @t cache-file)
      watched=(set desk)
      public-enabled=?
      public=(set desk)
      public-title=(unit @t)
      public-subtitle=(unit @t)
  ==
+$  state-8
  $:  %8
      =theme
      cached=(map @t @uv)
      watched=(set desk)
      public-enabled=?
      public=(set desk)
      public-title=(unit @t)
      public-subtitle=(unit @t)
  ==
+$  state-9
  $:  %9
      =theme
      cached=(map @t @uv)
      watched=(set desk)
      public-enabled=?
      public=(set desk)
      public-title=(unit @t)
      public-subtitle=(unit @t)
      pending=(set @t)
  ==
+$  state-10
  $:  %10
      =theme
      cached=(map @t @uv)
      watched=(set desk)
      public-enabled=?
      public=(set desk)
      public-title=(unit @t)
      public-subtitle=(unit @t)
  ==
::
+$  card  card:agent:gall
+$  refresh-result  [cards=(list card) cache=(map @t @uv)]
+$  eyre-cache  (map @t [aeon=@ud val=(unit cache-entry:eyre)])
::
--
::
=|  state-10
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
      %0  [%10 %system ~ ~ | ~ ~ ~]
      %1  [%10 %system cached.old watched.old | ~ ~ ~]
      %2  [%10 %system cached.old watched.old | ~ ~ ~]
      %3  [%10 theme.old cached.old watched.old | ~ ~ ~]
      %4  [%10 theme.old cached.old watched.old | ~ ~ ~]
      %5  [%10 theme.old cached.old watched.old & public.old public-title.old public-subtitle.old]
      %6  [%10 theme.old cached.old watched.old public-enabled.old public.old public-title.old public-subtitle.old]
      %7
        =/  hashes=(map @t @uv)
          %+  roll  ~(tap by cached.old)
          |=  [[url=@t file=cache-file] out=(map @t @uv)]
          (~(put by out) url (mug file))
        [%10 theme.old hashes watched.old public-enabled.old public.old public-title.old public-subtitle.old]
      %8  [%10 theme.old cached.old watched.old public-enabled.old public.old public-title.old public-subtitle.old]
      %9  [%10 theme.old cached.old watched.old public-enabled.old public.old public-title.old public-subtitle.old]
      %10  old
    ==
  =/  [cards=(list card) new-cache=(map @t @uv)]
    (refresh-cache:hc cached)
  =.  cached  new-cache
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
  ?.  ?=(%handle-http-request mark)
    (on-poke:def [mark vase])
  =/  req  !<  (pair @ta inbound-request:eyre)  vase
  =/  signed-in=?  =(our.bowl src.bowl)
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
    ?.  ?=([%docs *] path)  (on-poke:def [mark vase])
    ?~  t.path
      (go-to-root p.req)
    ?:  ?=([%private ~] t.path)
      ?.  signed-in  (require-sign-in p.req)
      (go-to-private p.req)
    ?:  ?=([%public ~] t.path)
      (go-to-public p.req)
    ?:  ?=([%settings ~] t.path)
      ?.  signed-in  (require-sign-in p.req)
      (go-to-settings p.req)
    ?:  =(%assets i.t.path)
      (go-to-static p.req t.t.path)
    ?.  ?=([%d @ *] t.path)  (on-poke:def [mark vase])
    =/  dsk=desk  i.t.t.path
    ?.  ?|  signed-in
            ?&(public-enabled (~(has in public) dsk))
        ==
      (require-sign-in p.req)
    (go-to-page p.req dsk t.t.t.path)
  ::
      %'POST'
    ?.  ?=([%docs %settings ~] path)
      :_  this
      (give-response p.req [404 ~] ~)
    ?.  signed-in  (require-sign-in p.req)
    ?~  body.request.q.req  [(settings-redirect p.req %error) this]
    =/  parsed=(unit (list [k=@t v=@t]))
      (rush q.u.body.request.q.req yquy:de-purl:html)
    ?~  parsed  [(settings-redirect p.req %error) this]
    =/  query=(list [k=@t v=@t])  u.parsed
    =/  section=(unit @t)  (query-value %section query)
    ?~  section  [(settings-redirect p.req %error) this]
    ?+    u.section  [(settings-redirect p.req %error) this]
        %appearance
      =/  value=(unit @t)  (query-value %mode query)
      ?~  value  [(settings-redirect p.req %error) this]
      =/  new-theme=(unit ?(%system %light %dark))
        ?+  u.value  ~
          %system  `%system
          %light   `%light
          %dark    `%dark
        ==
      ?~  new-theme  [(settings-redirect p.req %error) this]
      ?:  =(theme u.new-theme)
        [(settings-redirect p.req %appearance) this]
      =.  theme  u.new-theme
      =/  [cache-cards=(list card) new-cache=(map @t @uv)]
        (refresh-theme:hc cached)
      [(weld cache-cards (settings-redirect p.req %appearance)) this(cached new-cache)]
    ::
        %publication
      =/  new-enabled=?  ?=(^ (query-value %enabled query))
      =/  new-public=(set desk)
        %-  silt
        %+  murn  query
        |=  [key=@t value=@t]
        ?.  =(%public key)  ~
        (slaw %tas value)
      =.  new-public  (~(int in new-public) ~(key by desk-map:hc))
      =/  new-title=(unit @t)
        (nonempty (query-value %title query))
      =/  new-subtitle=(unit @t)
        (nonempty (query-value %subtitle query))
      ?:  ?&  =(public-enabled new-enabled)
              =(public new-public)
              =(public-title new-title)
              =(public-subtitle new-subtitle)
          ==
        [(settings-redirect p.req %publication) this]
      =/  changed=(set desk)
        (~(uni in (~(dif in public) new-public)) (~(dif in new-public) public))
      =.  changed
        ?:  !=(public-enabled new-enabled)
          (~(uni in changed) (~(uni in public) new-public))
        ?:  new-enabled  changed
        ~
      =.  public-enabled   new-enabled
      =.  public           new-public
      =.  public-title     new-title
      =.  public-subtitle  new-subtitle
      =/  result=refresh-result
        (refresh-publication:hc cached changed)
      [(weld cards.result (settings-redirect p.req %publication)) this(cached cache.result)]
    ==
  ==
  ::
  ++  go-to-root
    |=  id=@ta
    ^-  (quip card _this)
    =/  file=cache-file  (~(got by static-pages:hc) '/docs')
    =/  hash=@uv  (mug file)
    =/  cache-cards=(list card)
      :~  (~(arvo pass:io /cache) %e %set-response '/docs' `(cache-entry:hc file))
          (~(arvo pass:io /cache) %e %set-response '/docs/' `(cache-entry:hc file))
      ==
    =/  new-cache=(map @t @uv)  (~(put by cached) '/docs' hash)
    =.  new-cache  (~(put by new-cache) '/docs/' hash)
    :_  this(cached new-cache)
    (weld cache-cards (response-cards:hc id status.file mime.file data.file))
  ::
  ++  go-to-private
    |=  id=@ta
    ^-  (quip card _this)
    =/  file=cache-file  (~(got by static-pages:hc) '/docs/private')
    =/  hash=@uv  (mug file)
    =/  cache-cards=(list card)
      :~  (~(arvo pass:io /cache) %e %set-response '/docs/private' `(cache-entry:hc file))
          (~(arvo pass:io /cache) %e %set-response '/docs/private/' `(cache-entry:hc file))
      ==
    =/  new-cache=(map @t @uv)  (~(put by cached) '/docs/private' hash)
    =.  new-cache  (~(put by new-cache) '/docs/private/' hash)
    :_  this(cached new-cache)
    (weld cache-cards (response-cards:hc id status.file mime.file data.file))
  ::
  ++  go-to-public
    |=  id=@ta
    ^-  (quip card _this)
    =/  file=cache-file  (~(got by static-pages:hc) '/docs/public')
    =/  hash=@uv  (mug file)
    =/  cache-cards=(list card)
      :~  (~(arvo pass:io /cache) %e %set-response '/docs/public' `(cache-entry:hc file))
          (~(arvo pass:io /cache) %e %set-response '/docs/public/' `(cache-entry:hc file))
      ==
    =/  new-cache=(map @t @uv)  (~(put by cached) '/docs/public' hash)
    =.  new-cache  (~(put by new-cache) '/docs/public/' hash)
    :_  this(cached new-cache)
    (weld cache-cards (response-cards:hc id status.file mime.file data.file))
  ::
  ++  go-to-settings
    |=  id=@ta
    ^-  (quip card _this)
    =/  file=cache-file  (~(got by static-pages:hc) '/docs/settings')
    =/  hash=@uv  (mug file)
    =/  cache-cards=(list card)
      :~  (~(arvo pass:io /cache) %e %set-response '/docs/settings' `(cache-entry:hc file))
          (~(arvo pass:io /cache) %e %set-response '/docs/settings/' `(cache-entry:hc file))
      ==
    =/  new-cache=(map @t @uv)  (~(put by cached) '/docs/settings' hash)
    =.  new-cache  (~(put by new-cache) '/docs/settings/' hash)
    :_  this(cached new-cache)
    (weld cache-cards (response-cards:hc id status.file mime.file data.file))
  ::
  ++  settings-redirect
    |=  [id=@ta result=?(%appearance %error %publication)]
    ^-  (list card)
    =/  location=@t
      ?+  result  '/docs/settings#settings-error'
        %appearance   '/docs/settings#appearance-saved'
        %publication  '/docs/settings#publication-saved'
      ==
    (give-response id [303 ['Location' location] ~] ~)
  ::
  ++  go-to-static
    |=  [id=@ta pa=path]
    ^-  (quip card _this)
    =/  url=@t  (crip (spud [%docs %assets pa]))
    =/  file=(unit cache-file)  (~(get by static-pages:hc) url)
    ?~  file  (on-poke:def [mark vase])
    =/  cache-card=card
      (~(arvo pass:io /cache) %e %set-response url `(cache-entry:hc u.file))
    :_  this(cached (~(put by cached) url (mug u.file)))
    [cache-card (response-cards:hc id status.u.file mime.u.file data.u.file)]
  ::
  ++  go-to-page
    |=  [id=@ta dsk=desk pa=path]
    ^-  (quip card _this)
    =/  url=@t  (crip (spud [%docs %d dsk pa]))
    =/  file=cache-file  (render-doc:hc dsk pa)
    =/  cache-card=card
      (~(arvo pass:io /cache) %e %set-response url `(cache-entry:hc file))
    :_  this(cached (~(put by cached) url (mug file)))
    [cache-card (response-cards:hc id status.file mime.file data.file)]
  ::
  ++  give-response
    |=  [id=@ta hed=response-header:http dat=(unit octs)]
    ^-  (list card)
    :~  [%give %fact ~[/http-response/[id]] %http-response-header !>(hed)]
        [%give %fact ~[/http-response/[id]] %http-response-data !>(dat)]
        [%give %kick ~[/http-response/[id]] ~]
    ==
  ::
  ++  require-sign-in
    |=  id=@ta
    ^-  (quip card _this)
    :_  this
    (give-response id [307 ['Location' '/~/login?redirect='] ~] ~)
  ::
  ++  query-value
    |=  [key=@t query=(list [k=@t v=@t])]
    ^-  (unit @t)
    ?~  query  ~
    ?:  =(key k.i.query)  `v.i.query
    $(query t.query)
  ::
  ++  nonempty
    |=  value=(unit @t)
    ^-  (unit @t)
    ?~  value  ~
    ?:  =(u.value '')  ~
    value
  --
++  on-watch
  |=  =path
  ^-  (quip card _this)
  ?>  ?=([%http-response *] path)
  `this
::
++  on-peek
  |=  =path
  ^-  (unit (unit cage))
  (on-peek:def path)
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
      [watch-cards this]
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
        =/  result=refresh-result  (refresh-desk:hc cached desk.wave)
        :_  this(cached cache.result)
        (weld watch-cards cards.result)
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
    =/  result=refresh-result
      %-  refresh-changes:hc
      :*  cached
          dsk
          (~(put in *(set (pair care:clay path))) [car pax])
      ==
    =/  watch-cards=(list card)
      ?:  (wide-change:hc dsk car pax)
        (watch-desk:hc dsk)
      ?.  (~(has in (watch-paths:hc dsk)) [car pax])  ~
      [(watch-path:hc dsk car pax) ~]
    :_  this(cached cache.result)
    (weld watch-cards cards.result)
  ==
::
++  on-agent
  |=  [=wire =sign:agent:gall]
  ^-  (quip card _this)
  ?.  =(/docket wire)  (on-agent:def wire sign)
  ?+    -.sign  (on-agent:def wire sign)
        %watch-ack  [~ this]
        %fact
      ?>  =(%charge-update p.cage.sign)
      =/  update=charge-update:docket
        !<(charge-update:docket q.cage.sign)
      =/  result=refresh-result
        ?-  -.update
          %initial     [~ cached]
          %add-charge  (refresh-desk:hc cached desk.update)
          %del-charge  (refresh-desk:hc cached desk.update)
        ==
      [cards.result this(cached cache.result)]
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
  ++  dark           .^(@t %cx (scrio %docs /app/docs/css/dark/css))
  ++  light          .^(@t %cx (scrio %docs /app/docs/css/light/css))
  ++  dark-syntect   .^(@t %cx (scrio %docs /lib/syntect/syntect-dark/css))
  ++  light-syntect  .^(@t %cx (scrio %docs /lib/syntect/syntect-light/css))
  ++  index          .^(@t %cx (scrio %docs /app/docs/css/index/css))
  ++  page           .^(@t %cx (scrio %docs /app/docs/css/page/css))
  ++  err            .^(@t %cx (scrio %docs /app/docs/css/err/css))
  --
:: select a fixed theme or let the browser choose through its color preference
::
++  theme-css
  |=  [light=@t dark=@t]
  ^-  @t
  ?-  theme
    %light   light
    %dark    dark
    %system
      %-  crip
      ;:  weld
        (trip light)
        "\0a"
        (trip '@media (prefers-color-scheme: dark) {')
        "\0a"
        (trip dark)
        "\0a"
        (trip '}')
        "\0a"
      ==
  ==
:: construct an Eyre cache entry with the file's publication policy
::
++  cache-entry
  |=  file=cache-file
  ^-  cache-entry:eyre
  =/  hed=response-header:http
    :-  status.file
    =/  headers=(list [@t @t])
      :~  ['Content-Type' mime.file]
          ['Content-Length' (crip ((d-co:co 1) p.data.file))]
      ==
    ?:  no-store.file
      [['Cache-Control' 'no-store'] headers]
    headers
  =/  payload=simple-payload:http  [hed `data.file]
  [auth.file %payload payload]
:: send a complete direct HTTP response to one pending Eyre request
::
++  response-cards
  |=  [id=@ta status=@ud mime=@t data=octs]
  ^-  (list card)
  =/  hed=response-header:http
    :-  status
    :~  ['Content-Type' mime]
        ['Content-Length' (crip ((d-co:co 1) p.data))]
    ==
  :~  [%give %fact ~[/http-response/[id]] %http-response-header !>(hed)]
      [%give %fact ~[/http-response/[id]] %http-response-data !>(`data)]
      [%give %kick ~[/http-response/[id]] ~]
  ==
:: render the index and static assets that do not require a thread
::
++  static-pages
  ^-  (map @t cache-file)
  =/  root=octs
    (as-octs:mimes:html (crip (en-xml:html index-redirect)))
  =/  idx=octs
    (as-octs:mimes:html (crip (en-xml:html (index |))))
  =/  pub=octs
    (as-octs:mimes:html (crip (en-xml:html (index &))))
  =/  public-status=@ud  ?:(public-enabled 200 404)
  =/  public-data=octs
    ?:  public-enabled  pub
    (as-octs:mimes:html '<h1>404 Not Found</h1>')
  =/  settings-data=octs
    (as-octs:mimes:html (crip (en-xml:html settings)))
  %-  ~(gas by *(map @t cache-file))
  :~  ['/docs' 200 | | 'text/html' root]
      ['/docs/' 200 | | 'text/html' root]
      ['/docs/private' 200 & | 'text/html' idx]
      ['/docs/private/' 200 & | 'text/html' idx]
      ['/docs/public' public-status | | 'text/html' public-data]
      ['/docs/public/' public-status | | 'text/html' public-data]
      ['/docs/settings' 200 & | 'text/html' settings-data]
      ['/docs/settings/' 200 & | 'text/html' settings-data]
      ['/docs/auth-check' 200 & & 'text/plain' *octs]
      ['/docs/assets/navigation.js' 200 | | 'text/javascript' (as-octs:mimes:html .^(@t %cx (scrio %docs /app/docs/navigation/js)))]
      ['/docs/assets/style/var.css' 200 | | 'text/css' (as-octs:mimes:html (theme-css light:css dark:css))]
      ['/docs/assets/style/syntect.css' 200 | | 'text/css' (as-octs:mimes:html (theme-css light-syntect:css dark-syntect:css))]
      ['/docs/assets/style/index.css' 200 | | 'text/css' (as-octs:mimes:html index:css)]
      ['/docs/assets/style/page.css' 200 | | 'text/css' (as-octs:mimes:html page:css)]
      ['/docs/assets/style/err.css' 200 | | 'text/css' (as-octs:mimes:html err:css)]
      ['/docs/assets/font/source-sans-3-upright.woff2' 200 | | 'font/woff2' .^(octs %cx (scrio %docs /app/docs/fonts/source-sans-3-upright/woff2))]
      ['/docs/assets/font/source-sans-3-italic.woff2' 200 | | 'font/woff2' .^(octs %cx (scrio %docs /app/docs/fonts/source-sans-3-italic/woff2))]
      ['/docs/assets/font/sourcecodepro-regular.woff2' 200 | | 'font/woff2' .^(octs %cx (scrio %docs /app/docs/fonts/sourcecodepro-regular/woff2))]
      ['/docs/assets/font/sourcecodepro-semibold.woff2' 200 | | 'font/woff2' .^(octs %cx (scrio %docs /app/docs/fonts/sourcecodepro-semibold/woff2))]
  ==
:: enumerate the indexed pages belonging to one live desk
::
++  desk-targets
  |=  dsk=desk
  ^-  (list path)
  ?.  (~(has by desk-map) dsk)  ~
  =/  utoc=(unit [? =toc])  (read-toc dsk)
  ?~  utoc  ~
  %+  murn  toc.u.utoc
  |=  =ent
  ?.  ?=(%fil -.ent)  ~
  ?>  ?=(^ pa.ent)
  `(flop t.pa.ent)
:: enumerate every currently indexed document
::
++  doc-targets
  ^-  (list [desk path])
  %-  zing
  %+  turn  ~(tap by desk-map)
  |=  [dsk=desk *]
  (turn (desk-targets dsk) |=(pa=path [dsk pa]))
:: synchronously render one document into an Eyre cache file
::
++  render-doc
  |=  [dsk=desk pa=path]
  ^-  cache-file
  (render-page dsk (make-doc dsk pa))
:: render a previously constructed document page into a cache response
::
++  render-page
  |=  [dsk=desk page=manx]
  ^-  cache-file
  =.  page  (highlight:renderer page)
  =/  auth=?
    ?:  public-enabled  !(~(has in public) dsk)
    &
  :*  200
      auth
      |
      'text/html'
      (as-octs:mimes:html (crip (en-xml:html page)))
  ==
:: read Eyre's private response cache so publication changes can reuse payloads
::
++  current-eyre-cache
  ^-  eyre-cache
  .^(eyre-cache %e /(scot %p our.bowl)/cache/(scot %da now.bowl))
:: reuse a rendered document while replacing only its authentication policy
::
++  reuse-doc
  |=  [existing=eyre-cache dsk=desk url=@t]
  ^-  (unit cache-file)
  =/  found=(unit [aeon=@ud val=(unit cache-entry:eyre)])
    (~(get by existing) url)
  ?~  found  ~
  ?~  val.u.found  ~
  =/  entry=cache-entry:eyre  u.val.u.found
  =/  data=(unit octs)  data.simple-payload.body.entry
  ?~  data  ~
  =/  auth=?
    ?:  public-enabled  !(~(has in public) dsk)
    &
  =/  file=cache-file
    :*  200
        auth
        |
        'text/html'
        u.data
    ==
  `file
:: reuse the rendered responses for a set of documents
::
++  reuse-docs
  |=  [existing=eyre-cache dsk=desk urls=(list @t)]
  ^-  (map @t cache-file)
  %+  roll  urls
  |=  [url=@t pages=(map @t cache-file)]
  =/  file=(unit cache-file)  (reuse-doc existing dsk url)
  ?~  file  pages
  (~(put by pages) url u.file)
:: choose the safe default library destination embedded in a document page
::
++  library-url
  |=  dsk=desk
  ^-  tape
  %+  weld  "/docs/public#"
  (trip dsk)
:: eagerly cache indexes and assets; all documents populate on demand
::
++  refresh-cache
  |=  old=(map @t @uv)
  ^-  refresh-result
  =/  all-targets=(list [desk path])  doc-targets
  =/  pages=(map @t cache-file)  static-pages
  =/  legacy=(set @t)
    %-  silt
    %+  turn  all-targets
    |=  [dsk=desk pa=path]
    (crip (spud [%docs dsk pa]))
  =/  documents=(set @t)
    %-  silt
    %+  turn  all-targets
    |=  [dsk=desk pa=path]
    (crip (spud [%docs %d dsk pa]))
  =/  remove=(set @t)
    (~(uni in ~(key by old)) (~(uni in legacy) documents))
  (refresh-pages old pages remove)
:: replace the theme-dependent stylesheets and settings page after a mode change
::
++  refresh-theme
  |=  old=(map @t @uv)
  ^-  [(list card) (map @t @uv)]
  =/  pages=(map @t cache-file)
    =/  settings-file=cache-file
      [200 & | 'text/html' (as-octs:mimes:html (crip (en-xml:html settings)))]
    %-  ~(gas by *(map @t cache-file))
    :~  ['/docs/settings' settings-file]
        ['/docs/settings/' settings-file]
        ['/docs/assets/style/var.css' 200 | | 'text/css' (as-octs:mimes:html (theme-css light:css dark:css))]
        ['/docs/assets/style/syntect.css' 200 | | 'text/css' (as-octs:mimes:html (theme-css light-syntect:css dark-syntect:css))]
    ==
  (refresh-pages old pages ~)
:: update indexes, settings, and the auth flags of cached documents
::
++  refresh-publication
  |=  [old=(map @t @uv) changed=(set desk)]
  ^-  refresh-result
  =/  idx=cache-file
    [200 & | 'text/html' (as-octs:mimes:html (crip (en-xml:html (index |))))]
  =/  pub-data=octs
    ?:  public-enabled
      (as-octs:mimes:html (crip (en-xml:html (index &))))
    (as-octs:mimes:html '<h1>404 Not Found</h1>')
  =/  pub=cache-file
    [?:(public-enabled 200 404) | | 'text/html' pub-data]
  =/  settings-file=cache-file
    [200 & | 'text/html' (as-octs:mimes:html (crip (en-xml:html settings)))]
  =/  pages=(map @t cache-file)
    %-  ~(gas by *(map @t cache-file))
    :~  ['/docs/private' idx]
        ['/docs/private/' idx]
        ['/docs/public' pub]
        ['/docs/public/' pub]
        ['/docs/settings' settings-file]
        ['/docs/settings/' settings-file]
    ==
  =/  existing=eyre-cache  current-eyre-cache
  =/  desks=(list desk)  ~(tap in changed)
  =/  remove=(set @t)  ~
  |-
  ?~  desks  (refresh-pages old pages remove)
  =/  dsk=desk  i.desks
  =/  urls=(set @t)  (desk-urls old dsk)
  =/  reused=(map @t cache-file)
    (reuse-docs existing dsk ~(tap in urls))
  %=  $
    desks   t.desks
    pages   (~(uni by reused) pages)
    remove  (~(uni in urls) remove)
  ==
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
:: find every cached document URL belonging to one desk
::
++  desk-urls
  |=  [old=(map @t @uv) dsk=desk]
  ^-  (set @t)
  =/  prefix=tape  (weld "/docs/d/" (weld (trip dsk) "/"))
  %-  silt
  %+  murn  ~(tap in ~(key by old))
  |=  url=@t
  =/  txt=tape  (trip url)
  ?.  ?&  (lte (lent prefix) (lent txt))
          =(prefix (scag (lent prefix) txt))
      ==
    ~
  `url
:: rebuild indexes and invalidate every cached page belonging to one desk
::
++  refresh-desk
  |=  [old=(map @t @uv) dsk=desk]
  ^-  refresh-result
  =/  idx=cache-file
    [200 & | 'text/html' (as-octs:mimes:html (crip (en-xml:html (index |))))]
  =/  pub-data=octs
    ?:  public-enabled
      (as-octs:mimes:html (crip (en-xml:html (index &))))
    (as-octs:mimes:html '<h1>404 Not Found</h1>')
  =/  pub=cache-file
    [?:(public-enabled 200 404) | | 'text/html' pub-data]
  =/  settings-file=cache-file
    [200 & | 'text/html' (as-octs:mimes:html (crip (en-xml:html settings)))]
  =/  pages=(map @t cache-file)
    %-  ~(gas by *(map @t cache-file))
    :~  ['/docs/private' idx]
        ['/docs/private/' idx]
        ['/docs/public' pub]
        ['/docs/public/' pub]
        ['/docs/settings' settings-file]
        ['/docs/settings/' settings-file]
    ==
  (refresh-pages old pages (desk-urls old dsk))
:: invalidate one indexed document page
::
++  refresh-doc
  |=  [old=(map @t @uv) dsk=desk pa=path]
  ^-  refresh-result
  =/  url=@t  (crip (spud [%docs %d dsk pa]))
  =/  remove=(set @t)  (~(put in *(set @t)) url)
  (refresh-pages old *(map @t cache-file) remove)
:: classify exact %mult changes and apply only the necessary rebuilds
::
++  refresh-changes
  |=  $:  old=(map @t @uv)
          src=desk
          changes=(set (pair care:clay path))
      ==
  ^-  refresh-result
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
  =/  wide-result=refresh-result
    =/  desks=(list desk)  ~(tap in wide)
    =/  cards=(list card)  ~
    =/  cache=(map @t @uv)  old
    |-
    ?~  desks  [cards cache]
    =/  result=refresh-result
      (refresh-desk cache i.desks)
    $(desks t.desks, cards (weld cards cards.result), cache cache.result)
  =/  files=(list [desk path])  ~(tap in docs)
  =/  cards=(list card)  cards.wide-result
  =/  cache=(map @t @uv)  cache.wide-result
  |-
  ?~  files  [cards cache]
  =/  [dsk=desk pa=path]  i.files
  ?:  (~(has in wide) dsk)  $(files t.files)
  =/  result=refresh-result
    (refresh-doc cache dsk pa)
  $(files t.files, cards (weld cards cards.result), cache cache.result)
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
    (header dsk ttl-doc (dropdown dsk ttl-dsk toc.u.utoc))
    (navbar toc.p.scrl)
    content.p.scrl
    (footer (prev-next toc.u.utoc dsk pa))
  ==
:: redirect the shared index route using the authenticated cache probe
::
++  index-redirect
  ^-  manx
  ;html
    ;head
      ;title: Docs
      ;meta(charset "utf-8");
      ;meta(name "viewport", content "width=device-width, initial-scale=1");
      ;link(rel "preload", href "/docs/assets/font/source-sans-3-upright.woff2", as "font", type "font/woff2", crossorigin "anonymous");
      ;link(rel "stylesheet", href "/docs/assets/style/var.css");
      ;link(rel "stylesheet", href "/docs/assets/style/index.css");
      ;script(src "/docs/assets/navigation.js");
    ==
    ;body.redirect-page
      ;main.redirect-main
        ;div.redirect-status(role "status", aria-live "polite")
          ;span.redirect-spinner(aria-hidden "true");
          ;div
            ;p.eyebrow: Docs
            ;h1: Opening library
            ;p: Checking which documentation is available to you…
          ==
        ==
        ;noscript
          ;p.redirect-fallback
            ;a(href "/docs/public"): Continue to the public library
          ==
        ==
      ==
    ==
  ==
:: render whole index page
::
++  index
  |=  public-only=?
  ^-  manx
  =/  title=tape
    ?:  public-only
      ?~(public-title "Documentation" (trip u.public-title))
    "Documentation"
  =/  subtitle=tape
    ?:  public-only
      ?~  public-subtitle
        "Browse the guides, references, and manuals published on this ship."
      (trip u.public-subtitle)
    "Browse the guides, references, and manuals published by desks on this ship."
  ;html
    ;head
      ;title: {title}
      ;meta(charset "utf-8");
      ;meta(name "viewport", content "width=device-width, initial-scale=1");
      ;link(rel "preload", href "/docs/assets/font/source-sans-3-upright.woff2", as "font", type "font/woff2", crossorigin "anonymous");
      ;link(rel "stylesheet", href "/docs/assets/style/var.css");
      ;link(rel "stylesheet", href "/docs/assets/style/index.css");
    ==
    ;body
      ;div.app-shell
        ;header.site-header
          ;a.brand(href ?:(public-only "/docs/public" "/docs/private"))
            ;span.brand-mark: D
            ;span: Docs
          ==
          ;+  ?:  public-only
                ;/("")
              ;a.settings-link(href "/docs/settings"): Settings
        ==
        ;main.index-main
          ;div.index-intro
            ;p.eyebrow: Library
            ;h1: {title}
            ;p: {subtitle}
          ==
          ;div.library-grid
            ;*  (make-index public-only)
          ==
        ==
      ==
    ==
  ==
:: render the appearance settings page
::
++  settings
  ^-  manx
  ;html
    ;head
      ;title: Docs Settings
      ;meta(charset "utf-8");
      ;meta(name "viewport", content "width=device-width, initial-scale=1");
      ;link(rel "preload", href "/docs/assets/font/source-sans-3-upright.woff2", as "font", type "font/woff2", crossorigin "anonymous");
      ;link(rel "stylesheet", href "/docs/assets/style/var.css");
      ;link(rel "stylesheet", href "/docs/assets/style/index.css");
    ==
    ;body
      ;div.app-shell
        ;header.site-header
          ;a.brand(href "/docs/private")
            ;span.brand-mark: D
            ;span: Docs
          ==
          ;a.settings-link.current(href "/docs/settings", aria-current "page"): Settings
        ==
        ;main.settings-main
          ;div.settings-heading
            ;p.eyebrow: Docs
            ;h1: Settings
            ;p: Choose the appearance and configure which documentation is available publicly.
          ==
          ;div.settings-notices(aria-live "polite")
            ;p#appearance-saved.settings-notice.success(role "status"): Appearance saved.
            ;p#publication-saved.settings-notice.success(role "status"): Publication settings saved.
            ;p#settings-error.settings-notice.error(role "alert"): Those settings could not be saved.
          ==
          ;form.settings-form(method "post", action "/docs/settings")
            ;input(type "hidden", name "section", value "appearance");
            ;div.settings-card-header
              ;span.settings-card-glyph: A
              ;div
                ;h2: Appearance
                ;p: Choose how documentation is displayed in this browser.
              ==
            ==
            ;div.settings-card-body
              ;fieldset.theme-options
                ;legend: Color theme
                ;+  (theme-option %system "System" "Follow your browser or operating system setting.")
                ;+  (theme-option %light "Light" "Always use the light color theme.")
                ;+  (theme-option %dark "Dark" "Always use the dark color theme.")
              ==
            ==
            ;div.settings-card-footer
              ;button.save-settings(type "submit"): Save appearance
            ==
          ==
          ;form.settings-form.publication-form(method "post", action "/docs/settings")
            ;input(type "hidden", name "section", value "publication");
            ;div.settings-card-header
              ;span.settings-card-glyph: P
              ;div
                ;h2: Public access
                ;p: Control which documentation can be read without signing in.
              ==
            ==
            ;div.settings-card-body
              ;label.publication-toggle
                ;+  ?:  public-enabled
                      ;input(type "checkbox", name "enabled", value "true", checked "checked");
                    ;input(type "checkbox", name "enabled", value "true");
                ;span.theme-option-copy
                  ;span.theme-option-title: Enable public documentation
                  ;span.theme-option-description: Publish the public library index and the selected desks without requiring sign-in.
                ==
              ==
              ;fieldset.publication-options
                ;legend: Published desks
                ;p.field-help: Select the desks to include whenever public documentation is enabled.
                ;div.publication-list
                  ;*  publication-options
                ==
              ==
              ;div.text-field
                ;label(for "public-title"): Public index title
                ;input(id "public-title", type "text", name "title", value ?~(public-title "" (trip u.public-title)), placeholder "Documentation");
              ==
              ;div.text-field
                ;label(for "public-subtitle"): Public index subtitle
                ;textarea(id "public-subtitle", name "subtitle", rows "3", placeholder "Browse the guides, references, and manuals published on this ship.")
                  ;+  ;/  ?~(public-subtitle "" (trip u.public-subtitle))
                ==
              ==
            ==
            ;div.settings-card-footer
              ;button.save-settings(type "submit"): Save publication settings
            ==
          ==
        ==
      ==
    ==
  ==
:: render one selectable appearance option
::
++  theme-option
  |=  [value=?(%system %light %dark) title=tape description=tape]
  ^-  manx
  ;label.theme-option
    ;+  ?:  =(theme value)
          ;input(type "radio", name "mode", value (trip value), checked "checked");
        ;input(type "radio", name "mode", value (trip value));
    ;span.theme-option-copy
      ;span.theme-option-title: {title}
      ;span.theme-option-description: {description}
    ==
  ==
:: render the live desks with documentation as publication choices
::
++  publication-options
  ^-  marl
  %+  turn
    %+  sort
      %+  skim  ~(tap by desk-map)
      |=  [dsk=desk *]
      ?=(^ (read-toc dsk))
    |=  [[a=desk *] [b=desk *]]
    (aor a b)
  |=  [dsk=desk name=(unit @t)]
  (publication-option dsk ?~(name (trip dsk) (trip u.name)))
:: render one public-desk checkbox
::
++  publication-option
  |=  [dsk=desk name=tape]
  ^-  manx
  ;label.publication-option
    ;+  ?:  (~(has in public) dsk)
          ;input(type "checkbox", name "public", value (trip dsk), checked "checked");
        ;input(type "checkbox", name "public", value (trip dsk));
    ;span: {name}
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
  |=  [dsk=desk nam=tape menu=manx]
  ^-  manx
  ;header.doc-header
    ;div.doc-topbar
      ;a.brand.library-link(href (library-url dsk))
        ;span.brand-mark: D
        ;span: Docs
      ==
      ;div.doc-actions
        ;+  menu
      ==
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
        ;a.library-link(href (library-url dsk)): View in library
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
      ;link(rel "preload", href "/docs/assets/font/source-sans-3-upright.woff2", as "font", type "font/woff2", crossorigin "anonymous");
      ;link(rel "stylesheet", href "/docs/assets/style/var.css");
      ;link(rel "stylesheet", href "/docs/assets/style/page.css");
      ;link(rel "stylesheet", href "/docs/assets/style/syntect.css");
      ;script(src "/docs/assets/navigation.js", defer "defer");
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
      ;link(rel "preload", href "/docs/assets/font/source-sans-3-upright.woff2", as "font", type "font/woff2", crossorigin "anonymous");
      ;link(rel "stylesheet", href "/docs/assets/style/var.css");
      ;link(rel "stylesheet", href "/docs/assets/style/err.css");
      ;script(src "/docs/assets/navigation.js", defer "defer");
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
          ;a.library-link(href (library-url dsk)): ← Return to the library
        ==
      ==
    ==
  ==
:: make the list of entries for the index page
::
++  make-index
  |=  public-only=?
  ^-  marl
  %+  turn
    %+  sort
      %+  skim
        %+  turn
          %+  skim  ~(tap by desk-map)
          |=  [dsk=desk *]
          ?:(public-only (~(has in public) dsk) &)
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
    `[[%docs %d dsk (flop p.ent)] (trip q.ent)]
  =/  next=(unit (pair path tape))
    ?:  =(u.ind (dec (lent files)))  ~
    =/  ent=(pair path @t)  (snag +(u.ind) files)
    `[[%docs %d dsk (flop p.ent)] (trip q.ent)]
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
    (strip-attrs p.docu)
  [%.y (make-toc l) p.docu]
--
