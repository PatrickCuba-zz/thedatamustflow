# thedatamustflow
Visio stencils and artefacts related to data vault guru

* Hub<br>
![Image][1=250px]<br>
A unique list of business entities.<br>
* Link<br>
![Image][2]<br>
A unique list of relationships.<br>
* Satellite<br>
![Image][3]<br>
Time-variant record of changes against a hub or a link.<br>

[1]: ./art/RV-1HUB.png
[2]: ./art/RV-2LINK.png
[3]: ./art/RV-3SATELLITE.png

Additional variations of links<br>

* Link with a dependent-child key<br>
![Image][4]<br>
This is a link that has a degenerate dimension that is applicable to all participants of a relationship.<br>
* Hierarchy link (HAL)<br>
![Image][5]<br>
* Same-as link (SAL)<br>
![Image][6]<br>
HAL and SAL are conceptual representations of the relationship, in truth they are simply just links and a link may include a combination of relationships all represented in a single link.<br>

[4]: ./art/RV-2LINK-DEPKEY.png
[5]: ./art/RV-2LINK-HIERARCHY.png
[6]: ./art/RV-2LINK-SAME-AS.png

Additional variations of satellites<br>
* Satellite with dependent-child key<br>
![Image][7]<br>
Changes are tracked against the hub or link and an additional key that categorises or subsets the parent key.
This key can also be an intra-day batch key.<br>
* Multi-active satellite<br>
![Image][8]<br>
Changes are tracked against a set of active records, any change to any member of the set or the number of records in a set causes the new set to be inserted and becomes the active set.<br>
* Effectivity satellite<br>
![Image][9]<br>
A satellite designed to track the movement of a driving key against the non-driving keys members of a link.<br>

Peripheral satellites<br>
* Record tracking satellite<br>
![Image][10]<br>
A satellite designed to track the last time a business entity or relationship was seen.
* Status tracking satellite<br>
![Image][11]<br>
A satellite designed to track if a business entity or relationship exists by comparing the ingested data against what was captured beforehand for that business entity or relationship.<br>

[7]: ./art/RV-3SATELLITE-DEPKEY.png
[8]: ./art/RV-3SATELLITE-MULTIACTIVE.png
[9]: ./art/RV-3SATELLITE-EFFECTIVITY.png
[10]: ./art/RV-3SATELLITE-RECORDTRACKING.png
[11]: ./art/RV-3SATELLITE-STATUSTRACKING.png

Time-line correction satellite<br>
* Extended record tracking satellite<br>
![Image][12]<br>

[12]: ./art/RV-3SATELLITE-RECORDTRACKINGEXTENDED.png
