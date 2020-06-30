# thedatamustflow
Visio stencils and artefacts related to data vault guru

* Hub<br>
![Image][1]
A unique list of business entities.
* Link<br>
![Image][2]
A unique list of relationships.
* Satellite<br>
![Image][3]
Time-variant record of changes against a hub or a link.

[1]: ./art/RV-1HUB.png
[2]: ./art/RV-2LINK.png
[3]: ./art/RV-3SATELLITE.png

Additional variations of links

* Link with a dependent-child key
![Image][4]
This is a link that has a degenerate dimension that is applicable to all participants of a relationship.
* Hierarchy link (HAL)
![Image][5]
* Same-as link (SAL)
![Image][6]
HAL and SAL are conceptual representations of the relationship, in truth they are simply just links and a link may include a combination of relationships all represented in a single link.

[4]: ./art/RV-2LINK-DEPKEY.png
[5]: ./art/RV-2LINK-HIERARCHY.png
[6]: ./art/RV-2LINK-SAME-AS.png

Additional variations of satellites
* Satellite with dependent-child key
![Image][7]
Changes are tracked against the hub or link and an additional key that categorises or subsets the parent key.
This key can also be an intra-day batch key.
* Multi-active satellite
![Image][8]
Changes are tracked against a set of active records, any change to any member of the set or the number of records in a set causes the new set to be inserted and becomes the active set.
* Effectivity satellite
![Image][9]
A satellite designed to track the movement of a driving key against the non-driving keys members of a link.

Peripheral satellites
* Record tracking satellite
![Image][10]
A satellite designed to track the last time a business entity or relationship was seen.
* Status tracking satellite
![Image][11]
A satellite designed to track if a business entity or relationship exists by comparing the ingested data against what was captured beforehand for that business entity or relationship.

[7]: ./art/RV-3SATELLITE-DEPKEY.png
[8]: ./art/RV-3SATELLITE-MULTIACTIVE.png
[9]: ./art/RV-3SATELLITE-EFFECTIVITY.png
[10]: ./art/RV-3SATELLITE-RECORDTRACKING.png
[11]: ./art/RV-3SATELLITE-STATUSTRACKING.png

Time-line correction satellite
* Extended record tracking satellite
![Image][12]

[12]: ./art/RV-3SATELLITE-RECORDTRACKINGEXTENDED.png
