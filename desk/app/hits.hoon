/+  *hits, gossip, default-agent
/$  grab-hit  %noun  %hit
::
|%
+$  installed  ?
+$  kelvin     @ud
+$  score      @ud
+$  src        ship
+$  app        [=ship =desk]
::
::  hit: message sent between ships on each app (un)install
+$  hit        [=src =time =app =kelvin =installed]
::
+$  state-0
  ::
  ::  XX test to see if frontend performance is okay
  ::     with $scores as a map; could change it to
  ::     an ordered list
  ::
  $:  local=(set app)
      scores=(map app score)
      versions=(map app kelvin)
      installs=(map app (list time))
  ==
+$  card  card:agent:gall
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
          :*  our.bowl
              now.bowl
              [ship desk]
              (scry-kelvin our.bowl desk now.bowl)
              %.y
          ==
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
          =/  app-score
            (~(gut by scores) app.hit 0)
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
            ::  update app info on install
            :-  ~
            %=  this
              scores    (~(put by scores) [app.hit +(app-score)])
              versions  (~(put by versions) [app.hit kelvin.hit])
              installs  (~(put by installs) [app.hit :-(time.hit (~(gut by installs) app.hit ~[now.bowl]))])
            ==
          ::  update app info on uninstall
          :-  ~
          %=  this
            scores  (~(put by scores) [app.hit (dec (max app-score 1))])
            ::
            ::  uninstalled apps are penalised by snipping the head off
            ::  from the list of their install datetimes; this should
            ::  quickly remove them from the 'trending' feed
            installs
            ?.  =(1 (lent (~(gut by installs) app.hit ~[now.bowl])))
              (~(put by installs) [app.hit (tail (~(got by installs) app.hit))])
            ?~  (~(get by installs) app.hit)
              installs
            (~(del by installs) app.hit)
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
              .^  rock:tire:clay
                  %cx
                  /(scot %p our.bowl)//(scot %da now.bowl)/tire
              ==
            |=  [=desk [@tas (set [@tas @ud])]]
            ^-  ?
            ?|  =(desk %kids)
                =(desk %landscape)
            ==
          ::
          ::  filter apps and sources on our ship
          =/  sources
            %-  malt
            %+  skip
              %~  tap  by
              .^  (map desk [ship desk])
                  %gx
                  /(scot %p our.bowl)/hood/(scot %da now.bowl)/kiln/sources/noun
              ==
            |=  [=desk [ship desk]]
            ^-  ?
            =(desk %landscape)
          ::
          =/  new-local=_local
            %+  roll
              ~(tap by desks)
            |=  [[=desk [state=?(%dead %live %held) *]] result=(set app)]
            ^+  result
            =/  source
              (~(get by sources) desk)
            ?:  =(state %live)
              ?~  source
                result
              (~(put in result) u.source)
            ::  remove outdated app from local state
            ?.  =(state %held)
              result
            ?~  source
              result
            (~(del in result) u.source)
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
            :*  our.bowl
                now.bowl
                [ship desk]
                (scry-kelvin our.bowl desk now.bowl)
                %.y
            ==
          ::  apps we've removed
          %+  turn
            ~(tap in removed)
          |=  [=ship =desk]
          ^-  card
          %+  invent:gossip
            %hit
          !>  ^-  hit
          :*  our.bowl
              now.bowl
              [ship desk]
              (scry-kelvin our.bowl desk now.bowl)
              %.n
          ==
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
      !>  ^-  (list (pair app score))
      =/  desks
        %-  malt
        %+  skip
          %~  tap  by
          .^  rock:tire:clay
              %cx
              /(scot %p our.bowl)//(scot %da now.bowl)/tire
          ==
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
        |=  [=app =score]
        ^-  ?
        ?~  (~(get by desks) desk.app)
          %.y
        =(%held -:(need (~(get by desks) desk.app)))
      |=  [a=[app =score] b=[app =score]]
      ^-  ?
      (gth score.a score.b)
  ==  ::  end of path branches
::
++  on-fail   on-fail:def
--
