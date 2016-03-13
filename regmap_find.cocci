// 
//	find devices global data structure
//	if regmap exists AND device struct *still* exists
//
//	use to sanity check regmap_transforms.cocci


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
*    struct device *d;
  ...
  };

