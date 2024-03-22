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
          %-  pairs:enjs:format
          :~  ['title' [%s title]]
              ['info' [%s info]]
              ['color' [%s (scot %ux color)]]
              ['image' [%s ?~(image '' (need image))]]
              ['website' [%s website]]
              ['license' [%s license]]
              :-  'version'
              :-  %s
              (crip "{<major.version>}.{<minor.version>}.{<patch.version>}")
              :-  'href'
              =/  href=^href  href
              %+  frond:enjs:format
                -.href
              ?-  -.href
                  %site
                [%s (spat path.href)]
              ::
                  %glob
                %-  pairs:enjs:format
                :~  ['base' [%s base.href]]
                    :-  'glob-reference'
                    %-  pairs:enjs:format
                    :~  ['hash' [%s (scot %uv hash.glob-reference.href)]]
                        :-  'location'
                        %+  frond:enjs:format
                          -.location.glob-reference.href
                        ?-  -.location.glob-reference.href
                            %http
                          [%s url.location.glob-reference.href]
                        ::
                            %ames
                          [%s (scot %p ship.location.glob-reference.href)]
                        ==
                    ==
                ==
              ==
          ==
      ==
    ::
        %app-update
      %-  pairs:enjs:format
      :~  ['updateTag' [%s 'app-update']]
          ['ship' [%s (scot %p ship.app.upd)]]
          ['desk' [%s (scot %tas desk.app.upd)]]
          ['score' (numb:enjs:format score.upd)]
          ['version' (numb:enjs:format kelvin.upd)]
          :-  'installs'
          :-  %a
          %+  turn
            installs.upd
          |=  =time
          (time:enjs:format time)
          =,  docket.upd
          :-  'docket'
          %-  pairs:enjs:format
          :~  ['title' [%s title]]
              ['info' [%s info]]
              ['color' [%s (scot %ux color)]]
              ['image' [%s ?~(image '' (need image))]]
              ['website' [%s website]]
              ['license' [%s license]]
              :-  'version'
              :-  %s
              (crip "{<major.version>}.{<minor.version>}.{<patch.version>}")
              :-  'href'
              =/  href=^href  href
              %+  frond:enjs:format
                -.href
              ?-  -.href
                  %site
                [%s (spat path.href)]
              ::
                  %glob
                %-  pairs:enjs:format
                :~  ['base' [%s base.href]]
                    :-  'glob-reference'
                    %-  pairs:enjs:format
                    :~  ['hash' [%s (scot %uv hash.glob-reference.href)]]
                        :-  'location'
                        %+  frond:enjs:format
                          -.location.glob-reference.href
                        ?-  -.location.glob-reference.href
                            %http
                          [%s url.location.glob-reference.href]
                        ::
                            %ames
                          [%s (scot %p ship.location.glob-reference.href)]
                        ==
                    ==
                ==
              ==
          ==
      ==
    ==
  --
++  grad  %noun
--
