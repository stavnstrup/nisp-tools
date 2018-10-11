<?xml version="1.0"?>


<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:saxon="http://saxon.sf.net/"
                extension-element-prefixes="saxon"
                version='2.0'>


<!-- Create a HTML document with standards added in this version.
     Subsequently this document can be converted to DocBook using a
     tool like Pandoc and embedded in volume 1.

     exammple

     1. Goto the vol1 folder and run the following commands
     2. saxon -o added-standards.html ../standards/standards.xml ../../extra/xslt/add1.xsl
     3. pandoc -o added-standards.xml -id-prefix=added- -t DocBook added-standards.html

     Note: The parameter id-prefix should be prefixed with two hyphens to the left.
-->

<xsl:output saxon:next-in-chain="add2.xsl"/>

<xsl:variable name="next.nisp.version" select="'11.0'"/>



<xsl:strip-space elements="*"/>

<xsl:param name="describe" select="''"/>


<xsl:template match="standards">
  <standards>
    <xsl:apply-templates select=".//event[(position()=last()) and (@flag='added') and (@version=$next.nisp.version)]"/>
  </standards>
</xsl:template>

<xsl:template match="event">
  <xsl:apply-templates select="../../../document">
    <xsl:sort select="../@id"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="document">
  <xsl:variable name="myorg" select="@orgid"/>
  <document>
    <xsl:apply-templates select="@*"/>
    <xsl:attribute name="orgid" select="//organisations/orgkey[@key=$myorg]/@short"/>
  </document>
</xsl:template>



<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>


</xsl:stylesheet>
