/-  *hits
|_  app-score=(unit score)
++  grab
  |%
  ++  noun  app-score=(unit score)
  --
++  grow
  |%
  ++  noun  app-score
  ++  json
    %-  frond:enjs:format
    :-  'score'
    ?~  app-score
      ~
    (numb:enjs:format u.app-score)
  --
++  grad  %noun
--
