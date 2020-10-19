# Archimate export of NISP DB

The db2archimate.xsl stylesheet a XSLT 2 stylesheet, which utilizes the SAXON XSLT processor ablity to serialize processing of XML. The stylesheet transforms the NISP database into an Archimate Exchange format compliant with the NISP Archimate Exchange specification located at https://tide.act.nato.int/git/IPCaT/NISPArchiMateProfile.

This stylesheet requires Saxon 9.1 or higher and is run with the command:

```
   $ saxon standards.xml db2archimate.xsl
```
