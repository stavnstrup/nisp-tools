<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version='2.0'
                xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
                exclude-result-prefixes="fn">




<xsl:output indent="yes"/>



<xsl:strip-space elements="records substandards"/>





<xsl:template match="revhistory|servicearea|lists"/>





<!-- Transform standardrecords with one standard -->


<xsl:template match="standardrecord[count(.//standard)=1]"/>

<!--
<xsl:template match="standardrecord[count(.//standard)=1]">
  <singlestandard>
    <xsl:apply-templates select="@*"/>
    <document>
       <xsl:apply-templates select="standard/@*"/>
       <xsl:apply-templates select="standard/*"/>
    </document>
    <xsl:apply-templates select="*[name()!='standard']"/>
  </singlestandard>
</xsl:template>
-->



<!-- Transform standardrecords with multiple standards -->

<xsl:template match="standardrecord[count(.//standard)>1]"/>

<!--
<xsl:template match="standardrecord[count(.//standard)>1]">
  <xsl:apply-templates select="standard/parts/standard" mode="s2substandards"/>
  <coverstandard>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates select="standard" mode="coverstandard"/>
    <xsl:apply-templates select="*[name()!='standard']"/>
  </coverstandard>
</xsl:template>
-->


<xsl:template match="standard" mode="s2substandards">
  <substandard ss="yes" id="{@orgid}-{translate(lower-case(@pubnum),'_. ','--')}" tref="{../../../@tref}" tag="">
    <document>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates/>
    </document>
    <xsl:copy-of select="../../../applicability"/>
    <xsl:copy-of select="../../../status"/>
  </substandard>
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


<!-- Kan slettes

<xsl:template name="make-coverstandard">
  <coverstandard>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates mode="ccc"/>
  </coverstandard>
</xsl:template>

-->




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
  <substandard ss="yes" id="{@orgid}-{translate(lower-case(@pubnum),'_:/() ','--')}" tref="{../../@tref}" tag="">
    <document>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates/>
    </document>
    <xsl:copy-of select="../../applicability"/>
    <xsl:copy-of select="../../status"/>
  </substandard>
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


<xsl:template match="@*|node()" mode="ccc">
  <xsl:copy>
    <xsl:apply-templates select="@*" mode="ccc"/> 
    <xsl:apply-templates mode="ccc"/>
  </xsl:copy>
</xsl:template>


</xsl:stylesheet>
