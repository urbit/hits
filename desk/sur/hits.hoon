|%
+$  installed  ?
+$  kelvin     @ud
+$  score      @ud
+$  src        ship
+$  app        [=ship =desk]
::
+$  ui-update
  $%  [%app-installed =app installs=(list time)]
      [%app-uninstalled =app installs=(list time)]
      [%app-refreshed =app docket=docket-0]
  ==
::
+$  version
  $+  version-hits
  [major=@ud minor=@ud patch=@ud]
::
+$  glob-reference
  $+  glob-reference-hits
  [hash=@uvH location=glob-location]
::
+$  glob-location
  $+  glob-location-hits
  $%  [%http url=cord]
      [%ames =ship]
  ==
::
+$  href
  $+  href-hits
  $%  [%glob base=term =glob-reference]
      [%site =path]
  ==
::
+$  docket-0
  $+  docket-0-hits
  $:  %1
      title=@t
      info=@t
      color=@ux
      =href
      image=(unit cord)
      =version
      website=cord
      license=cord
  ==
--
