/-  *hits
|_  docket=docket-0
++  grab
  |%
  ++  noun  docket-0
  --
++  grow
  |%
  ++  noun  docket
  ++  json
    %-  frond:enjs:format
    =,  docket
    :-  'docket'
    %-  pairs:enjs:format
    :~  ['app' [%s (scot %tas app)]]
        :-  'docket'
        :-  %o
        %-  molt
        :~  ['title' [%s title]]
            ['info' [%s info]]
            ['color' [%s (scot %ux color)]]
            ['image' [%s ?~(image '' u.image)]]
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