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
      %app-installed
        %-  pairs:enjs
        :~  ['app' [%s (scot %tas app.upd)]]
            ['installs' [%a (turn installs.upd |=(=time [%n (scot %ta (unt:chrono:userlib time))]))]]
        ==
      %app-uninstalled
        %-  pairs:enjs
        :~  ['app' [%s (scot %tas app.upd)]]
            ['installs' [%a (turn installs.upd |=(=time [%n (scot %ta (unt:chrono:userlib time))]))]]
        ==
      %app-refreshed
        %-  pairs:enjs
        :~  ['app' [%s (scot %tas app.upd)]]
            :-  'docket'
            :-  %o
            %-  molt
            :~  ['title' [%s title.docket.upd]]
                ['info' [%s info.docket.upd]]
                ['color' [%s (scot %ux color.docket.upd)]]
                ::  XX have to join href path into a url
                ['href' [%s ?.(=(%site -.href.docket.upd) [%s ''] [%s ''])]]
                ['image' [%s ?~(image.docket.upd '' u.image.docket.cord)]]
                ['version' [%s (crip "{<major.version.docket.upd>}.{<minor.version.docket.upd>}.{<patch.version.docket.upd>}")]]
                ['website' [%s website.docket.upd]]
                ['license' [%s license.docket.upd]]
            ==
        ==
  --
++  grad  %noun
--
