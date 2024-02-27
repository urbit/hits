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
        :~  ['uiUpdate' [%s 'score-updated']]
            ['app' [%s (scot %tas app.upd)]]
            ['score' [%n (scot %ud score.upd)]]
        ==
      %version-updated
        %-  paris:enjs
        :~  ['uiUpdate' [%s 'version-updated']]
            ['app' [%s (scot %tas app.upd)]]
            ['version' [%n (scot %ud kelvin.upd)]]
        ==
      %installs-updated
        %-  pairs:enjs
        :~  ['uiUpdate' [%s 'installs-updated']]
            ['app' [%s (scot %tas app.upd)]]
            :-  'installs'
            :-  %a
            %+  turn
              installs.upd

            |=(=time [%n (time:enjs time)])
        ==
      %docket-updated
        =,  docket.upd
        %-  pairs:enjs
        :~  ['uiUpdate' [%s 'docket-updated']]
            ['app' [%s (scot %tas app.upd)]]
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