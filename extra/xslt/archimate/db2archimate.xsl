<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:saxon="http://saxon.sf.net/"
                extension-element-prefixes="saxon"
                xmlns:uuid="java:java.util.UUID"
                version='2.0'
                exclude-result-prefixes="uuid">

<!-- ==========================================================

     Create Archimate export of all standards and profiles

     1. Remove all deleted elements
     2. Prefix all uuid's with 'id-', which is required by the Archimate Exchange Format schema
     3. Create a lookup table in order to create a propertyDefinitions list
     4. Create a relation between profile and "sub elements" (adding uuid to the refprofile element)
     5. Create a relation between service profile and referencegroups 
     6. Create a relation between referencegroupd and standards
     7. Add a helper tree of profile heirachy

     7. Create a JSON file with viewpoints used to calculate position of elements

     ========================================================== -->

<xsl:output indent="yes" saxon:next-in-chain="db2archimate-p2.xsl"/>
<!--
<xsl:output indent="yes"/>
-->

<!-- Remove all deleted elements -->

<xsl:template match="*[status/@mode='deleted']"/>

<!-- Prefix all uuid's with 'id-', which is required by the Archimate Exchange Format schema -->

<xsl:template match="uuid">
  <uuid>
    <xsl:text>id-</xsl:text>
    <xsl:value-of select="."/>
  </uuid>
</xsl:template>

<!-- Create a lookup table in order to create a propertyDefinitions list -->

<xsl:template match="standards">
  <standards>
    <xsl:apply-templates select="@*"/>
    <allattributes>
      <def position="1" attribute="organisation"/>
      <def position="2" attribute="pubnum"/>
      <def position="3" attribute="title"/>
      <def position="4" attribute="date"/>
      <def position="5" attribute="version"/>
      <def position="6" attribute="responsibleparty"/>
      <def position="7" attribute="uri"/>
      <def position="8" attribute="nisp_element"/>
    </allattributes>
    <xsl:apply-templates/>
  </standards>
</xsl:template>

<!--
  Create a relation between profile and "sub elements" (adding uuid to the refprofile element)
  Create a relation between service profile and referencegroups 
  Create a relation between referencegroupd and standards
-->

<xsl:template match="refprofile|refstandard|refgroup">
  <xsl:element name="{local-name()}">
    <xsl:apply-templates select="@*"/>
    <xsl:attribute name="uuid">
      <xsl:text>id-</xsl:text>
      <xsl:value-of select="uuid:randomUUID()"/>
    </xsl:attribute>
    <xsl:apply-templates/>
  </xsl:element>
</xsl:template>

<!-- Leave evetything rest alone -->

<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>
