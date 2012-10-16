//
// Add missing pci_dev_put
//
// Copyright: 2012 - LIP6/INRIA
// Licensed under GPLv2 or any later version.
// URL: http://coccinelle.lip6.fr/
// URL: https://github.com/coccinelle
// Author: Julia Lawall <Julia.Lawall@lip6.fr>
//

@r exists@
local idexpression x;
statement S,S1;
position p1,p2,p3;
expression E,E1;
type T,T1;
expression *ptr != NULL;
@@

(
 if ((x@p1 = pci_get_device(...)) == NULL) S
|
 x@p1 = pci_get_device(...);
)
 ... when != pci_dev_put(...,(T)x,...)
     when != if (...) { <+... pci_dev_put(...,(T)x,...) ...+> }
     when != true x == NULL || ...
     when != x = E
     when != E = (T)x
     when any
(
 if (x == NULL || ...) S1
|
 if@p2 (...) {
  ... when != pci_dev_put(...,(T1)x,...)
      when != if (...) { <+... pci_dev_put(...,(T1)x,...) ...+> }
      when != x = E1
      when != E1 = (T1)x
(
  return \(0\|<+...x...+>\|ptr\);
|
  return@p3 ...;
)
}
)

@ script:python @
p1 << r.p1;
p3 << r.p3;
@@

print "* file: %s pci_get_device: %s return: %s" % (p1[0].file,p1[0].line,p3[0].line)
