/-  *hits
|_  docket=(unit docket-0)
++  grab
  |%
  ++  noun  (unit docket-0)
  --
++  grow
  |%
  ++  noun  docket
  ++  json
    %-  frond:enjs:format
    :-  'docket'
    ?~  docket
      ~
    =,  u.docket
    %-  pairs:enjs:format
    :~  :-  'docket'
        :-  %o
        %-  molt
        :~  ['title' [%s title]]
            ['info' [%s info]]
            ['color' [%s (scot %ux color)]]
            ['image' [%s ?~(image '' (need image))]]
            ['website' [%s website]]
            ['license' [%s license]]
            :-  'version'
            :-  %s
            (crip "{<major.version>}.{<minor.version>}.{<patch.version>}")
        ==
    ==
  --
++  grad  %noun
--
