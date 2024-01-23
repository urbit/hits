/+  gossip, default-agent
/$  grab-hit  %noun  %hit
::
|%
+$  score  @ud
+$  src    ship
+$  app    [=ship =desk]
+$  hit    [=src =time =app installed=?]
::
+$  state-0
  ::  XX test to see if frontend performance is okay
  ::     with $scores as a map; could change it to
  ::     an ordered list
  ::  - prepend the @da from the latest hit to the list;
  ::    cut off the end of the new list after ~25 @das.
  ::    could use this for one of several "trending" algorithms.
  $:  scores=(map app (pair score (list time)))
      local=(set app)
  ==
::  XX remove $+
+$  card  $+(card card:agent:gall)
::
::  max. number of apps
::  to list on frontend
++  chart-limit  40
::
::  max. number of installs
::  to track for each app
++  date-limit  25
--
::
=|  state-0
=*  state  -
::
%-  %+  agent:gossip
      [2 %anybody %anybody |]
    %+  ~(put by *(map mark $-(* vase)))
      %hit
    |=(n=* !>((grab-hit n)))
^-  agent:gall
::
|_  =bowl:gall
+*  this  .
    def   ~(. (default-agent this %|) bowl)
::
++  on-init
  ::  XX check we have %pals and some ships in there
  ::       - if so, remote scry their %hits states
  ::       - combine it all into our local state
  ::
  ::  immediately populate our local state and gossip around
  ^-  (quip card _this)
  :_  this
  :~  [%pass /timers %arvo %b %wait now.bowl]
  ==
::
++  on-save
  !>(state)
::
++  on-load  on-load:def
  ::  XX manage behn timers for refreshing state
::
++  on-poke  on-poke:def
++  on-watch
  |=  =path
  ^-  (quip card _this)
  ?+  path  (on-watch:def path)
    ::
    ::  frontend listens to our ship for new hits;
    ::  will update the chart live on the user device
    [%hits ~]
      `this
    ::
    ::  neighbours listen for new hits from us
    [%~.~ %gossip %source ~]
      :_  this
      %+  turn
        ~(tap in local)
      |=  [=ship =desk]
      ^-  card
      :*  %give
          %fact
          ~
          :-  %hit
          !>  ^-  hit
          [our.bowl now.bowl [ship desk] %.y]
      ==
  ==  ::  end of path branches
::
++  on-agent
  |=  [=wire =sign:agent:gall]
  ^-  (quip card _this)
  ?+  wire  (on-agent:def wire sign)
    [%~.~ %gossip %gossip ~]
      ?+  -.sign  ~|([%unexpected-gossip-sign -.sign] !!)
        %fact
          =*  mark  p.cage.sign
          =*  vase  q.cage.sign
          ?.  =(%hit mark)
            ~&  [dap.bowl %unexpected-mark-fact mark wire=wire]
            `this
          =+  !<(=hit vase)
          =/  app-status
            (~(gut by scores) app.hit [0 [now.bowl]~])
          ?:  installed.hit
            ::
            ::  XX should we |hi new app devs who aren't
            ::     already discovered peers?
            ::     - maybe even scry what apps they're
            ::       publishing now if it helps performance
            ::       when user clicks through to Landscape
            ::     - does Landscape cache that list of published
            ::       apps? could it be outdated if app dev unpublishes
            ::       an app?
            ::
            ::  increment app score
            :-  ~
            %=  this
              scores
              %-  ~(put by scores)
              :-  app.hit
              :-  +((head app-status))
              ::
              ::  append new install datetime to list
              :-  now.bowl
              (tail (~(gut by scores) app.hit [0 [~]]))
            ==
          ::  decrement app score
          :-  ~
          %=  this
            scores
            %-  ~(put by scores)
            :-  app.hit
            :-  (dec (max (head app-status) 1))
            ::
            ::  uninstalled apps are penalised by snipping the head off
            ::  from the list of their install datetimes; this should
            ::  quickly remove them from the 'trending' feed
            ?:  =(1 (lent (tail app-status)))
              (tail app-status)
            (tail (tail app-status))
          ==
      ==  ::  end of sign branches
  == ::  end of wire branches
::
++  on-arvo
  |=  [=wire =sign-arvo]
  ^-  (quip card _this)
  ?+  wire  (on-arvo:def wire sign-arvo)
    [%timers ~]
      ?+  sign-arvo  (on-arvo:def wire sign-arvo)
        [%behn %wake ~]
          ::
          ::  filter desks on our ship
          =/  desks
            %-  malt
            %+  skip
              %~  tap  by
              .^(rock:tire:clay %cx /(scot %p our.bowl)//(scot %da now.bowl)/tire)
            |=  [=desk [@tas (set [@tas @ud])]]
            ^-  ?
            =(desk ?(%kids %landscape))
          ::
          ::  filter apps and sources on our ship
          =/  sources
            %-  malt
            %+  skip
              %~  tap  by
              .^((map desk [ship desk]) %gx /(scot %p our.bowl)/hood/(scot %da now.bowl)/kiln/sources/noun)
            |=  [=desk [ship desk]]
            ^-  ?
            =(desk %landscape)
          ::
          =/  new-local=_local
            %+  roll
              ~(tap by desks)
            |=  [[=desk [state=?(%dead %live %held) *]] local=(set app)]
            ^+  local
            =/  res
              (~(get by sources) desk)
            ?:  =(state %live)
              ?~  res
                local
              (~(put in local) u.res)
            ::  remove outdated / abandoned app from local state
            ?.  =(state %held)
              local
            ?~  res
              local
            (~(del in local) u.res)
          ::
          ::  both empty if there's no difference
          =/  added    (~(dif in new-local) local)
          =/  removed  (~(dif in local) new-local)
          :_  this(local new-local)
          ::  notify via gossip about stuff we've (un)installed recently
          :-  [%pass /timers %arvo %b %wait (add now.bowl ~m5)]
          %+  weld
            ::  apps we've added
            %+  turn
              ~(tap in added)
            |=  [=ship =desk]
            ^-  card
            %+  invent:gossip
              %hit
            !>  ^-  hit
            [our.bowl now.bowl [ship desk] %.y]
          ::  apps we've removed
          %+  turn
            ~(tap in removed)
          |=  [=ship =desk]
          ^-  card
          %+  invent:gossip
            %hit
          !>  ^-  hit
          [our.bowl now.bowl [ship desk] %.n]
      ==
  ==
::
++  on-leave  on-leave:def
++  on-peek
  |=  =path
  ^-  (unit (unit cage))
  ?+  path  (on-peek:def path)
    ::
    ::  scry top-scoring <chart-limit> apps
    [%x %scores ~]
    %-  some
    %-  some
    :-  %scores
    !>  ^-  (list (pair app (pair score (list time))))
    =/  desks
      %-  malt
      %+  skip
        %~  tap  by
        .^(rock:tire:clay %cx /(scot %p our.bowl)//(scot %da now.bowl)/tire)
      |=  [=desk [@tas (set [@tas @ud])]]
      ^-  ?
      =(desk ?(%kids %landscape))
    %+  scag
      chart-limit
    %+  sort
      ::
      ::  prevent outdated desks
      ::  from reaching frontend
      %+  skip
        ~(tap by scores)
      |=  [=app [score (list time)]]
      ^-  ?
      ?~  (~(get by desks) desk.app)
        %.y
      =(%held -:(need (~(get by desks) desk.app)))
    |=  [a=[app [=score (list time)]] b=[app [=score (list time)]]]
    ^-  ?
    (gth score.a score.b)
  ==  ::  end of path branches
::
++  on-fail   on-fail:def
--
