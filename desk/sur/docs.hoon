|%
:: toc types
::
+$  toc  (list ent)
+$  ent  [?(%fil %dir) pa=path nam=@t]
+$  raw  [lvl=@ud =nud nam=@t]
+$  nud  $@(dir=@ta [fil=@ta mar=@ta])
:: clue types
::
+$  scroll  [toc=(unit manx) content=manx]
+$  kind  ?(%usr %dev)
+$  doc    [=file title=@t]
+$  file   [name=@ta =mark ~]
+$  usr  (list doc)
+$  dev  (list [agent=@tas docs=(list doc)])
+$  clue  [=usr =dev]
:: asynchronous document rendering
::
+$  render-request
  $:  url=@t
      generation=@ud
      page=manx
  ==
+$  render-result
  $:  url=@t
      generation=@ud
      html=octs
  ==
--
