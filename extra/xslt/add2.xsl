<?xml version="1.0"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:saxon="http://saxon.sf.net/"
                xmlns:date="http://exslt.org/dates-and-times"
                extension-element-prefixes="date"
                version='2.0'
                exclude-result-prefixes="date saxon">

<xsl:output method="html" indent="yes"/>





<xsl:key name="key1" match="document" use="@orgid"/>


<xsl:template match="/">
  <html>
    <meta charset="utf-8" />
    <head><title>Responsible parties</title></head>
    <style type="text/css">
      table {
         border-collapse: collapse;
      }
      td, th {
        padding: 1px 4px;
      }
    </style>
  <body>
    <h1>New standards</h1>

    <xsl:apply-templates select="standards"/>
  </body></html>
</xsl:template>


<xsl:template match="standards">

  <xsl:for-each select="document[generate-id() = generate-id(key('key1', @orgid)[1])]">
    <xsl:sort select="@orgid"/>

    <xsl:variable name="myorg" select="@orgid"/>

    <h2><xsl:value-of select="$myorg"/></h2>
    <ul>
      <xsl:for-each select="key('key1', $myorg)">
        <li>
          <xsl:value-of select="normalize-space(./@title) "/>
          <xsl:if test="$myorg != '' or @pubnum !='' or @date != ''">
            <xsl:text> (</xsl:text>
            <xsl:if test="$myorg != ''">
              <xsl:value-of select="$myorg"/>
              <xsl:text> </xsl:text>
            </xsl:if>
            <xsl:if test="@pubnum !=''">
              <xsl:value-of select="@pubnum"/>
            </xsl:if>
            <xsl:if test="($myorg !='' or @pubnum !='') and @date !=''">
              <xsl:text>:</xsl:text>
            </xsl:if>
            <xsl:if test="@date !=''">
              <xsl:value-of select="substring(@date,1,4)"/>
            </xsl:if>
            <xsl:text>)</xsl:text>
          </xsl:if>
        </li>
      </xsl:for-each>
    </ul>
  </xsl:for-each>
</xsl:template>

<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>


</xsl:stylesheet>
