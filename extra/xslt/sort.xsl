<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version='1.1'>


<xsl:output method="xml" version="1.0" encoding="utf-8" indent="yes"
            doctype-public="-//DDRE//DTDStandardDB XML V4.0//EN"
            doctype-system="../schema/dtd/stddb40.dtd"/>

<!--

Sort standard and profiles by id.

Copyright (c) 2014  Jens Stavnstrup/DALO <stavnstrup@mil.dk>

-->


<xsl:template match="records">
  <records>
    <xsl:apply-templates select="standard|profile">
       <xsl:sort select="@id"/>
    </xsl:apply-templates>
  </records>
</xsl:template>

<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*"/> 
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>


</xsl:stylesheet>
