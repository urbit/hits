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
        %score-updated
      %-  pairs:enjs:format
      :~  ['updateTag' [%s 'score-updated']]
          ['ship' [%s (scot %p ship.app.upd)]]
          ['desk' [%s (scot %tas desk.app.upd)]]
          ['score' [%n (scot %ud score.upd)]]
      ==
    ::
        %version-updated
      %-  pairs:enjs:format
      :~  ['updateTag' [%s 'version-updated']]
          ['ship' [%s (scot %p ship.app.upd)]]
          ['desk' [%s (scot %tas desk.app.upd)]]
          ['version' [%n (scot %ud kelvin.upd)]]
      ==
    ::
        %installs-updated
      %-  pairs:enjs:format
      :~  ['updateTag' [%s 'installs-updated']]
          ['ship' [%s (scot %p ship.app.upd)]]
          ['desk' [%s (scot %tas desk.app.upd)]]
          :-  'installs'
          :-  %a
          %+  turn
            installs.upd
          |=(=time (time:enjs:format time))
      ==
    ::
        %docket-updated
      =,  docket.upd
      %-  pairs:enjs:format
      :~  ['updateTag' [%s 'docket-updated']]
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
        %app-requested
      %-  pairs:enjs:format
      :~  ['updateTag' [%s 'app-requested']]
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
