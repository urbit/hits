/-  *hits
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
        %score-update
      %-  pairs:enjs:format
      :~  ['updateTag' [%s 'score-update']]
          ['ship' [%s (scot %p ship.app.upd)]]
          ['desk' [%s (scot %tas desk.app.upd)]]
          ['score' [%n (scot %ud score.upd)]]
      ==
    ::
        %version-update
      %-  pairs:enjs:format
      :~  ['updateTag' [%s 'version-update']]
          ['ship' [%s (scot %p ship.app.upd)]]
          ['desk' [%s (scot %tas desk.app.upd)]]
          ['version' [%n (scot %ud kelvin.upd)]]
      ==
    ::
        %installs-update
      %-  pairs:enjs:format
      :~  ['updateTag' [%s 'installs-update']]
          ['ship' [%s (scot %p ship.app.upd)]]
          ['desk' [%s (scot %tas desk.app.upd)]]
          :-  'installs'
          :-  %a
          %+  turn
            installs.upd
          |=(=time (time:enjs:format time))
      ==
    ::
        %docket-update
      =,  docket.upd
      %-  pairs:enjs:format
      :~  ['updateTag' [%s 'docket-update']]
          ['ship' [%s (scot %p ship.app.upd)]]
          ['desk' [%s (scot %tas desk.app.upd)]]
          :-  'docket'
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
    ::
        %app-update
      %-  pairs:enjs:format
      :~  ['updateTag' [%s 'app-update']]
          ['ship' [%s (scot %p ship.app.upd)]]
          ['desk' [%s (scot %tas desk.app.upd)]]
          ['score' ~]
          ['score' (numb:enjs:format score.upd)]
          ['version' ~]
          ['version' (numb:enjs:format kelvin.upd)]
          ::  ['docket' ~]
          :-  'installs'
          :-  %a
          %+  turn
            installs.upd
          |=  =time
          (time:enjs:format time)
          :-  'docket'
          %-  pairs:enjs:format
          :~  ['title' [%s title.docket.upd]]
              ['info' [%s info.docket.upd]]
              ['color' [%s (scot %ux color.docket.upd)]]
              ['image' [%s ?~(image.docket.upd '' (need image.docket.upd))]]
              ['website' [%s website.docket.upd]]
              ['license' [%s license.docket.upd]]
              =,  docket.upd
              :-  'version'
              :-  %s
              (crip "{<major.version>}.{<minor.version>}.{<patch.version>}")
          ==
      ==
    ==
  --
++  grad  %noun
--
