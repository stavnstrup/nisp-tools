<?xml version="1.0" encoding="ISO-8859-1"?>

<!--

This stylesheet is created for the NISP, and is intended for resolving
volume 1 and 5.

Copyright (c) 2002-2010, Jens Stavnstrup/DALO <stavnstrup@mil.dk>
Danish Defence Acquisition and Logistic Organisation (DALO),
Danish Defence Research Establishment (DDRE) and 
NATO Command, Control and Consultation Organisation (NC3O).


-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version='1.1'
                exclude-result-prefixes="#default">



<xsl:import href="resolve-common.xsl"/>

  
<xsl:output method="xml" version="1.0" encoding="utf-8"
            doctype-public="-//OASIS//DTD DocBook XML V4.5//EN"
            doctype-system="../src/schema/dtd/docbkx45/docbookx.dtd"/>


<!-- ==================================================================== -->

<xsl:template match="/">
  <xsl:comment>

     DO NOT MODIFY THIS DOCUMENT. THIS IS A RESOLVED VERSION ONLY.
     
  </xsl:comment>

  <xsl:apply-templates/>
</xsl:template>  

<!-- ==================================================================== -->



</xsl:stylesheet>
