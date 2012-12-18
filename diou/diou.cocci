//
//  drop kfree of devm_kzalloc's data
//
// Target: Linux
// Copyright:  2012 - LIP6/INRIA
// License:  Licensed under GPLv2 or any later version.
// Author: Julia Lawall <Julia.Lawall@lip6.fr>
// URL: http://coccinelle.lip6.fr/ 
// URL: http://coccinellery.org/ 

@@
expression x;
@@

x = devm_kzalloc(...)
...
?-kfree(x);