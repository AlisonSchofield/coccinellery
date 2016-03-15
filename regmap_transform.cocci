//	Purpose:
//	This semantic patch finds drivers that have struct regmap
//	AND struct device in their global data struct.  The struct
//	device can be deleted and regmap used to access same info.
//	Transform all usages and print warning of others.
//
//	Method:
//	find devices global data structure
//	if regmap exists AND device struct *still* exists
//		remove the device struct
//
//	find funcs accessing struct device thru their global data struct
//		(drvdata == global data struct)
//	Handle 3 Cases:
//
//		passed: drvdata passed as param to function
//              insert a local device struct obtained from regmap
//              use that local device struct instead of drvdata
//
//		derived: drvdata derived within function
//              insert a local device struct obtained from regmap
//              use that local device struct instead of drvdata
//
//		probe: it's the probe function
//		use the {i2c|spi|platform_device} function parameter
//		for device struct. 
//		delete attempt to store device struct in drvdata
//
//	Sweep:  print a warning message on any remaining dereferences
//		of the global struct device field. (drvdata->d)

@ a @
identifier drvdata, r;
position p;
@@
  struct drvdata@p {
  ...
  struct regmap *r;
  ...
  };

@ b @
identifier a.drvdata, d;
position a.p;
@@
  struct drvdata@p {
  ...
- struct device *d;
  ...
  };

@ passed depends on b @
identifier a.drvdata, a.r, b.d, i, f;
@@
  f (..., struct drvdata *i ,...) {
+ struct device *dev = regmap_get_device(i->r);
   <+...
-	   i->d
+	   dev
   ...+>
  }

@ derived depends on b @
expression e;
identifier a.drvdata, a.r, b.d, x, f;
@@
  f (...) {
  ...
  struct drvdata *x = e;
+ struct device *dev = regmap_get_device(x->r);
  <+...
-	   x->d
+	    dev
  ...+>
  }

@ getprobefn @
identifier s, probefn;
@@
( struct i2c_driver s = {...,.probe = probefn,...};
| struct spi_driver s = {...,.probe = probefn,...};
| struct platform_driver s = {...,.probe = probefn,...};
)

@ case_probe depends on getprobefn && b @
identifier getprobefn.probefn;
identifier a.drvdata,b.d,x,y;
struct drvdata *i;
expression e;
@@
  probefn (struct x *y, ...) {
  ...
- i->d = e;
  <...
-	   i->d    
+	&y->dev
  ...>
  }

@ remains depends on b exists @
identifier a.drvdata, b.d;
struct drvdata *i;
position p1;
@@
  i->d@p1

@script:python@
p1 << remains.p1;
@@
print "WARNING: unresolved use of global device structure"
print p1[0].file, p1[0].line
