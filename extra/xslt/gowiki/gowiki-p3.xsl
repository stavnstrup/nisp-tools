<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:saxon="http://saxon.sf.net/"
                extension-element-prefixes="saxon"
                version='2.0'>


<xsl:output indent="yes" saxon:next-in-chain="gowiki-p4.xsl"/>


<!-- ============================================================== -->


<!-- Re-create the capability profile hierachy, which is necessary when we want to create
     queries accross multiple concepts -->


<xsl:template match="standards">
  <standards>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates/>

    <profilehierachy>
      <xsl:apply-templates select="records/profile[@top='yes' and status/@mode='accepted']" mode="copyprofile"/>
    </profilehierachy>
  </standards>
</xsl:template>


<xsl:template match="profile[@top='yes']" mode="copyprofile">
  <capabilityprofile type="cp" id="{@id}" short="{@short}">
    <xsl:apply-templates select="subprofiles" mode="copyprofile"/>
  </capabilityprofile>
</xsl:template>


<xsl:template match="profile[@top='no']" mode="copyprofile">
  <!-- We are only interested in the relationship between capabilityprofiles, serviceprofiles and
       standards - so do not list profiles in the heirachy, -->
  <xsl:apply-templates select="subprofiles" mode="copyprofile"/>
</xsl:template>


<xsl:template match="serviceprofile" mode="copyprofile">
  <serviceprofile id="{@id}">
    <xsl:apply-templates select="reftaxonomy" mode="copyprofile"/>
    <xsl:apply-templates select="refgroup" mode="copyprofile"/>
  </serviceprofile>
</xsl:template>


<xsl:template match="reftaxonomy" mode="copyprofile">
  <reftaxonomy refid="{@refid}"/>
</xsl:template>


<xsl:template match="subprofiles" mode="copyprofile">
  <xsl:apply-templates select="refprofile" mode="copyprofile"/>
</xsl:template>


<xsl:template match="refstandard" mode="copyprofile">
  <refstandard>
    <xsl:apply-templates select="@*"/>
  </refstandard>
</xsl:template>

<xsl:template match="refprofile" mode="copyprofile">
  <xsl:variable name="myid" select="@refid"/>
  <xsl:apply-templates select="/standards//*[@id=$myid]" mode="copyprofile"/>
</xsl:template>


<xsl:template match="refgroup" mode="copyprofile">
  <refgroup>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates select="refstandard" mode="copyprofile"/>
  </refgroup>
</xsl:template>







<!-- ============================================================== -->

<!--
<xsl:template match="profilespec">
  <xsl:variable name="myorg" select="@orgid"/>
  <profilespec>
    <xsl:attribute name="tag">
      <xsl:apply-templates select="/standards/organisations/orgkey[@key=$myorg]/@short"/>
      <xsl:if test="@pubnum !=''">
        <xsl:text> </xsl:text>
        <xsl:value-of select="@pubnum"/>
      </xsl:if>
      <xsl:if test="@date !=''">
        <xsl:text> (</xsl:text>
        <xsl:value-of select="substring(@date, 1, 4)"/>
        <xsl:text>)</xsl:text>
      </xsl:if>
    </xsl:attribute>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates/>
  </profilespec>
</xsl:template>
-->


<!--
<xsl:template match="applicability">
<xsl:if test="count(./node()) &gt; 0">
<xsl:apply-templates/>
</xsl:if>
</xsl:template>
-->


<xsl:template match="itemizedlist|orderedlist">
<xsl:text>LINEFEED</xsl:text>
<xsl:apply-templates/>
</xsl:template>


<xsl:template match="listitem">
<xsl:text>BULLETSPACES</xsl:text><xsl:apply-templates/><xsl:text>LINEFEED</xsl:text>
</xsl:template>

<xsl:template match="listitem/para"><xsl:apply-templates/></xsl:template>

<xsl:template match="para"><xsl:apply-templates/><xsl:text>LINEFEEDLINEFEED</xsl:text></xsl:template>

<!--
<xsl:template match="text()">
<xsl:variable name="escapeChars" select="'\&quot;'"/>
<xsl:if test="name(..)='applicability'"><xsl:text>  </xsl:text></xsl:if>
<xsl:value-of select="translate(translate(normalize-space(),':',' '), $escapeChars, ' ')"/>
</xsl:template>
-->



<!-- ============================================================== -->



<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>
