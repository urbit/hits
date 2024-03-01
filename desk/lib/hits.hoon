/-  *hits
|%
++  rank-apps
  |=  scores=(map app score)
  ^-  (list app)
  %+  turn
    %+  sort
      ~(tap by scores)
    |=  [a=[app score] b=[app score]]
    ^-  ?
    (gte +.a +.b)
  |=  [=app score]
  ^+  app
  app
::
++  scry-kelvin
  |=  [our=@p =desk now=@da]
  ^-  @ud
  ::  XX assumes we only care about %zuse compat for now
  ::     should get this squared away before release
  ::
  ::  XX starting to think this is not quite right: instead
  ::     of storing the lowest kelvin and returning that
  ::     on scry, we should return the whole list of %zuse
  ::     versions which the dev has explicitly declared
  ::     the app to be compatible with
  ::
  ::  return lowest kelvin number
  ::  in the app's sys.kelvin
  %-  tail
  %-  head
  %+  sort
    %+  skim
      %~  tap  in
      %-  waft-to-wefts:clay
      .^  waft:clay
          %cx
          (scot %p our)
          (scot %tas desk)
          (scot %da now)
          /sys/kelvin
      ==
    |=  [vane=@tas kelvin=@ud]
    ^-  ?
    =(vane %zuse)
  |=  [a=[@tas @ud] b=[@tas @ud]]
  ^-  ?
  (lth +.a +.b)
--
