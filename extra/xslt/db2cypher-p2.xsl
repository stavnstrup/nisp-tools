<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:saxon="http://saxon.sf.net/"
                extension-element-prefixes="saxon"
                version='2.0'>

<!--
<xsl:output saxon:next-in-chain="db2cypher-p3.xsl"/>
-->

<xsl:output indent="yes"/>


<!-- Remove -->

<xsl:template match="document|profilespec">
  <xsl:element name="{local-name()}">
    <xsl:apply-templates select="@*"/>
    <xsl:attribute name="orgid">
      <xsl:value-of select="translate(@orgid,'-','_')"/>
    </xsl:attribute>
    <xsl:apply-templates/>
  </xsl:element>
</xsl:template>

<xsl:template match="responsibleparty">
  <xsl:element name="{local-name()}">
    <xsl:apply-templates select="@*"/>
    <xsl:attribute name="rpref">
      <xsl:value-of select="translate(@rpref,'-','_')"/>
    </xsl:attribute>
    <xsl:apply-templates/>
  </xsl:element>
</xsl:template>

<xsl:template match="node|standard|capabilityprofile|profile|serviceprofile">
  <xsl:element name="{local-name()}">
    <xsl:apply-templates select="@*"/>
    <xsl:attribute name="id">
      <xsl:value-of select="translate(@id,'-','_')"/>
    </xsl:attribute>
    <xsl:apply-templates/>
  </xsl:element>
</xsl:template>

<xsl:template match="bpserviceprofile">
  <bpserviceprofile>
    <xsl:apply-templates select="@*"/>
    <xsl:attribute name="tref">
      <xsl:value-of select="translate(@tref,'-','_')"/>
    </xsl:attribute>
    <xsl:apply-templates/>
  </bpserviceprofile>
</xsl:template>

<xsl:template match="bprefstandard|refprofile|refstandard|reftaxonomy">
  <bprefstandard>
    <xsl:apply-templates select="@*"/>
    <xsl:attribute name="refid">
      <xsl:value-of select="translate(@refid,'-','_')"/>
    </xsl:attribute>
    <xsl:apply-templates/>
  </bprefstandard>
</xsl:template>



<xsl:template match="event">
  <event>
    <xsl:attribute name="id">
      <xsl:text>ev</xsl:text>
      <xsl:number from="standards"
        count="event" format="1" level="any"/>
    </xsl:attribute>
    <xsl:apply-templates select="@*"/>
  </event>
</xsl:template>


<xsl:template match="orgkey|rpkey">
  <xsl:element name="{local-name()}">
    <xsl:apply-templates select="@*"/>
    <xsl:attribute name="key">
      <xsl:value-of select="translate(@key,'-','_')"/>
    </xsl:attribute>
    <xsl:apply-templates/>
  </xsl:element>
</xsl:template>

<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>


</xsl:stylesheet>
