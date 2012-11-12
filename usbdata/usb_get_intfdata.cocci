//
// Use usb_set/get_intfdata
//
// Copyright: 2012 - LIP6/INRIA
// Licensed under GPLv2 or any later version.
// URL: http://coccinelle.lip6.fr/
// URL: https://github.com/coccinelle
// Author: Julia Lawall <Julia.Lawall@lip6.fr>
//

@header@
@@

#include <linux/usb.h>

@same depends on header@
position p;
@@

usb_get_intfdata@p(...) { ... }

@depends on header@
position _p!=same.p;
identifier _f;
struct usb_interface*intf;
@@

_f@_p(...) { <+...
- dev_get_drvdata(&intf->dev)
+ usb_get_intfdata(intf)
...+> }

