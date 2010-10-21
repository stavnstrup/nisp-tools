<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version='2.0'
                xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
                exclude-result-prefixes="fn">


<xsl:output indent="yes"/>


<xsl:strip-space elements="substandards"/>


<xsl:template match="taxonomy|remarks|rationale|records|organisations"/>


<xsl:template match="standards">
  <temp-tag>
    <community-of-interest>
      <xsl:apply-templates/>
    </community-of-interest>
  </temp-tag>
</xsl:template>


<xsl:template match="coistdprfs">
 <community coi="{@coi}">
   <xsl:apply-templates/>
 </community>
</xsl:template>

<xsl:template match="coistdprf">
  <profile type="coi" id="cp-{@id}" tref="" tag="">
    <parts>
       <xsl:apply-templates select=".//refprofile"/>
    </parts>
    <xsl:apply-templates select="history"/>
  </profile>
</xsl:template>


<xsl:template match="profile">
  <profile type="coi-minor" id="{@id}" tref="" tag="">
     <profilespec orgid="{@reforgid}" pubnum="{@pubnum}" title="{@title}"/>
     <parts>
       <xsl:apply-templates select="refstandards"/>
       <xsl:apply-templates select="refprofiles"/>
     </parts>
     <xsl:apply-templates select="configuration"/>
     <xsl:apply-templates select="applicability"/>
     <xsl:apply-templates select="history"/>
  </profile>
  <xsl:text> </xsl:text>
</xsl:template>


<xsl:template match="refstandards|refprofiles">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="refstandard">
  <refstandard refid="{@refstandardid}"/>
</xsl:template>

<xsl:template match="refprofile">
  <refprofile refid="{@refprofileid}"/>
</xsl:template>


<xsl:template match="history">
  <status stage="30.40" mode="unknown">
    <xsl:apply-templates/>
  </status>
</xsl:template>

<xsl:template match="status">
  <event flag="{@type}" date="{@date}" rfcp="" version="5.0"/>
</xsl:template>


<!-- ========================================== -->

<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*"/> 
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>




</xsl:stylesheet>
