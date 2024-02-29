/-  *hits
/+  *hits, gossip, default-agent
::  XX get marks in a /mar/hits folder and improve the
::     names; something like %hits-install and %hits-refresh
/$  grab-hit            %noun  %hit
/$  grab-update-docket  %noun  %update-docket
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
  $:  local=(set app)                 ::  our locally-installed apps
      rankings=(list app)             ::  ordered list of most-installed apps
      scores=(map app score)          ::  app scores
      versions=(map app kelvin)       ::  app versions
      installs=(map app (list time))  ::  most recent installs
      dockets=(map app docket-0)      ::  docket info for each app
  ==
+$  card  $+(card card:agent:gall)
::
::  max. number of installs
::  to track for each app
::  XX arguably remove this: cheap to store @das, can
::     let frontend dev decide what algorithm they want
++  date-limit  25
--
::
=|  state-0
=*  state  -
::
::  /lib/gossip.hoon config
%-  %+  agent:gossip
      [2 %anybody %anybody |]
    %-  %~  put  by
      %-  %~  put  by
        *(map mark $-(* vase))
      [%hit |=(n=* !>((grab-hit n)))]
    [%update-docket |=(n=* !>((grab-update-docket n)))]
::
^-  agent:gall
|_  =bowl:gall
+*  this  .
    def   ~(. (default-agent this %|) bowl)
::
++  on-init
  ::
  ::  immediately populate our local state and gossip around
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
++  on-poke  on-poke:def
++  on-watch
  |=  =path
  ^-  (quip card _this)
  ?+  path
    (on-watch:def path)
  ::
      [%ui-updates ~]
    ::
    ::  frontend listens to our ship for new hits;
    ::  will update the chart live on the user device
    ?>  =(our.bowl src.bowl)
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
      ?+  mark
        ~|([%unexepected-mark-fact mark wire] !!)
      ::
          %update-docket
        ~&  >  "hits: got %update-docket message"
        =+  !<(updated-app=app vase)
        :_  this
        :~  :*  %pass
                /docket/read/(scot %p ship.updated-app)/(scot %tas desk.updated-app)
                %arvo
                %k
                %fard
                %base
                %read
                %noun
                !>  ^-  [~ care:clay ship desk case path]
                :*  ~
                    %q
                    ship.updated-app
                    desk.updated-app
                    [%da now.bowl]
                    /desk/docket-0
                ==
            ==
        ==
      ::
          %hit
        =+  !<(=hit vase)
        =/  app-score
          (~(gut by scores) app.hit 0)
        ?:  installed.hit
          =/  new-score
            +(app-score)
          =/  new-version
          ?~  (~(get by versions) app.hit)
            kelvin.hit
          %+  min
            kelvin.hit
          (~(got by versions) app.hit)
          =/  new-installs
            %-  ~(put by installs)
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
          ::  update app info on install, ask for docket
          ::  info from the app's publisher
          :_  %=  this
                scores    (~(put by scores) [app.hit new-score])
                versions  (~(put by versions) [app.hit new-version])
                installs  (~(put by installs) [app.hit (~(got by new-installs) app.hit)])
                rankings  (rank-apps (~(put by scores) [app.hit new-score]))
              ==
          :~  :*  %pass
                  /docket/read/(scot %p ship.app.hit)/(scot %tas desk.app.hit)
                  %arvo
                  %k
                  %fard
                  %base
                  %read
                  %noun
                  !>  ^-  [~ care:clay ship desk case path]
                  :*  ~
                      %q
                      ship.app.hit
                      desk.app.hit
                      [%da now.bowl]
                      /desk/docket-0
                  ==
              ==
              :*  %give
                  %fact
                  ~[/ui-updates]
                  %ui-update
                  !>  ^-  ui-update
                  [%score-updated [app.hit new-score]]
              ==
              :*  %give
                  %fact
                  ~[/ui-updates]
                  %ui-update
                  !>  ^-  ui-update
                  [%installs-updated [app.hit (~(got by new-installs) app.hit)]]
              ==
              :*  %give
                  %fact
                  ~[/ui-updates]
                  %ui-update
                  !>  ^-  ui-update
                  [%version-updated [app.hit new-version]]
              ==
          ==
        ::
        ::  update app info on uninstall
        =/  new-score
          (dec (max app-score 1))
        =/  new-dockets
          ?.  =(1 (lent (~(gut by installs) [app.hit ~[now.bowl]])))
            dockets
          (~(del by dockets) app.hit)
        =/  new-versions
          ?.  =(1 (lent (~(gut by installs) [app.hit ~[now.bowl]])))
            versions
          (~(del by versions) app.hit)
        =/  new-installs
          ::
          ::  uninstalled apps are penalised by snipping the head off
          ::  from the sorted list of their install datetimes; this
          ::  should quickly move them down the 'trending' feed
          ::
          ::  XX could this be better?
          ?.  =(1 (lent (~(gut by installs) [app.hit ~[now.bowl]])))
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
        ::
        :_  %=  this
              dockets   new-dockets
              installs  new-installs
              versions  new-versions
              scores    (~(put by scores) [app.hit new-score])
              rankings  (rank-apps (~(put by scores) [app.hit new-score]))
            ==
        :~  :*  %give
                %fact
                ~[/ui-updates]
                %ui-update
                !>  ^-  ui-update
                [%score-updated [app.hit new-score]]
            ==
            :*  %give
                %fact
                ~[/ui-updates]
                %ui-update
                !>  ^-  ui-update
                [%installs-updated [app.hit (~(got by new-installs) app.hit)]]
            ==
        ==
      ==  ::  end of mark branches
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
    ?+  sign-arvo
      (on-arvo:def `wire`pole sign-arvo)
    ::
        [%behn %wake *]
      ?^  `*`error.sign-arvo
        ((slog (crip "hits: timer failure {<sign-arvo>}") ~) `this)
      ::
      ::  check our locally-installed
      ::  apps every five minutes
      ::
      =/  desks
        %-  malt
        %+  skip
          %~  tap  by
          ::  XX tall-form scry causes an error
          ::  .^  rock:tire:clay
          ::      %cx
          ::      /(scot %p our.bowl)
          ::      /
          ::      /(scot %da now.bowl)
          ::      /tire
          ::  ==
          .^(rock:tire:clay %cx /(scot %p our.bowl)//(scot %da now.bowl)/tire)
        |=  [=desk [@tas (set [@tas @ud])]]
        ^-  ?
        ?|  =(desk %hits)
            =(desk %kids)
            =(desk %landscape)
        ==
      =/  sources
        %-  malt
        %+  skip
          %~  tap  by
          ::  XX tall-form scry causes an error
          ::      .^  (map desk [ship desk])
          ::          %gx
          ::          /(scot %p our.bowl)
          ::          /hood
          ::          /(scot %da now.bowl)
          ::          /kiln
          ::          /sources
          ::          /noun
          ::      ==
          .^((map desk [ship desk]) %gx /(scot %p our.bowl)/hood/(scot %da now.bowl)/kiln/sources/noun)
        |=  [=desk [ship desk]]
        ^-  ?
        ?|  =(desk %hits)
            =(desk %landscape)
        ==
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
      =/  added
        (~(dif in new-local) local)
      =/  removed
        (~(dif in local) new-local)
      ::
      :_  this(local new-local)
      ::
      ::  notify via gossip about stuff
      ::  we've (un)installed recently
      ::  and update our own state
      %+  welp
        ::
        :: cards for our arvo
        :-
        :*  %pass
            /timers
            %arvo
            %b
            %wait
            ::  XX move back to 5m
            (add now.bowl ~m1)
        ==
        %+  turn
          ~(tap in added)
        |=  [=ship =desk]
        ^-  card
        :*  %pass
            /docket/update/(scot %p ship)/(scot %tas desk)
            %arvo
            %c
            %warp
            our.bowl
            desk
            ~
            %next
            %x
            [%da now.bowl]
            /desk/docket-0
        ==
      ::
      ::  cards for our peers
      %+  weld
        ::  gossip apps we've added
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
      ::  gossip apps we've removed
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
  ::
      [%docket %read =ship =desk ~]
    ?+    sign-arvo
        (on-arvo:def `wire`pole sign-arvo)
    ::
        [%khan %arow *]
      ?.  -.p.sign-arvo
        ((slog (crip "hits: failed to read docket file from {<desk.pole>}") ~) `this)
      :-  :~  :*  %give
                  %fact
                  ~[/ui-updates]
                  %ui-update
                  !>  ^-  ui-update
                  :-  %docket-updated
                  :-  [`@p`(slav %p ship.pole) desk.pole]
                  (docket-0 (tail (tail +.p.sign-arvo)))
              ==
          ==
      %=  this
        dockets  %-  %~  put  by
                   dockets
                 :-  [`@p`(slav %p ship.pole) desk.pole]
                 (docket-0 (tail (tail +.p.sign-arvo)))
      ==
    ==
  ::
      [%docket %update =ship =desk ~]
    ~&  >  "/docket/update for {<desk.pole>}"
    ?+    sign-arvo
        (on-arvo:def `wire`pole sign-arvo)
    ::
        [%clay %writ *]
      :_  this
      :~  %+  invent:gossip
            %update-docket
          !>  ^-  app
          [`@p`(slav %p ship.pole) desk.pole]
          :*  %pass
              /docket/read/[ship.pole]/[desk.pole]
              %arvo
              %k
              %fard
              %base
              %read
              %noun
              !>  ^-  [~ care:clay ship desk case path]
              :*  ~
                  %q
                  our.bowl
                  (slav %tas desk.pole)
                  [%da now.bowl]
                  /desk/docket-0
              ==
          ==
      ==
    ==
  ==  ::  end of wire branches
::
++  on-peek
  |=  =path
  ^-  (unit (unit cage))
  ~&  >>  "received scry request at {<path>}"
  ?+  path
    (on-peek:def path)
  ::
      [%x %rankings ~]
    ::
    ::  initial rankings, used to popular frontend state
    ::  .^((list (pair ship desk)) %gx /=hits=/rankings/noun)
    ::  .^(json %gx /=hits=/rankings/json)
    ``[%hits-rankings !>(rankings)]
  ::
  ::  XX reformat paths to be e.g. /score/~sampel/hits?
  ::     more readable in that you know what you're
  ::     looking at faster
  ::
  ::  XX reformat to do !> before conditional logic
      [%x ship desk %score ~]
    ::
    ::  app's score
    ::  .^((unit @ud) %gx /=hits=/~sampel/hits/score/noun)
    ::  .^(json %gx /=hits=/~sampel/hits/score/json)
    =/  =app    [(slav %p i.t.path) i.t.t.path]
    ?~  (~(get by scores) app)
      ``[%hits-score !>(~)]
    ``[%hits-score !>((~(got by scores) app))]
  ::
      [%x ship desk %version ~]
    ::
    ::  app's current %zuse kelvin version
    ::  compatibility (e.g. 412, 411)
    ::  .^((unit @ud) %gx /=hits=/~sampel/hits/version/noun)
    ::  .^(json %gx /=hits=/~sampel/hits/version/json)
    =/  =app  [(slav %p i.t.path) i.t.t.path]
    ?~  (~(get by versions) app)
      ``[%hits-version !>(~)]
    ``[%hits-version !>((~(got by versions) app))]
  ::
      [%x ship desk %docket ~]
    ::
    ::  app's docket info
    ::  .^((unit noun) %gx /=hits=/~sampel/hits/docket/noun)
    ::  .^(json %gx /=hits=/~sampel/hits/docket/json)
    =/  =app  [(slav %p i.t.path) i.t.t.path]
    ?~  (~(get by dockets) app)
      ``[%hits-docket !>(~)]
    ``[%hits-docket !>((~(got by dockets) app))]
  ::
      [%x ship desk %installs @ud ~]
    ::
    ::  dates of app's most recent n installs
    ::  .^((list @da) %gx /=hits=/~sampel/hits/installs/25/noun)
    ::  .^(json %gx /=hits=/~sampel/hits/installs/25/json)
    =*  limit  i.t.t.t.t.path
    =/  =app  [(slav %p i.t.path) i.t.t.path]
    %-  some
    %-  some
    :-  %hits-installs
    !>  ^-  (list time)
    ?~  (~(get by installs) app)
      ~
    %+  scag
      limit
    (~(got by installs) app)
  ==
::
++  on-fail   on-fail:def
++  on-leave  on-leave:def
--
