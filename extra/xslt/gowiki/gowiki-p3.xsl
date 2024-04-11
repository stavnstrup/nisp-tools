<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:saxon="http://saxon.sf.net/"
                extension-element-prefixes="saxon"
                version='2.0'>


<!-- Identify capability profiles, which should not be transitioned to the wiki.
     If a capability profiles only have one service profile, then we ignore the
     capability profile and only transition the service profile.
-->

<xsl:output indent="yes" saxon:next-in-chain="gowiki-p4.xsl"/>

<xsl:template match="records/profile[@toplevel='yes']">
  <xsl:variable name="myid" select="@id"/>
  <xsl:if test="count(../../profilehierachy/capabilityprofile[@id=$myid]//*[descendant-or-self::serviceprofile]) != 1">
    <profile>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates/>
    </profile>
  </xsl:if>
</xsl:template>

<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>
