<?xml version="1.0"?>

<!--

This stylesheet is created for the NISP, and is
intended to identify upcoming candidate
standards.

Copyright (c) 2010, 2015  Jens Stavnstrup/DALO <stavnstrup@mil.dk>

-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:saxon="http://icl.com/saxon"
                version='1.1'
                exclude-result-prefixes="saxon">

<xsl:output method="xml" indent="no" saxon:next-in-chain="p2-upcoming.xsl"/>


<xsl:param name="describe" select="''"/>


<xsl:template match="standards">
  <xsl:message>List all candidate standards/setofstandards</xsl:message>
  <allupcoming describe="{$describe}">
    <xsl:apply-templates select="//bpgroup[@mode != 'mandatory']/bprefstandard"/>
  </allupcoming>
</xsl:template>


<xsl:template match="bprefstandard">
  <xsl:variable name="ref" select="@refid" />

  <xsl:apply-templates select="//standard[@id=$ref]">
    <xsl:with-param name="mode" select="parent::bpgroup/@mode"/>
  </xsl:apply-templates>
  <xsl:apply-templates select="//setofstandard[@id=$ref]">
    <xsl:with-param name="mode" select="ancestor::bpgroup/@mode"/>
  </xsl:apply-templates>
</xsl:template>


<xsl:template match="standard">
  <xsl:param name="mode" select="''"/>
  <xsl:if test="not(.//event[@flag = 'deleted'])">
    <element type="S" id="{@id}" orgid="{document/@orgid}" pubnum="{document/@pubnum}"
             title="{document/@title}" mode="{$mode}"
             lastchange="{.//history/child::event[position()=last()]/@date}"/>
  </xsl:if>
</xsl:template>


<xsl:template match="setofstandards">
  <xsl:param name="mode" select="''"/>
  <xsl:if test="not(.//event[@flag = 'deleted']) and  /standards/lists//select[(@mode != 'mandatory') and (@id=$sid)]">
    <element type="P" id="{@id}" orgid="{profilespec/@orgid}" pubnum="{profilespec/@pubnum}"
             title="{profilespec/@title}" mode="{$mode}"
             lastchange="{.//history/child::event[position()=last()]/@date}"/>
  </xsl:if>
</xsl:template>

</xsl:stylesheet>
