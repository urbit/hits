/-  *hits
/+  *hits, gossip, default-agent
::  XX get marks in a /mar/hits folder and improve the
::     names; something like %hits-install and %hits-refresh
/$  grab-hit            %noun  %hit
/$  grab-update-docket  %noun  %update-docket
::
|%
+$  state-versions
  $%  state-0
  ==
::
+$  state-0
  $:  %0
      local=(set app)                 ::  our locally-installed apps
      rankings=(list app)             ::  ordered list of most-installed apps
      scores=(map app score)          ::  app scores
      versions=(map app kelvin)       ::  app versions
      installs=(map app (list time))  ::  most recent installs
      dockets=(map app docket-0)      ::  docket info for each app
  ==
::
::  hit: message sent between ships on each app (un)install
+$  hit
  $:  =time       ::  when this message was generated
      =app        ::  app's publisher and name
      =kelvin     ::  app's kelvin compatibility
      =installed  ::  installed or uninstalled?
  ==
::
+$  card  $+(card card:agent:gall)
--
::
=|  state-0
=*  state  -
::
::  /lib/gossip.hoon config
%-  %+  agent:gossip
      [2 %targets %anybody |]
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
++  on-load
|=  =vase
  ^-  (quip card _this)
  =/  saved-state
    !<(state-versions vase)
  ?-  -.saved-state
    %0  [~ this(state saved-state)]
  ==
::
++  on-poke  on-poke:def
++  on-watch
  |=  =path
  ^-  (quip card _this)
  ~&  >  "hits: received subscription to {<path>}"
  ?+  path
    (on-watch:def path)
  ::
      [%ui-updates ~]
    ::
    ::  frontend listens to our ship for new hits;
    ::  will update the chart live on the user device
    ?>  =(our.bowl src.bowl)
    =/  base-version
      (scry-kelvin our.bowl %base now.bowl)
    :_  this
    %+  turn
      %+  skip
        rankings
      |=  =app
      ^-  ?
      (gth (~(got by versions) app) base-version)
    |=  =app
    ^-  card
      :*  %give
          %fact
          ~
          %ui-update
          !>  ^-  ui-update
          :*  %app-update
              app
              (~(got by scores) app)
              (~(got by versions) app)
              (~(got by installs) app)
              ?.  (~(has by dockets) app)
                *docket-0
              (~(got by dockets) app)
          ==
      ==

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
        :*  now.bowl
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
        ?:  =(%pawn (clan:title ship.app.hit))
          `this
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
            %+  sort
              :-  time.hit
              %-  ~(gut by installs)
              :-  app.hit
              ~
            |=  [a=time b=time]
            ^-  ?
            (gth a b)
          ::
          ::  update app info on install, ask for docket
          ::  info from the app's publisher
          :_  %=  this
                scores    (~(put by scores) [app.hit new-score])
                versions  (~(put by versions) [app.hit new-version])
                installs  %-  ~(put by installs)
                          [app.hit (~(got by new-installs) app.hit)]
                rankings  %+  rank-apps
                            (~(put by scores) [app.hit new-score])
                          %-  ~(put by installs)
                          [app.hit (~(got by new-installs) app.hit)]
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
          ?.  (~(has by installs) app.hit)
            installs
          ?:  =(1 (lent (~(got by installs) app.hit)))
            (~(del by installs) app.hit)
          %-  ~(put by installs)
          :-  app.hit
          %-  tail
          %+  sort
            (~(got by installs) app.hit)
          gth
        ::
        :_  %=  this
              dockets   new-dockets
              installs  new-installs
              versions  new-versions
              scores    (~(put by scores) [app.hit new-score])
              rankings  %+  rank-apps
                          (~(put by scores) [app.hit new-score])
                        new-installs
            ==
        :~  :*  %give
                %fact
                ~[/ui-updates]
                %ui-update
                !>  ^-  ui-update
                [%score-update [app.hit new-score]]
            ==
            :*  %give
                %fact
                ~[/ui-updates]
                %ui-update
                !>  ^-  ui-update
                [%installs-update [app.hit (~(got by new-installs) app.hit)]]
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
        (skip-desk desk)
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
        (skip-desk desk)
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
            (add now.bowl ~m5)
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
        :*  now.bowl
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
      :*  now.bowl
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
      =/  =app  [`@p`(slav %p ship.pole) desk.pole]
      ?.  -.p.sign-arvo
        %-  %+  slog
              %-  crip
              "hits: failed to read docket file from {<desk.pole>}"
            ~
        :_  this
        ::
        ::  if we fail to read the docket file, we send
        ::  these updates to the frontend. if app already
        ::  exists on the frontend, ui will be updated.
        ::  if app doesn't already exist on the frontend,
        ::  we won't add it until we get a valid docket
        :~  :*  %give
                %fact
                ~[/ui-updates]
                %ui-update
                !>  ^-  ui-update
                :*  %score-update
                    app
                    (~(got by scores) app)
                ==
            ==
            :*  %give
                %fact
                ~[/ui-updates]
                %ui-update
                !>  ^-  ui-update
                :*  %version-update
                    app
                    (~(got by versions) app)
                ==
            ==
            :*  %give
                %fact
                ~[/ui-updates]
                %ui-update
                !>  ^-  ui-update
                :*  %installs-update
                    app
                    (~(got by installs) app)
                ==
            ==
        ==
      ::
      ::  if we succesfully read the docket file, we add
      ::  the publisher to our 'allies' in %treaty to
      ::  facilitate app downloads from that publisher
      ::
      ::  XX check if we have treaty already to prevent
      ::     'subscribe wire not unique' error
      ::
      :-  :~  :*  %pass
                  ~
                  %agent
                  [our.bowl %treaty]
                  %poke
                  %ally-update-0
                  !>([%add ship.app])
              ==
              :*  %give
                  %fact
                  ~[/ui-updates]
                  %ui-update
                  !>  ^-  ui-update
                  ::  XX why not a %docket-update?
                  ::     if not here, where should the
                  ::     %docket-update be sent? what
                  ::     about when we get %update-docket?
                  :*  %app-update
                      app
                      (~(got by scores) app)
                      (~(got by versions) app)
                      (~(got by installs) app)
                      (docket-0 (tail (tail +.p.sign-arvo)))
                  ==
              ==
          ==
      %=  this
        dockets  %-  %~  put  by
                   dockets
                 :-  app
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
      =/  =app  [`@p`(slav %p ship.pole) desk.pole]
      :_  this
      :~  %+  invent:gossip
            %update-docket
          !>  ^+  app
          app
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
++  on-peek   on-peek:def
++  on-fail   on-fail:def
++  on-leave  on-leave:def
--
