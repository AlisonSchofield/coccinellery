//
//  Use FIELD_SIZEOF
//
// Target:  Linux
// Copyright:  Copyright: 2012 - LIP6/INRIA
// License:  Licensed under GPLv2 or any later version.
// Author: Julia Lawall <Julia.Lawall@lip6.fr>
// URL: http://coccinelle.lip6.fr/ 
// URL: http://coccinellery.org/ 

@haskernel@
@@

#include <linux/kernel.h>

@depends on haskernel@
type t;
identifier f;
@@

- (sizeof(((t*)0)->f))
+ FIELD_SIZEOF(t, f)

@depends on haskernel@
type t;
identifier f;
@@

- sizeof(((t*)0)->f)
+ FIELD_SIZEOF(t, f)
