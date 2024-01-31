|%
++  scry-kelvin
  |=  [our=@p =desk now=@da]
  ^-  @ud
  ::  XX assumes we only care about %zuse compat for now
  ::     should get this squared away before release
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
