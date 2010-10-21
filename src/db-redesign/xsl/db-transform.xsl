<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version='2.0'
                xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
                exclude-result-prefixes="fn">




<xsl:output indent="yes" doctype-system="../schema/dtd/stddb39.dtd"/>



<xsl:strip-space elements="substandards"/>



<xsl:template match="standardrecord[@id='unknown-dummy']">
   <standard tref="omat" id="unknown-dummy" tag=""/>
</xsl:template>

<!-- Transform standardrecords with one standard -->


<xsl:template match="standardrecord[count(.//standard)=1]">
  <standard>
    <xsl:apply-templates select="@*"/>
    <document>
       <xsl:apply-templates select="standard/@*"/>
       <xsl:apply-templates select="standard/*"/>
    </document>
    <xsl:apply-templates select="*[name()!='standard']"/>
  </standard>
</xsl:template>



<!-- Transform standardrecords with multiple standards -->


<xsl:template match="standardrecord[count(.//standard)>1]">
  <xsl:apply-templates select="standard/parts/standard" mode="s2substandards"/>
  <standard>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates select="standard" mode="coverstandard"/>
    <xsl:apply-templates select="*[name()!='standard']"/>
  </standard>
</xsl:template>


<xsl:template match="standard" mode="s2substandards">
  <standard ss="yes" id="{@orgid}-{translate(lower-case(@pubnum),'_. ','--')}" tref="{../../../@tref}" tag="">
    <document>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates/>
    </document>
    <xsl:copy-of select="../../../applicability"/>
    <xsl:copy-of select="../../../status"/>
  </standard>
</xsl:template>


<xsl:template match="standard" mode="coverstandard">
  <document>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates mode="coverstandard"/>
  </document>
</xsl:template>


<xsl:template match="parts" mode="coverstandard">
  <substandards>
    <xsl:apply-templates mode="coverstandard"/>
  </substandards>
</xsl:template>


<xsl:template match="parts/standard" mode="coverstandard">
  <refstandard refid="{@orgid}-{translate(lower-case(@pubnum),'_. ','--')}"/>
</xsl:template>

<xsl:template match="parts/refstandard" mode="coverstandard">
  <refstandard refid="{@refid}"/>
</xsl:template>




<!-- Transform profilerecords -->

<xsl:template match="profilerecord">
  <xsl:apply-templates select=".//standard" mode="psubstandards"/>
  <profile>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates/>
  </profile>
</xsl:template>


<xsl:template match="profilerecord/parts/standard">
  <refstandard refid="{@orgid}-{translate(lower-case(@pubnum),'_:/() ','--')}"/>  
</xsl:template>



<xsl:template match="standard" mode="psubstandards">
  <standard ss="yes" id="{@orgid}-{translate(lower-case(@pubnum),'_:/() ','--')}" tref="{../../@tref}" tag="">
    <document>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates/>
    </document>
    <xsl:copy-of select="../../applicability"/>
    <xsl:copy-of select="../../status"/>
  </standard>
</xsl:template>


<!-- ========================================== -->


<xsl:template match="@category"/>




<!-- ========================================== -->

<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*"/> 
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>




</xsl:stylesheet>
