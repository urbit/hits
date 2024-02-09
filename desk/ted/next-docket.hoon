/-  spider
/+  strandio
=,  strand=strand:spider
^-  thread:spider
|=  arg=vase
=/  m  (strand ,vase)
^-  form:m
=+  !<([~ =ship =desk] arg)
;<    =bowl:spider
    bind:m
  get-bowl:strandio
;<    =riot:clay
    bind:m
  %:  warp:strandio
      ship
      desk
      ~
      %next
      %q
      [%da (get-time:strandio)]
      /desk/docket-0
  ==
?~  riot
  (pure:m !>('nothing'))
(pure:m q.r.u.riot)
