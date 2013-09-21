<?xml version="1.0"?>

<!--

This stylesheet is created for the NISP, and is
intended to identify upcoming emerging, midterm, longterm and fading
standards and profiles.

Copyright (c) 2010  Jens Stavnstrup/DALO <stavnstrup@mil.dk>

-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:saxon="http://icl.com/saxon"
                version='1.1'
                exclude-result-prefixes="#default saxon">
  
<xsl:output method="xml" indent="no" saxon:next-in-chain="p2-upcoming.xsl"/>

<xsl:template match="standards">
  <xsl:message>List all emerging, nearterm, farterm and fading standards/profiles</xsl:message>
  <allupcoming>
    <xsl:apply-templates select="/standards//standard|/standards//profile"/>
  </allupcoming>
</xsl:template>

<xsl:template match="standard">
  <xsl:variable name="sid" select="@id" />
  <xsl:if test="not(.//event[@flag = 'deleted']) and /standards/lists//select[(@mode != 'mandatory') and (@id=$sid)]">
    <element type="S" id="{@id}" orgid="{document/@orgid}" pubnum="{document/@pubnum}"
             title="{document/@title}" mode="{/standards/lists//select[@id=$sid]/@mode}"
             lastchange="{.//history/child::event[position()=last()]/@date}"/>
  </xsl:if>
</xsl:template>


<xsl:template match="profile">
  <xsl:variable name="sid" select="@id" />
  <xsl:if test="not(.//event[@flag = 'deleted']) and  /standards/lists//select[(@mode != 'mandatory') and (@id=$sid)]">
    <element type="P" id="{@id}" orgid="{profilespec/@orgid}" pubnum="{profilespec/@pubnum}"
             title="{profilespec/@title}" mode="{/standards/lists//select[@id=$sid]/@mode}"
             lastchange="{.//history/child::event[position()=last()]/@date}"/>
  </xsl:if>
</xsl:template>

</xsl:stylesheet>
