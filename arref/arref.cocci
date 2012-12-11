//
//  Adjust array index
//
// Target:  Linux, Generic
// Copyright:  Copyright: 2012 - LIP6/INRIA
// License:  Licensed under GPLv2 or any later version.
// Author: Julia Lawall <Julia.Lawall@lip6.fr>
// URL: http://coccinelle.lip6.fr/ 
// URL: http://coccinellery.org/ 

@r exists@
position p,p1;
expression ar,e1,e2;
@@

for@p(e1 = 0; e1 < e2; e1++) { <... ar@p1[e1] ...> }

@script:python@
p << r.p;
p1 << r.p1;
@@

cocci.include_match(False)

@s@
constant c;
expression e1,e2,ar;
position r.p;
@@

for@p(e1 = 0; e1 < e2; e1++) { <...
(
  ar[c]
|
  ar[
- e2
+ e1
  ]
)
  ...> }