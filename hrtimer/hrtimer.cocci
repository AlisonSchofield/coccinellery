//
// use function hrtimer_is_queued
//
// Copyright: 2012 - LIP6/INRIA
// Licensed under GPLv2 or any later version.
// URL: http://coccinelle.lip6.fr/
// URL: https://github.com/coccinelle
// Author: Julia Lawall <Julia.Lawall@lip6.fr>
//

@header@
@@

#include <linux/hrtimer.h>

@same_hrtimer_is_queued depends on header@
position p;
@@

hrtimer_is_queued@p(...) { ... }

@depends on header@
position _p!=same_hrtimer_is_queued.p;
identifier _f;
struct hrtimer *_cocci_timer;
@@

_f@_p(...) { <+...
- (_cocci_timer->state & HRTIMER_STATE_ENQUEUED)
+ hrtimer_is_queued(_cocci_timer)
...+> }
