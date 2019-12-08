<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version='1.1'>

<!--

Extract "level 1" of the C3 Taxonomy, i.e. the part of the taxonomy approved by the C3 Board.

Copyright (c) 2019  Jens Stavnstrup/DALO <stavnstrup@mil.dk>

-->


<xsl:output indent="yes"/>


<xsl:template match="node[@title='Operational Context']">
  <xsl:apply-templates select="." mode="treepruning">
    <xsl:with-param name="maxlevel" select="4"/>
  </xsl:apply-templates>
</xsl:template>


<xsl:template match="node[@title='User-Facing Capabilities']">
  <xsl:apply-templates select="." mode="treepruning">
    <xsl:with-param name="maxlevel" select="4"/>
  </xsl:apply-templates>
</xsl:template>


<xsl:template match="node[@title='Community Of Interest (COI) Services']">
  <xsl:apply-templates select="." mode="treepruning">
    <xsl:with-param name="maxlevel" select="9"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="node[@title='Core Services']">
  <xsl:apply-templates select="." mode="treepruning">
    <xsl:with-param name="maxlevel" select="9"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="node[@title='Communications Services']">
  <xsl:apply-templates select="." mode="treepruning">
    <xsl:with-param name="maxlevel" select="9"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="node" mode="treepruning">
  <xsl:param name="maxlevel"/>
  <node>
    <xsl:apply-templates select="@*"/>
    <xsl:if test="@level &lt; $maxlevel">
      <xsl:apply-templates mode="treepruning">
        <xsl:with-param name="maxlevel" select="$maxlevel"/>
      </xsl:apply-templates>
    </xsl:if>
  </node>
</xsl:template>

<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>
