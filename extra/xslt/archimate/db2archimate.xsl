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

     ========================================================== -->

<xsl:output indent="yes" saxon:next-in-chain="db2archimate-p2.xsl"/>


<!-- Remove all deleted elements -->

<xsl:template match="*[status/@mode='deleted']"/>

<!--
  Tag all nodes in the C3 taxonomy tree which should part of the ArchiMate export.
-->

<xsl:template match="node">
  <xsl:variable name="myid" select="@id"/>
  <node>
    <xsl:apply-templates select="@*"/>
    <!-- Only nodes which are referenced from a profile are included -->
    <xsl:if test="/standards/records/serviceprofile/reftaxonomy[@refid=$myid]">
      <xsl:attribute name="usenode">
        <xsl:text>yes</xsl:text>
      </xsl:attribute>
    </xsl:if>
    <xsl:apply-templates/>
  </node>
</xsl:template>

<!-- ========================================================== -->

<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>
