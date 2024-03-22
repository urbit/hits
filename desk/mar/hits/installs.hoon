|_  installs=(list time)
++  grab
  |%
  ++  noun  (list time)
  --
++  grow
  |%
  ++  noun  installs
  ++  json
    %-  frond:enjs:format
    :-  'installs'
    :-  %a
    %+  turn
      installs
    |=  =time
    (time:enjs:format time)
  --
++  grad  %noun
--
