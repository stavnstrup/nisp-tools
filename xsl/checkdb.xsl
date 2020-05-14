<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version='1.1'
                exclude-result-prefixes="#default">

<xsl:output method="text"/>

<xsl:template match="/">
  <!-- Check DB for missing attributes in standards only -->
  <xsl:variable name="empty.tag" select="count(//standard[@tag='' and status/@mode='accepted'])"/>
  <xsl:variable name="empty.orgid" select="count(//document[@orgid='' and ../status/@mode='accepted'])"/>
  <xsl:variable name="empty.pubnum" select="count(//document[@pubnum='' and ../status/@mode='accepted'])"/>
  <xsl:variable name="empty.date" select="count(//document[@date='' and ../status/@mode='accepted'])"/>
  <xsl:variable name="empty.uri" select="count(//standard[status/@mode='accepted'])-count(//standard/status/uri[../@mode='accepted'])"/>
  <xsl:variable name="empty.applicability" select="count(//applicability[not(string(.)) and ../status/@mode='accepted'])"/>

  <xsl:if test="$empty.tag">
    <xsl:message>
      <xsl:text>Warning: </xsl:text>
      <xsl:value-of select="$empty.tag"/>
      <xsl:text> empty tags</xsl:text>
    </xsl:message>
  </xsl:if>
  <xsl:if test="$empty.orgid">
    <xsl:message>
      <xsl:text>Warning: </xsl:text>
      <xsl:value-of select="$empty.orgid"/>
      <xsl:text> empty organisation identifiers</xsl:text>
    </xsl:message>
  </xsl:if>
  <xsl:if test="$empty.pubnum">
    <xsl:message>
      <xsl:text>Warning: </xsl:text>
      <xsl:value-of select="$empty.pubnum"/>
      <xsl:text> empty publication numbers</xsl:text>
    </xsl:message>
  </xsl:if>
  <xsl:if test="$empty.date">
    <xsl:message>
      <xsl:text>Warning: </xsl:text>
      <xsl:value-of select="$empty.date"/>
      <xsl:text> empty dates</xsl:text>
    </xsl:message>
  </xsl:if>
  <xsl:if test="$empty.uri">
    <xsl:message>
      <xsl:text>Warning: </xsl:text>
      <xsl:value-of select="$empty.uri"/>
      <xsl:text> empty uris</xsl:text>
    </xsl:message>
  </xsl:if>
  <xsl:if test="$empty.applicability">
    <xsl:message>
      <xsl:text>Warning: </xsl:text>
      <xsl:value-of select="$empty.applicability"/>
      <xsl:text> empty applicability elements</xsl:text>
    </xsl:message>
  </xsl:if>


  <xsl:if test="$empty.tag + $empty.orgid + $empty.pubnum + $empty.date > 0">
    <xsl:message>Run the command "build debug" for additional information</xsl:message>
  </xsl:if>



    <!--
	count(//serviceprofile[not(uuid) or uuid = '']) +
    -->

  <xsl:variable name="standards.wo.uuid" select="count(//standard[not(uuid) or uuid = ''])"/>
  <xsl:variable name="profiles.wo.uuid" select="count(//capabilityprofile[not(uuid) or uuid = '']) +
						count(//setofstandards[not(uuid) or uuid = ''])"/>
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
