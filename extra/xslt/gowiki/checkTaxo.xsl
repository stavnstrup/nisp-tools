<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:saxon="http://saxon.sf.net/"
                extension-element-prefixes="saxon"
                version='2.0'>

<xsl:output indent="yes" saxon:next-in-chain="checkTaxo-p2.xsl"/>

<!-- ============================================================== -->


<!-- Re-create the capability profile hierachy, which is necessary when we want to create
     queries accross multiple concepts -->


<xsl:template match="standards">
  <standards>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates/>

    <profilehierachy>
      <xsl:apply-templates select="records/profile[@toplevel='yes' and status/@mode='accepted']" mode="copyprofile"/>
    </profilehierachy>
  </standards>
</xsl:template>


<xsl:template match="profile[@toplevel='yes']" mode="copyprofile">
  <capabilityprofile type="cp" id="{@id}" short="{@short}">
    <xsl:apply-templates select="subprofiles" mode="copyprofile"/>
  </capabilityprofile>
</xsl:template>


<xsl:template match="profile[@toplevel='no']" mode="copyprofile">
  <profile type="pr" id="{@id}" short="{@short}">
    <xsl:apply-templates select="subprofiles" mode="copyprofile"/>
  </profile>
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



<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>
