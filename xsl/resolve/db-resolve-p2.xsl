<?xml version="1.0"?>

<!--

This stylesheet is created for the NISP, and is intended for
tagging serviceprofile due to their dual functionallity.

We add a type attribute to the servicprofile using the following rules
  bsp: serviceprofiles which is part of the basic standards profile (BSP)
  coi: any other service profile, which is part of a capability profile like FMN.

Copyright (c) 2018, Jens Stavnstrup/DALO <stavnstrup@mil.dk>
Danish Defence Acquisition and Logistic Organisation (DALO),
Danish Defence Research Establishment (DDRE) and
NATO Command, Control and Consultation Organisation (NC3O).

-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version='1.1'
                xmlns:saxon="http://icl.com/saxon"
                exclude-result-prefixes="saxon">

<xsl:output saxon:next-in-chain="db-resolve-p3.xsl"/>

<xsl:strip-space elements="*"/>

  <!--
  Parameters to enable replacement of location of URI's to capability profiles
  and to update description information. -->
  <xsl:param name="capabilityprofile.list.dir"/>
  <xsl:param name="capabilityprofiles.location.pathname"/>
  <xsl:param name="capabilityprofiles.location.name"/>

  <!--
  Parameters to enable replacement of location of URI's to standard information. -->
  <xsl:param name="nisp.viewer.pathname"/>
  <xsl:param name="replace.standard.uri"/>
  <xsl:param name="use.nisp.viewer.standard.uri"/>
  <xsl:param name="nisp.viewer.standard.detail"/>
  <xsl:param name="nisp.viewer.target.type"/>

  <!-- ==================================================================== -->

<xsl:template match="/">
  <xsl:comment>

     DO NOT MODIFY THIS DOCUMENT. THIS IS A RESOLVED VERSION ONLY.

  </xsl:comment>

  <xsl:apply-templates/>
</xsl:template>

<!-- ==================================================================== -->

<!-- Add type attribute to all service profile, to be able to differentiate serviceprofiles,
     which are part of the Base Standards Profile and those which are not -->

<xsl:template match="serviceprofile">
  <xsl:variable name="myid" select="@id"/>
  <serviceprofile>
    <xsl:attribute name="type">
      <xsl:choose>
        <xsl:when test="/standards//capabilityprofile[@id='bsp']//refprofile[@refid=$myid]">
          <xsl:text>bsp</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>coi</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates/>
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

<!-- ==================================================================== -->

<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*"/>
    <xsl:apply-templates/>
  </xsl:copy>
</xsl:template>

<!-- ==================================================================== -->
  
<xsl:variable name="capabilityprofile.list" select="document(concat($capabilityprofile.list.dir,'capabilityprofiles.xml'))/capabilityprofiles"/>
<!--
  Add servicearea and docinfo information from capabilityprofile.list to the capability profile in the standards database. -->
  
<xsl:template match="capabilityprofile">
  <xsl:variable name="cpbprf.cur" select="$capabilityprofile.list/capabilityprofile[id=current()/@id]"/>
    <xsl:choose>
      <xsl:when test="$cpbprf.cur">
        <capabilityprofile id="{@id}" short="{@short}" title="{$cpbprf.cur/title}"
          servicearea="{$cpbprf.cur/servicearea}" docinfo="{$cpbprf.cur/docinfo}">
          <xsl:apply-templates/>
        </capabilityprofile>  
      </xsl:when>
      <xsl:otherwise>
        <capabilityprofile id="{@id}" short="{@short}" title="{@title}">
          <xsl:apply-templates/>
        </capabilityprofile>  
      </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!--
  Replace the URI of the PDF file to the user defined location. -->
  
<xsl:template match="capabilityprofile/status/uri">
  <xsl:variable name="cpbprf.cur" select="$capabilityprofile.list/capabilityprofile[id=current()/../../@id]"/>
    <uri>
      <xsl:choose>
      <xsl:when test="$capabilityprofiles.location.pathname != 'none'">
        <xsl:value-of select="concat($capabilityprofiles.location.pathname, $cpbprf.cur/pdf, '.pdf')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$cpbprf.cur/locations/location[@name=$capabilityprofiles.location.name]"/>
      </xsl:otherwise>
    </xsl:choose>
  </uri>
  <pdf>
		<xsl:choose>
			<xsl:when test="$cpbprf.cur/pdf/@title != ''">
				<xsl:value-of select="$cpbprf.cur/pdf/@title"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$cpbprf.cur/pdf"/>
			</xsl:otherwise>
		</xsl:choose>
  </pdf>
</xsl:template>

<!--
  Replace the description information by the user defined description.
  If not specified, keep the current description. -->
  
<xsl:template match="capabilityprofile/description">
  <xsl:variable name="cpbprf.cur" select="$capabilityprofile.list/capabilityprofile[id=current()/../@id]"/>
  <xsl:choose>
    <xsl:when test="$cpbprf.cur/description/para">
      <xsl:copy-of select="$cpbprf.cur/description"/>
    </xsl:when>
    <xsl:otherwise>
      <description>
        <xsl:apply-templates/>
      </description>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!--
  Replace the URI of the external standard information to a link to the standard information
  available in the NISP viewer. -->

  <xsl:template match="standard/status/uri">
  <uri>
    <xsl:choose>
      <xsl:when test="not ($replace.standard.uri = 'yes')">
        <xsl:value-of select="."/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$nisp.viewer.pathname"/>
        <xsl:choose>
          <xsl:when test="$nisp.viewer.target.type = 'local'">
            <xsl:value-of select="concat($nisp.viewer.standard.detail,'.html?refid=',../../@id)"/>
          </xsl:when>
          <xsl:when test="$nisp.viewer.target.type = 'aspdotnet'">
            <xsl:value-of select="concat($nisp.viewer.standard.detail,'.aspx?refid=',../../@id)"/>
          </xsl:when>
          <xsl:otherwise>
            <!-- Use default path to NISP viewer -->
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </uri>
</xsl:template>

</xsl:stylesheet>
