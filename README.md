# thedatamustflow
Visio stencils and artefacts related to data vault guru

* **Hub**
* **Link**
* **Satellite**<br>
<img src="./art/RV-1HUB.png" alt="Hub"
	title="A unique list of business entities" width="120" height="120" />
<img src="./art/RV-2LINK.png" alt="Link"
  title="A unique list of relationships" width="150" height="150" />
<img src="./art/RV-3SATELLITE.png" alt="Satellite"
  title="Time-variant record of changes against a hub or a link" width="150" height="150" /><br>

## Additional variations of links<br>
* **Link with a dependent-child key**
* **Hierarchy link (HAL)**
* **Same-as link (SAL)**<br>
<img src="./art/RV-2LINK-DEPKEY.png" alt="Link-DepKey"
	title="This is a link that has a degenerate dimension that is applicable to all participants of a relationship" width="150" height="150" />
<img src="./art/RV-2LINK-HIERARCHY.png" alt="Link-DepKey"
	title="A hierarchy depicted using a link" width="150" height="150" />
<img src="./art/RV-2LINK-SAME-AS.png" alt="Link-DepKey"
	title="Two or more entities representing the same entity depicted using a link" width="150" height="150" />
HAL and SAL are conceptual representations of the relationship, in truth they are simply just links and a link may include a combination of relationships all represented in a single link.<br>

## Additional variations of satellites<br>
* Satellite with dependent-child key
* Multi-active satellite
* Effectivity satellite<br>
<img src="./art/RV-3SATELLITE-DEPKEY.png" alt="Link-DepKey"
	title="Changes are tracked against the hub or link and an additional key that categorises or subsets the parent key.
  This key can also be an intra-day batch key." width="150" height="150" />
<img src="./art/RV-3SATELLITE-MULTIACTIVE.png" alt="Link-DepKey"
	title="Changes are tracked against a set of active records, any change to any member of the set or the number of records in a set causes the new set to be inserted and becomes the active set." width="150" height="150" />
<img src="./art/RV-3SATELLITE-EFFECTIVITY.png" alt="Link-DepKey"
	title="A satellite designed to track the movement of a driving key against the non-driving keys members of a link." width="150" height="150" /><br>

## Peripheral satellites<br>
* Record tracking satellite<br>
![Image][10]<br>
A satellite designed to track the last time a business entity or relationship was seen.
* Status tracking satellite<br>
![Image][11]<br>
A satellite designed to track if a business entity or relationship exists by comparing the ingested data against what was captured beforehand for that business entity or relationship.<br>

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
