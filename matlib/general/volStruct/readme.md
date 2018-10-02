volStruct
=========

volStruct is simple a struct carrying volume information. This format is useful in certain tools and implementations (e.g. where working in large ND arrays is cumbersome).

Specification
-------------

Assuming you have a volume `vol` that is `nDims` dimensions and has `nFeatures` features, thus the total number of dimensions is `nDims + 1`. Assume the intrinsic volume has `nElems` elements per feature. In other words, `numel(vol) == nElems * nFeatures`.
Then volStruct is:

- `volStruct.features` 	- the volume restructures in 2D, being nElems x nFeatures.
- `volStruct.volSize` 	- the original volume size. length(volStruct.volSize) should be the original number of dimensions.
	
volStuct can have many other fields as well as necessary by your algorithm.

Contact
-------
{adalca,klbouman}@csail.mit.edu
