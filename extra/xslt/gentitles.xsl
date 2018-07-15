<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version='2.0'>


<!-- Add a genTitle attribute to the bpserviceprofile element. The attribute
     is a copy of the title attribute in the associated node and is not used
     in any of the XSLT scripts. The only justification for its existence is
     that is simplifies understanding, what taxonomy node a baserviceprofile
      maps to.
-->

<xsl:output method="xml" version="1.0" encoding="utf-8" indent="yes"
            doctype-public="-//DDRE//DTDStandardDB XML V4.4//EN"
            doctype-system="../schema/dtd/stddb44.dtd"/>

<xsl:strip-space elements="*"/>

<xsl:template match="bpserviceprofile">
  <xsl:variable name="mytref" select="@tref"/>
  <bpserviceprofile genTitle="{/standards/taxonomy//node[@id=$mytref]/@title}" tref="{@tref}">
    <xsl:apply-templates/>
  </bpserviceprofile>
</xsl:template>


<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>


</xsl:stylesheet>
