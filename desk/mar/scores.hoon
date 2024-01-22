=,  format
::  XX get types in /sur so we can name these properly
|_  update=(list [[ship desk] [@ud (list @da)]])
++  grab
  |%
  ++  noun  (list [[ship desk] [@ud (list @da)]])
  --
++  grow
  |%
  ++  noun  update
  ++  json
    :- 'scores'
    %+  turn
      update
    |=  [app=[=ship =desk] score=@ud installs=(list @da)]
    %-  pairs:enjs
    :~  ['app' [%s (scot %tas desk)]]
        ['source' [%s (scot %p ship)]]
        ['installs' [%s (scot %ud score)]]
        ['dates' [%a (turn installs |=(install=@da [%s (scot %da install)]))]]
    ==
  --
++  grad  %noun
--
