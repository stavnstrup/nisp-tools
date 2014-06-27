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
convert-4.01a-to-4.1b.xsl to the database.

## Finished - developed in the **90-WIP-new-schema** branch

* All "baseline" profiles currently marked-up with

  <profile type="base" > will be renamed to   <baselineprofile> 

## TODO


* Remove profile (coi-minor,coi) from the 4.1 DTD 
* All "baseline" profiles currently marked-up with

  `<profile type="base">` will be renamed to   `<baselineprofile>` 

* Remove profile (coi-minor,coi) from the DTD 
* Document changes to the DTD


* A new profile will properly consists of a number of service
  InterOperability Profiles (SIOP). And each SIOP will list
  standards/baslineprofiles will supports the inplementation of a
  service from the C3-taxonomy. I.e. we now have three profile
  elements: profile, siop and baselineprofile.


* Add new custodian element to standards/profiles DTD. The custodian is actually what is currently mentioned as org in profile, but is not defined in profiles.
=======

## TODO - after the transformation (development in the **9.0-WIP-stylesheets** branch)








## TODO (fixed) - after the transformation (development in the **9.0-WIP-stylesheets** branch)

* Add basleline profile to xsl/makeUUID.xsl stylesheet 


## TODO (not yet) - after the transformation (development in the **9.0-WIP-stylesheets** branch)

*




=======

