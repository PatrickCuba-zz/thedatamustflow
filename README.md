<img src="./datavaultguru header.png" alt="Header"
	title="DV Header"/>

# thedatamustflow
#datavault #data-vault
<br> Visio stencils and artefacts related to data vault guru.
Click the link above for the downloadable stencil for Visio.
Use the art if you wish to create your own. And if you like upload your work to this repo.
The art and stencils are provided under Creative Commons licensing.<br>
<a rel="license" href="http://creativecommons.org/licenses/by/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by/4.0/">Creative Commons Attribution 4.0 International License</a>.
<br> Find the book at Amazon, Kindle and Paperpack, click [US](https://amzn.to/3d7LsJV), [UK](https://amzn.to/3nsqTfR) and [AU](https://amzn.to/30IxOYF)
<br> And now find your favourite book art available for purchase at RedBubble! Click https://rdbl.co/3uMEReY

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
<img src="./art/RV-2LINK-HIERARCHY.png" alt="Link-Hierarchy"
	title="A hierarchy depicted using a link" width="150" height="150" />
<img src="./art/RV-2LINK-SAME-AS.png" alt="Link-Sameas"
	title="Two or more entities representing the same entity depicted using a link" width="150" height="150" /><br>
HAL and SAL are conceptual representations of the relationship, in truth they are simply just links and a link may include a combination of relationships all represented in a single link.<br>

## Additional variations of satellites<br>
* **Satellite with dependent-child key**
* **Multi-active satellite**
* **Effectivity satellite**<br>
<img src="./art/RV-3SATELLITE-DEPKEY.png" alt="Satellite-DepKey"
	title="Changes are tracked against the hub or link and an additional key that categorises or subsets the parent key.
  This key can also be an intra-day batch key." width="150" height="150" />
<img src="./art/RV-3SATELLITE-MULTIACTIVE.png" alt="Satellite-MultiActive"
	title="Changes are tracked against a set of active records, any change to any member of the set or the number of records in a set causes the new set to be inserted and becomes the active set." width="150" height="150" />
<img src="./art/RV-3SATELLITE-EFFECTIVITY.png" alt="Satellite-Effectivity"
	title="A satellite designed to track the movement of a driving key against the non-driving keys members of a link." width="150" height="150" /><br>

## Peripheral satellites<br>
* **Record tracking satellite**
* **Status tracking satellite**<br>
<img src="./art/RV-3SATELLITE-RECORDTRACKING.png" alt="Satellite-RecordTracking"
	title="A satellite designed to track the last time a business entity or relationship was seen." width="150" height="150" />
<img src="./art/RV-3SATELLITE-STATUSTRACKING.png" alt="Satellite-StatusTracking"
	title="A satellite designed to track if a business entity or relationship exists by comparing the ingested data against what was captured beforehand for that business entity or relationship." width="150" height="150" /><br>

## Time-line correction satellite<br>
* **Extended record tracking satellite**<br>
<img src="./art/RV-3SATELLITE-RECORDTRACKINGEXTENDED.png" alt="Satellite-ExtendedRecordTracking"
	title="An extension of the record tracking satellite used in tandem to keep an adjacent satellite's timeline correct in the event of a record arriving out of sequence" width="150" height="150" /><br>

## Business vault<br>
These are no different to raw vault artefacts except that we are storing the derived output using the above raw vault loading patterns.
* **Hub**
* **Link**
* **Link with dependent child key**
* **Exploration link**
* **Satellite**
* **Satellite with a dependent-child key**
* **Multi-active satellite**<br>
<img src="./art/BV-1HUB.png" alt="BV Hub"
	title="BV Hub" width="120" height="120" />
<img src="./art/BV-2LINK.png" alt="BV LINK"
	title="BV Link" width="150" height="150" />
<img src="./art/BV-2LINK-DEPKEY.png" alt="BV LINK-DepKey"
	title="BV Link with a dependent-child key" width="150" height="150" />
<img src="./art/BV-2LINK-EXPLORE.png" alt="BV LINK-Explore"
	title="Temporary link testing out possible relationships." width="150" height="150" />
<img src="./art/BV-3SATELLITE.png" alt="BV Satellite"
	title="BV Satellite" width="150" height="150" />
<img src="./art/BV-3SATELLITE-DEPKEY.png" alt="BV Satellite dependent-child key"
  	title="BV Satellite with dependent-child key" width="150" height="150" />
<img src="./art/BV-3SATELLITE-MULTIACTIVE.png" alt="BV Multi-Active Satellite"
	title="Multi-active BV satellite" width="150" height="150" /><br>

## Reference data<br>
<img src="./art/REFERENCE.png" alt="Reference data lookup"
	title="Reference data lookup" width="150" height="150" /><br>

## Query assistance tables<br>
Query assistance structures are needed if direct method to get data out of data vault is slow or needs optimisation. This can be achieved by using index optimised data structures that point directly to the indexes in the data vault.<br>
* **Point-in-time (PIT) tables**
* **Bridge tables**<br>
<img src="./art/PIT.png" alt="PIT"
	title="Point-in-time (PIT) table" width="150" height="150" />
<img src="./art/BRIDGE.png" alt="Bridge"
	title="Bridge table" width="150" height="100" /><br>

## Misc
* **Views**
* **Staging**<br><br>
<img src="./art/VIEW.png" alt="Views"
	title="Simplifying data vault consumption and deriving data marts" width="150" height="120" />
<img src="./art/STAGING.png" alt="Staging"
	title="Staging to add data vault metadata tags" width="120" height="120" />
