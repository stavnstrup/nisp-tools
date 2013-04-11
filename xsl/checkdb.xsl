<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version='1.1'
                exclude-result-prefixes="#default">

<xsl:output method="text"/>

<xsl:template match="/">
  <xsl:variable name="standards.wo.uuid" select="count(//standard[not(uuid)])"/>
  <xsl:variable name="profiles.wo.uuid" select="count(//profile[not(uuid)])"/>
  <xsl:if test="$standards.wo.uuid + $profiles.wo.uuid >0">
    <xsl:message terminate="no">
      <xsl:value-of select="$standards.wo.uuid"/>
      <xsl:text> standards and </xsl:text>
      <xsl:value-of select="$profiles.wo.uuid"/>
      <xsl:text> profiles do not have an UUID element.</xsl:text>
    </xsl:message>
  </xsl:if>
  <xsl:text>missing.uuids=</xsl:text>
  <xsl:value-of select="$standards.wo.uuid + $profiles.wo.uuid"/>
</xsl:template>



</xsl:stylesheet>
