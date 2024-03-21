|%
+|  %constants
::
++  info-timeout  ~s30
::
++  target-timeout  ~s10
::
+|  %types
::
+$  result
  $:  timestamp=@da
      =status
  ==
::
+$  status
  $%  [%complete p=complete]
      [%pending p=pending]
  ==
::
+$  complete
  $%  [%yes ~]
      [%no-data ~]                          ::  yet to test connectivity for ship
      [%no-dns ~]                           ::  can't even talk to example.com
      [%no-our-planet last-contact=@da]     ::  can't reach our own planet (moon only)
      [%no-our-galaxy last-contact=@da]     ::  can't reach our own galaxy
      [%no-sponsor-hit =ship]               ::  their sponsor can reach their ship
      [%no-sponsor-miss =ship]              ::  their sponsor can't reach their ship
      [%no-their-galaxy last-contact=@da]   ::  can't reach their galaxy
      [%crash =tang]                        ::  check crashed
  ==
::
+$  pending
  $%  [%setting-up ~]
      [%trying-dns ~]
      [%trying-local ~]
      [%trying-target ~]
      [%trying-sponsor =ship]
  ==
::
+$  update
  $:  =ship
      =result
  ==
--
