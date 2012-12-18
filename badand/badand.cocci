//
//  Convert && to ||
//
// Target: Linux, Generic
// Copyright:  2012 - LIP6/INRIA
// License:  Licensed under GPLv2 or any later version.
// Author: Julia Lawall <Julia.Lawall@lip6.fr>
// URL: http://coccinelle.lip6.fr/ 
// URL: http://coccinellery.org/ 

@disable and_comm@
expression E;
identifier fld;
@@

- !E && !E->fld
+ !E || !E->fld

@disable or_comm@
expression E;
identifier fld;
@@

- E || E->fld
+ E && E->fld
