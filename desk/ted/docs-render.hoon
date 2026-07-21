/-  spider, *docs
/+  renderer=docs-highlighter, strandio
=,  strand=strand:spider
::
^-  thread:spider
|=  argument=vase
=/  m  (strand ,vase)
^-  form:m
=/  [~ request=render-request]  !<([~ render-request] argument)
=/  page=manx  (highlight:renderer page.request)
=/  result=render-result
  :*  url.request
      generation.request
      (as-octs:mimes:html (crip (en-xml:html page)))
  ==
(pure:m !>(result))
