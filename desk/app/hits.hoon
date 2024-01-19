/+  gossip, default-agent
/$  grab-hit  %noun  %hit
::
|%
+$  src  ship
+$  app  [=ship =desk]
::  XX time could be replaced by a @dau to guarantee uniqueness; see %chess
+$  hit  [=src =time =app installed=?]
::
+$  state-0
  $:  scores=(map app @ud)
      local=(set [=ship =desk])
  ==
+$  card  $+(card card:agent:gall)
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
  ^-  (quip card _this)
  :_  this
  :~  [%pass /timers %arvo %b %wait now.bowl]
  ==
::
++  on-save
  !>(state)
::
++  on-load  on-load:def
  ::  XX set behn timer for now
  ::
  ::  |=  ole=vase
  ::  |^  ^-  (quip card _this)
  ::      =/  old=state-any  !<(state-any ole)
  ::      =^  caz  old
  ::        ?.  ?=(%0 -.old)  [~ old]
  ::        (state-0-to-1 old)
  ::      ?>  ?=(%1 -.old)
  ::      [caz this(state old)]
  ::  ::
  ::  +$  state-any  $%(state-1 state-0)
  ::  +$  state-0  [%0 faces=(map ship cord)]
  ::  ++  state-0-to-1
  ::    |=  old=state-0
  ::    ^-  (quip card state-1)
  ::    :-  ::  we nuke all outgoing subs, gossip will take over
  ::        %+  turn  ~(tap in ~(key by wex.bowl))
  ::        |=  [w=wire t=[@p @tas]]
  ::        [%pass w %agent t %leave ~]
  ::    =/  new=(map ship face)
  ::      (~(run by faces.old) |=(f=cord `face`[now.bowl `f]))
  ::    =?  new  !(~(has by new) our.bowl)
  ::      (~(put by new) our.bowl [now.bowl ~])
  ::    [%1 new]
  ::  --
::
++  on-poke  on-poke:def
::  ++  on-poke
::    |=  [=mark =vase]
::    ^-  (quip card _this)
::    ::  :-  ~  this
::    ?+  mark  (on-poke:def mark vase)
::      %handle-http-request
::        ?>  =(src our):bowl
::        `this
::        ::
::    ==  ::  end of mark branches
::
++  on-watch
  |=  =path
  ^-  (quip card _this)
  ?+  path  (on-watch:def path)
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
          =/  app-score  (~(gut by scores) app.hit 0)
          ?.  installed.hit
            :-  ~
            %=  this
              scores  (~(put by scores) [app.hit (dec (max app-score 1))])
            ==
          :-  ~
          %=  this
            scores  (~(put by scores) [app.hit +(app-score)])
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
++  on-peek   on-peek:def
++  on-fail   on-fail:def
--
