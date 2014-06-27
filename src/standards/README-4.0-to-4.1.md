# Plan and progress for transforming DTD from v. 4.0 to 4.1

Goal: Enable new user defined profiles, som we can add the profiles in
      volume 3 to the database.

      A secondary goal is to encourage the stakeholder to select/reuse
      standards/profiles in the following order:

* Userdefined profiles (eventually subprofiles/SIOPs) e.g. FMN /
  Digial Archive, ...
* Baselineprofiles - a set of profiles defined for conveniance purposes
* Coverstandards e.g. ISO 8859 instead of all the standards
  ISO-8859-1 to ISO-8859-x 
* Standard


The actual transformation will be done by applying the stylesheet
convert-4.0-to-4.1.xsl to the database.

## Finished - developed in the **90-WIP-new-schema** branch

* All "baseline" profiles currently marked-up with

  <profile type="base" > will be renamed to   <baselineprofile> 

## TODO


* Remove profile (coi-minor,coi) from the 4.1 DTD 
* All "baseline" profiles currently marked-up with

  `<profile type="base">` will be renamed to   `<baselineprofile>` 

* Remove profile (coi-minor,coi) from the DTD 
* Document changes to the DTD


## TODO (fixed) - after the transformation (development in the **9.0-WIP-stylesheets** branch)

* Add basleline profile to xsl/makeUUID.xsl stylesheet 


## TODO (not yet) - after the transformation (development in the **9.0-WIP-stylesheets** branch)

*




