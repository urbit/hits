/-  *hits
/+  *hits, gossip, default-agent
/$  grab-hit  %noun  %hit
::
|%
::
::  hit: message sent between ships on each app (un)install
+$  hit
  $:  =src        ::  source of this message
      =time       ::  when this message was generated
      =app        ::  app's publisher and name
      =kelvin     ::  app's kelvin compatibility
      =installed  ::  installed or uninstalled?
  ==
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
      ::  XX fill in value type for dockets
      dockets=(map app *)
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
  ~&  >>  "hits: initialising state"
  ^-  (quip card _this)
  :_  this
  :~  :*  %pass
          /timers
          %arvo
          %b
          %wait
          now.bowl
      ==
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
  ?+  path
    (on-watch:def path)
  ::
      [%hits ~]
    ::
    ::  frontend listens to our ship for new hits;
    ::  will update the chart live on the user device
    `this
  ::
      [%~.~ %gossip %source ~]
    ::
    ::  neighbours listen for new hits from us
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
  ?+  wire
    (on-agent:def wire sign)
  ::
      [%~.~ %gossip %gossip ~]
    ?+  -.sign
      ~|([%unexpected-gossip-sign -.sign] !!)
    ::
        %fact
      =*  mark  p.cage.sign
      =*  vase  q.cage.sign
      ?.  =(%hit mark)
        ~&  :*  dap.bowl
                %unexpected-mark-fact
                mark
                wire=wire
            ==
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
        ::  add app info to state on install
        ::  XX send installed app info to frontend
        ::  XX refuse to show app in frontend if there's no docket info
        ~&  >>  "requesting data for /docket/init/(scot %p ship.app.hit)/(scot %tas desk.app.hit)"
        :-  :~  :*  %pass
                    /docket/init/(scot %p ship.app.hit)/(scot %tas desk.app.hit)
                    %arvo
                    %c
                    %warp
                    ship.app.hit
                    desk.app.hit
                    ~
                    %sing
                    %x
                    [%da now.bowl]
                    /desk/docket-0
                ==
                :*  %pass
                    /docket/update/(scot %p ship.app.hit)/(scot %tas desk.app.hit)
                    %arvo
                    %c
                    %warp
                    ship.app.hit
                    desk.app.hit
                    ~
                    %next
                    %x
                    [%da now.bowl]
                    /desk/docket-0
                ==
            ==
        %=  this
          scores    %-  ~(put by scores)
                    :-  app.hit
                    +(app-score)
          versions  %-  ~(put by versions)
                    :-  app.hit
                    kelvin.hit
          installs  %-  ~(put by installs)
                    :-  app.hit
                    %+  scag
                      date-limit
                    %+  sort
                      :-  time.hit
                      %-  ~(gut by installs)
                      :-  app.hit
                      ~[now.bowl]
                    |=  [a=time b=time]
                    ^-  ?
                    (gth a b)
        ==
      ::  update app info on uninstall
      ::  XX send info to frontend
      ::  XX update %hit mark to include json
      :-  :~  :*  %pass
                  ~
                  %arvo
                  %c
                  %warp
                  ship.app.hit
                  desk.app.hit
                  ~
              ==
          ==
      %=  this
        scores   %-  ~(put by scores)
                 :-  app.hit
                 (dec (max app-score 1))
        dockets  (~(del by dockets) app.hit)
        ::
        ::  uninstalled apps are penalised by snipping the head off
        ::  from the sorted list of their install datetimes; this
        ::  should quickly move them down the 'trending' feed
        ::
        ::  XX reconsider this
        installs  ?.  =(1 (lent (~(gut by installs) [app.hit ~[now.bowl]])))
                    ::  if app has >1 installs,
                    ::  remove the most recent
                    %-  ~(put by installs)
                    :-  app.hit
                    (tail (sort (~(got by installs) app.hit) gth))
                  ::  if not, check app exists
                  ?~  (~(get by installs) app.hit)
                    ::  if app doesn't exist,
                    ::  return installs
                    installs
                  ::  if app does exist and has
                  ::  exactly 1 install, remove app
                  (~(del by installs) app.hit)
      ==
    == ::  end of sign branches
  == ::  end of wire branches
::
++  on-arvo
  |=  [=(pole knot) =sign-arvo]
  ^-  (quip card _this)
  ?+  pole
    (on-arvo:def `wire`pole sign-arvo)
  ::
      [%timers ~]
      ~&  >  "/timers"
      `this
    ::  ?+  sign-arvo
    ::    ~&  >  "hits: default response on /timers wire to {<sign-arvo>}"
    ::    (on-arvo:def `wire`pole sign-arvo)
    ::  ::
    ::      [%behn %wake *]
    ::    ~&  >  "hits: got sign-arvo /behn/wake, responding..."
    ::    ::
    ::    ::  check our locally-installed
    ::    ::  apps every five minutes
    ::    ::
    ::    =/  desks
    ::      %-  malt
    ::      %+  skip
    ::        %~  tap  by
    ::        .^  rock:tire:clay
    ::            %cx
    ::            /(scot %p our.bowl)
    ::            /(scot %da now.bowl)
    ::            /tire
    ::        ==
    ::      |=  [=desk [@tas (set [@tas @ud])]]
    ::      ^-  ?
    ::      ?|  =(desk %hits)
    ::          =(desk %kids)
    ::          =(desk %landscape)
    ::      ==
    ::    ~&  >  "hits: desks {<desks>}"
    ::    ::
    ::    =/  sources
    ::      %-  malt
    ::      %+  skip
    ::        %~  tap  by
    ::        .^  (map desk [ship desk])
    ::            %gx
    ::            /(scot %p our.bowl)
    ::            /hood
    ::            /(scot %da now.bowl)
    ::            /kiln
    ::            /sources
    ::            /noun
    ::        ==
    ::      |=  [=desk [ship desk]]
    ::      ^-  ?
    ::      ?|  =(desk %hits)
    ::          =(desk %landscape)
    ::      ==
    ::    ~&  >  "hits: sources {<sources>}"
    ::    ::
    ::    =/  new-local=_local
    ::      %+  roll
    ::        ~(tap by desks)
    ::      |=  [[=desk [state=?(%dead %live %held) *]] result=(set app)]
    ::      ^+  result
    ::      =/  source
    ::        (~(get by sources) desk)
    ::      ?:  =(state %live)
    ::        ?~  source
    ::          result
    ::        (~(put in result) u.source)
    ::      ::  remove outdated app from local state
    ::      ?.  =(state %held)
    ::        result
    ::      ?~  source
    ::        result
    ::      (~(del in result) u.source)
    ::    ~&  >  "hits: new-local: {<new-local>}"
    ::    ::
    ::    ::  both empty if there's no difference
    ::    =/  added    (~(dif in new-local) local)
    ::    ~&  >  "hits: added {<added>}"
    ::    =/  removed  (~(dif in local) new-local)
    ::    ~&  >  "hits: removed {<removed>}"
    ::    ::
    ::    :_  this(local new-local)
    ::    ::
    ::    ::  notify via gossip about stuff
    ::    ::  we've (un)installed recently
    ::    ~&  >>  "hits: woken up by behn"
    ::    :-  :*  %pass
    ::            /timers
    ::            %arvo
    ::            %b
    ::            %wait
    ::            ::  XX move back to 5m
    ::            (add now.bowl ~s10)
    ::        ==
    ::    %+  weld
    ::      ::  apps we've added
    ::      %+  turn
    ::        ~(tap in added)
    ::      |=  [=ship =desk]
    ::      ^-  card
    ::      %+  invent:gossip
    ::        %hit
    ::      !>  ^-  hit
    ::      :*  our.bowl
    ::          now.bowl
    ::          [ship desk]
    ::          (scry-kelvin our.bowl desk now.bowl)
    ::          %.y
    ::      ==
    ::    ::  apps we've removed
    ::    %+  turn
    ::      ~(tap in removed)
    ::    |=  [=ship =desk]
    ::    ^-  card
    ::    %+  invent:gossip
    ::      %hit
    ::    !>  ^-  hit
    ::    :*  our.bowl
    ::        now.bowl
    ::        [ship desk]
    ::        (scry-kelvin our.bowl desk now.bowl)
    ::        %.n
    ::    ==
    ::  ==  ::  end of sign-arvo branches
  ::
      [%docket %init =ship =desk ~]
    ::  ~&  >>  "hits: received initial info about {<ship>}'s' {<desk>}"
    ~&  >  "/docket/init/{<ship>}/{<desk>}"
    `this
    ::  ?+    sign-arvo
    ::      ~&  >  "/docket/init/{<ship>}/{<desk>}"
    ::      (on-arvo:def `wire`pole sign-arvo)
    ::  ::
    ::      [%clay %writ *]
    ::      `this
    ::  ::    =/  =riot:clay  p.sign-arvo
    ::  ::    ?~  riot
    ::  ::      ((slog (crip "hits: failed to read docket file from {<ship>}'s {<desk>}") ~) `this)
    ::  ::    ::  XX send new docket info to frontend
    ::  ::    :-  ~
    ::  ::    ~&  >>  "riot: {<riot>}"
    ::  ::    ~&  >>  "u.riot:  {<u.riot>}"
    ::  ::    ~&  >>  "r.u.riot {<r.u.riot>}"
    ::  ::    ~&  >>  "q.r.u.riot: {<q.r.u.riot>}"
    ::  ::    ::  XX fix
    ::  ::    this
    ::  ::    ::  %=  this
    ::  ::    ::     dockets  (~(put by dockets) [[ship desk] q.r.u.riot])
    ::  ::    ::  ==
    ::  ==
  ::
      [%docket %update =ship =desk ~]
    ::  ~&  >>  "hits: received updated docket info about {<ship>}'s {<desk>}"
    ~&  >  "/docket/update/{<ship>}/{<desk>}"
    `this
    ::  ?+    sign-arvo
    ::      (on-arvo:def `wire`pole sign-arvo)
    ::  ::
    ::      [%clay %writ *]
    ::      `this
    ::    ::  =/  =riot:clay  p.sign-arvo
    ::    ::  ?~  riot
    ::    ::    ((slog (crip "hits: failed to read docket file from {<ship>}'s {<desk>}") ~) `this)
    ::    ::  ::  XX send new docket info to frontend
    ::    ::  :-  ~
    ::    ::  ::  XX fix
    ::    ::  this
    ::    ::  ::  %=  this
    ::    ::  ::     dockets  (~(put by dockets) [[ship desk] q.r.u.riot])
    ::    ::  ::  ==
    ::  ==
  ==  ::  end of wire branches
::
++  on-leave  on-leave:def
++  on-peek
  |=  =path
  ^-  (unit (unit cage))
  ?+  path
    (on-peek:def path)
  ::
      [%x %scores ~]
    ::
    ::  scry top-scoring <chart-limit> apps
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
            /(scot %p our.bowl)
            /(scot %da now.bowl)
            /tire
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
