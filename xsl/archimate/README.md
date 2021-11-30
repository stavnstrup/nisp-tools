# Archimate export of NISP DB

The db2archimate.xsl stylesheet is a XSLT 2 stylesheet, which utilizes the SAXON XSLT processor ablity to serialize processing of XML. The stylesheet transforms the NISP database into an Archimate Exchange format compliant with the NISP Archimate Exchange specification located at https://tide.act.nato.int/git/IPCaT/NISPArchiMateProfile.


The param.xsl stylesheet contains parameter, which should be changed when creating an official extract. The parameters which should be changed are

* nispVersion
* nispDateIssued
* nispDateAccepted

and probably also the parameters

* c3t-statement
* c3t-date

This stylesheet requires Saxon 9.1 or higher and is run with the command:

```
   $ saxon standards.xml db2archimate.xsl
```
