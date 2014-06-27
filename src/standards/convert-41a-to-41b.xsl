<?xml version="1.0"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:saxon="http://saxon.sf.net/"
  exclude-result-prefixes="saxon">

<!--

This stylesheet is under continously development and will eventually be used to convert the standards database from version 4.1a to version 4.1b.



The following issues will be resolved:


Implemented in this stylesheet
==============================

* All "interoperability" profiles currently marked-up with

  <profile type="base" > will be renamed to   <interoperabilityprofile> 

TODO
====

* Remove profile (coi-minor,coi) from the DTD 




=======



-->


<xsl:output method="xml" version="1.0" encoding="utf-8" indent="yes"
            doctype-public="-//DDRE//DTDStandardDB XML V4.1//EN"
            doctype-system="../schema/dtd/stddb41b.dtd"/>



<xsl:template match="profile[@type='base']">
  <interoperabilityprofile id="{@id}" tag="{@tag}">
    <xsl:apply-templates/>
  </interoperabilityprofile>
</xsl:template>



<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*"/> 
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>


</xsl:stylesheet>
