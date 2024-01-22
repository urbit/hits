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
  ::  - ordering map when a new hit comes in will
  ::    save us doing it when user scries upon opening the app
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
    ::
    ::  XX don't add this app to our state if it's %landscape
    [%~.~ %gossip %gossip ~]
      ?+  -.sign  ~|([%unexpected-gossip-sign -.sign] !!)
        %fact
          =*  mark  p.cage.sign
          =*  vase  q.cage.sign
          ?.  =(%hit mark)
            ~&  [dap.bowl %unexpected-mark-fact mark wire=wire]
            `this
          =+  !<(=hit vase)
          ::  XX rename app-score? now has (list time) in the tail
          =/  app-score
            (~(gut by scores) app.hit [0 [now.bowl]~])
          ?:  installed.hit
            :-  ~
            %=  this
              scores
              %-  ~(put by scores)
              :-  app.hit
              :-  +((head app-score))
              ::
              ::  append new install datetime to list
              :-  now.bowl
              (tail (~(gut by scores) app.hit [0 [~]]))
            ==
          :-  ~
          %=  this
            scores
            %-  ~(put by scores)
            :-  app.hit
            :-  (dec (max (head app-score) 1))
            ::
            ::  uninstalled apps are penalised by snipping the head off
            ::  from the list of their install datetimes; this should
            ::  quickly remove them from the 'trending' feed
            ?:  =(1 (lent (tail app-score)))
              (tail app-score)
            (tail (tail app-score))
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
          =/  desks    .^(rock:tire:clay %cx /(scot %p our.bowl)//(scot %da now.bowl)/tire)
          =/  sources  .^((map desk [ship desk]) %gx /(scot %p our.bowl)/hood/(scot %da now.bowl)/kiln/sources/noun)
          ::
          =/  new-local=_local
            %+  roll
              ~(tap by desks)
            |=  [[=desk [state=?(%dead %live %held) *]] local=(set (pair ship desk))]
            ^+  local
            ?:  =(state %live)
              ?~  res=(~(get by sources) desk)
                local
              (~(put in local) u.res)
            local
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
    [%x %scores ~]
    ::  XX  before sending an app to frontend, check the app is compatible with our kelvin version
    ::        if not, don't send it to fe but keep it in app state
    ``[%scores !>((scag chart-limit ~(tap by scores)))]
  ==  ::  end of path branches
::
++  on-fail   on-fail:def
--
