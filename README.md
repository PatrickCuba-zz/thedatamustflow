# thedatamustflow
Visio stencils and artefacts related to data vault guru

* **Hub**<br>
![Image][1]<br>
![hub](./art/RV-1HUB.png#thumbnail)<br>
<img src="./art/RV-1HUB.png" alt="Hub"
	title="A unique list of business entities" width="150" height="150" /><br>
A unique list of business entities.<br>
* **Link**<br>
![Image][2]<br>
A unique list of relationships.<br>
* **Satellite**<br>
![Image][3]<br>
Time-variant record of changes against a hub or a link.<br>

[1]: ./art/RV-1HUB.png
[2]: ./art/RV-2LINK.png
[3]: ./art/RV-3SATELLITE.png

## Additional variations of links<br>

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

## Additional variations of satellites<br>
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

## Peripheral satellites<br>
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

## Time-line correction satellite<br>
* Extended record tracking satellite<br>
![Image][12]<br>

[12]: ./art/RV-3SATELLITE-RECORDTRACKINGEXTENDED.png

## Business vault<br>
These are no different to raw vault artefacts except that we are storing the derived output using the above raw vault loading patterns.
* Hub<br>
![Image][13]<br>
* Link<br>
![Image][14]<br>
* Link with dependent child key<br>
![Image][15]<br>
* Exploration link<br>
![Image][16]<br>
Temporary link testing out possible relationships.
* Satellite<br>
![Image][17]<br>
* Satellite with a dependent-child key<br>
!][Image][18]<br>
* Multi-active satellite<br>
![Image][19]<br>

[13]: ./art/BV-1HUB.png
[14]: ./art/BV-2LINK.png
[15]: ./art/BV-2LINK-DEPKEY.png
[16]: ./art/BV-2LINK-EXPLORE.png
[17]: ./art/BV-3SATELLITE.png
[18]: ./art/BV-3SATELLITE-DEPKEY.png
[19]: ./art/BV-3SATELLITE-MULTIACTIVE.png

Reference data<br>
![Image][20]<br>

[20]: ./art/REFERENCE.png

## Query assistance tables<br>
Query assistance structures are needed if direct method to get data out of data vault is slow or needs optimisation. This can be achieved by using index optimised data structures that point directly to the indexes in the data vault.<br>
* Point-in-time (PIT) tables<br>
![Image][21]<br>
* Bridge tables<br>
![Image][22]<br>

[21]: ./art/PIT.png
[22]: ./art/BRIDGE.png
