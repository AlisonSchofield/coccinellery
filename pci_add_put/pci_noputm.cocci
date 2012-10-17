//
// Add missing pci_dev_put
//
// Copyright: 2012 - LIP6/INRIA
// Licensed under GPLv2 or any later version.
// URL: http://coccinelle.lip6.fr/
// URL: https://github.com/coccinelle
// Author: Julia Lawall <Julia.Lawall@lip6.fr>
//

@@
type T;
identifier d;
expression e;
@@

T *d;
...
while ((d = \(pci_get_device\|pci_get_device_reverse\|pci_get_subsys\|pci_get_class\)(..., d)) != NULL)
 {... when != pci_dev_put(d)
      when != e = d
(
   return d;
|
+  pci_dev_put(d);
?  return ...;
)
...}

@@
identifier d;
type T;
expression e, e1;
@@

T *d;
...
while ((d = \(pci_get_device\|pci_get_device_reverse\|pci_get_subsys\|pci_get_class\)(..., d)) != NULL)
  {... when != pci_dev_put(d)
       when != e = d
+ pci_dev_put(d);
? break;
  ...}
... when != pci_dev_put(d)
    when != e1 = d
    when != return d;

@@
identifier d;
type T;
expression e;
iterator for_each_pci_dev;
@@

T *d;
...
for_each_pci_dev(d)
  {... when != pci_dev_put(d)
       when != e = d
(
   return d;
|
+  pci_dev_put(d);
?  return ...;
)
...}

@@
identifier d;
type T;
expression e, e1;
@@

T *d;
...
for_each_pci_dev(d)
  {... when != pci_dev_put(d)
       when != e = d
+ pci_dev_put(d);
? break;
  ...}
... when != pci_dev_put(d)
    when != e1 = d
    when != return d;
