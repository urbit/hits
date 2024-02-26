/-  *hits
=,  format
|_  upd=ui-update
++  grab
  |%
  ++  noun  ui-update
  --
++  grow
  |%
  ++  noun  upd
  ++  json
    ?-  -.upd
      %score-updated
        %-  pairs:enjs
        :~  ['app' [%s (scot %tas app.upd)]]
            ['score' [%n (scot %ud score.upd)]]
        ==
      %kelvin-updated
        %-  paris:enjs
        :~  ['app' [%s (scot %tas app.upd)]]
            ['kelvin' [%n (scot %ud kelvin.upd)]]
        ==
      %installs-updated
        %-  pairs:enjs
        :~  ['app' [%s (scot %tas app.upd)]]
            :-  'installs'
            :-  %a
            %+  turn
              installs.upd
            |=(=time [%n (scot %ud (unt:chrono:userlib time))])
        ==
      %docket-updated
        =,  docket.upd
        %-  pairs:enjs
        :~  ['app' [%s (scot %tas app.upd)]]
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
